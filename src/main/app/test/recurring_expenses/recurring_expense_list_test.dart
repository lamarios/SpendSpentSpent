import 'dart:async';
import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_loading_indicator/loading_indicator.dart';
import 'package:nock/nock.dart';
import 'package:spend_spent_spent/categories/models/category.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/recurring_expenses/models/recurring_expense.dart';
import 'package:spend_spent_spent/recurring_expenses/state/recurring_expenses.dart';
import 'package:spend_spent_spent/recurring_expenses/views/components/recurring_expense_list.dart';
import 'package:spend_spent_spent/router.dart';
import 'package:spend_spent_spent/service.dart';

import '../helper_widget/test_app_setup_widget.dart';
import '../utils/test_utils.dart';

void main() {
  final category = Category(categoryOrder: 0, icon: 'house', id: 1, user: testUser);

  String rent(String nextOccurrence) => jsonEncode([
    RecurringExpense(
      id: 1,
      name: 'Rent',
      amount: 1200,
      type: 2,
      typeParam: 5,
      category: category,
      nextOccurrence: nextOccurrence,
    ).toJson(),
  ]);

  setUpAll(() {
    nock.init();
  });

  setUp(() async {
    await setupTests(loggedIn: true, categories: [category]);
    // the app settings read the server config
    nock(validServerUrl).get('/config')
      ..reply(200, loadFixture('valid_server_config.json'))
      ..persist(true);
  });

  tearDown(() {
    nock.cleanAll();
  });

  Future<void> resumeApp(WidgetTester tester) async {
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
  }

  testWidgets('The list is refreshed when the app comes back to the foreground', (tester) async {
    nock(validServerUrl).get('/API/RecurringExpense').reply(200, rent('2026-11-05'));
    await tester.pumpWidget(TestSetup(child: RecurringExpenseListTab()));
    await tester.pumpAndSettle();
    expect(find.text('Next: 2026-11-05'), findsOneWidget);

    // the server processed the recurring expense in the meantime
    final refresh = nock(validServerUrl).get('/API/RecurringExpense')..reply(200, rent('2026-12-05'));
    await resumeApp(tester);
    await tester.pump();
    // refreshed in the background, the list stays
    expect(find.byType(LoadingIndicator), findsNothing);
    await tester.pumpAndSettle();

    expect(refresh.isDone, true);
    expect(find.text('Next: 2026-12-05'), findsOneWidget);
  });

  testWidgets('A failed background refresh keeps the list', (tester) async {
    nock(validServerUrl).get('/API/RecurringExpense').reply(200, rent('2026-11-05'));
    await tester.pumpWidget(TestSetup(child: RecurringExpenseListTab()));
    await tester.pumpAndSettle();

    final refresh = nock(validServerUrl).get('/API/RecurringExpense')..reply(500, 'Server error');
    await resumeApp(tester);
    await tester.pumpAndSettle();

    expect(refresh.isDone, true);
    expect(find.text('Next: 2026-11-05'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('An older answer does not bring back a deleted expense', (tester) async {
    final rentExpenses = (jsonDecode(rent('2026-11-05')) as List).map((e) => RecurringExpense.fromJson(e)).toList();
    final answers = <Completer<List<RecurringExpense>>>[];
    final previousService = service;
    service = _AnsweredLaterService(answers)
      ..url = previousService.url
      ..version = previousService.version;
    addTearDown(() => service = previousService);

    await tester.pumpWidget(TestSetup(child: RecurringExpenseListTab()));
    answers.removeAt(0).complete(rentExpenses);
    await tester.pumpAndSettle();
    expect(find.text('Next: 2026-11-05'), findsOneWidget);

    // a background refresh, then the expense is deleted and the list loaded again
    await resumeApp(tester);
    tester.element(find.byType(RefreshWhenShown)).read<RecurringExpensesCubit>().getRecurringExpenses();
    expect(answers.length, 2);

    // the list without the expense comes first, the background refresh with it last
    answers[1].complete([]);
    await tester.pumpAndSettle();
    answers[0].complete(rentExpenses);
    await tester.pumpAndSettle();

    expect(find.text('Next: 2026-11-05'), findsNothing);
  });

  testWidgets('A failed background refresh does not drop the first load', (tester) async {
    final rentExpenses = (jsonDecode(rent('2026-11-05')) as List).map((e) => RecurringExpense.fromJson(e)).toList();
    final answers = <Completer<List<RecurringExpense>>>[];
    final previousService = service;
    service = _AnsweredLaterService(answers)
      ..url = previousService.url
      ..version = previousService.version;
    addTearDown(() => service = previousService);

    // the app comes back to the foreground while the list is loaded for the first time
    await tester.pumpWidget(TestSetup(child: RecurringExpenseListTab()));
    await resumeApp(tester);
    expect(answers.length, 2);

    answers[1].completeError(Exception('offline'));
    await tester.pump();
    answers[0].complete(rentExpenses);
    await tester.pumpAndSettle();

    expect(find.text('Next: 2026-11-05'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('An older failure is not shown once a newer request is running', (tester) async {
    final rentExpenses = (jsonDecode(rent('2026-11-05')) as List).map((e) => RecurringExpense.fromJson(e)).toList();
    final answers = <Completer<List<RecurringExpense>>>[];
    final previousService = service;
    service = _AnsweredLaterService(answers)
      ..url = previousService.url
      ..version = previousService.version;
    addTearDown(() => service = previousService);

    // the first load fails while the background refresh started after it is still running
    await tester.pumpWidget(TestSetup(child: RecurringExpenseListTab()));
    await resumeApp(tester);
    expect(answers.length, 2);

    answers[0].completeError(Exception('offline'));
    await tester.pump();
    expect(find.byType(LoadingIndicator), findsOneWidget);
    answers[1].complete(rentExpenses);
    await tester.pumpAndSettle();

    expect(find.text('Next: 2026-11-05'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('The loading indicator ends when all requests failed', (tester) async {
    final answers = <Completer<List<RecurringExpense>>>[];
    final previousService = service;
    service = _AnsweredLaterService(answers)
      ..url = previousService.url
      ..version = previousService.version;
    addTearDown(() => service = previousService);

    await tester.pumpWidget(TestSetup(child: RecurringExpenseListTab()));
    await resumeApp(tester);
    answers[0].completeError(Exception('offline'));
    await tester.pump();
    answers[1].completeError(Exception('offline'));
    await tester.pumpAndSettle();

    expect(find.byType(LoadingIndicator), findsNothing);
  });

  testWidgets('The list is refreshed when it is shown again from the main menu', (tester) async {
    final router = _TestRouter();
    await tester.pumpWidget(RouterTestSetup(router: router));
    nock(validServerUrl).get('/API/RecurringExpense').reply(200, rent('2026-11-05'));
    await tester.pumpAndSettle();
    final columnTabs = _tabsRouter(tester, _column);
    columnTabs.setActiveIndex(1);
    await tester.pumpAndSettle();
    expect(find.text('Next: 2026-11-05'), findsOneWidget);

    // another column of the main menu, the recurring tab stays selected
    final mainTabs = _tabsRouter(tester, _main);
    mainTabs.setActiveIndex(1);
    await tester.pumpAndSettle();
    final refresh = nock(validServerUrl).get('/API/RecurringExpense')..reply(200, rent('2026-12-05'));
    mainTabs.setActiveIndex(0);
    await tester.pumpAndSettle();
    expect(refresh.isDone, true);
    expect(find.text('Next: 2026-12-05'), findsOneWidget);

    // a page pushed on top, like the settings
    router.push(const PageRouteInfo(_pushed));
    await tester.pumpAndSettle();
    final again = nock(validServerUrl).get('/API/RecurringExpense')..reply(200, rent('2027-01-05'));
    router.pop();
    await tester.pumpAndSettle();
    expect(again.isDone, true);
    expect(find.text('Next: 2027-01-05'), findsOneWidget);
  });
}

const _main = 'TestMainRoute', _otherColumn = 'TestOtherColumnRoute', _column = 'TestColumnRoute';
const _normal = 'TestNormalRoute', _pushed = 'TestPushedRoute';

TabsRouter _tabsRouter(WidgetTester tester, String key) => AutoTabsRouter.of(tester.element(find.byKey(ValueKey(key))));

PageInfo _tabs(String name, List<PageRouteInfo> routes) => PageInfo(
  name,
  builder: (_) => AutoTabsRouter(
    routes: routes,
    builder: (context, child) => KeyedSubtree(key: ValueKey(name), child: child),
  ),
);

PageInfo _page(String name) => PageInfo(name, builder: (_) => Text(name));

/// The routers of the app around the recurring tab: the main menu with its columns, the tabs of a column and the pages
/// pushed on top.
class _TestRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: _tabs(_main, const [PageRouteInfo(_column), PageRouteInfo(_otherColumn)]),
      initial: true,
      children: [
        AutoRoute(page: _page(_otherColumn)),
        AutoRoute(
          page: _tabs(_column, const [PageRouteInfo(_normal), RecurringExpenseListRoute()]),
          children: [
            AutoRoute(page: _page(_normal)),
            AutoRoute(page: RecurringExpenseListRoute.page),
          ],
        ),
      ],
    ),
    AutoRoute(page: _page(_pushed)),
  ];
}

/// Answers the requests for the recurring expenses when the test completes them.
class _AnsweredLaterService extends Service {
  final List<Completer<List<RecurringExpense>>> answers;

  _AnsweredLaterService(this.answers);

  @override
  Future<List<RecurringExpense>> getRecurringExpenses() {
    final answer = Completer<List<RecurringExpense>>();
    answers.add(answer);
    return answer.future;
  }
}
