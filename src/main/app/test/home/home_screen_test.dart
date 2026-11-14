import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nock/nock.dart';
import 'package:spend_spent_spent/categories/models/category.dart';
import 'package:spend_spent_spent/categories/state/categories.dart';
import 'package:spend_spent_spent/expenses/state/last_expense.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/households/states/household.dart';
import 'package:spend_spent_spent/identity/states/username_password.dart';
import 'package:spend_spent_spent/notification_listener/states/notification_tapped.dart';
import 'package:spend_spent_spent/recurring_expenses/models/recurring_expense.dart';
import 'package:spend_spent_spent/recurring_expenses/views/components/recurring_expense_list.dart';
import 'package:spend_spent_spent/router.dart';
import 'package:spend_spent_spent/settings/state/app_settings.dart';
import 'package:spend_spent_spent/utils/models/socket_message.dart';

import '../utils/mock_socket.dart';
import '../utils/test_utils.dart';

void main() {
  final category = Category(categoryOrder: 0, icon: 'house', id: 1, user: testUser);

  String recurring(String name) => jsonEncode([
    RecurringExpense(
      id: 1,
      name: name,
      amount: 1200,
      type: 2,
      typeParam: 5,
      category: category,
      nextOccurrence: '2026-12-05',
    ).toJson(),
  ]);

  setUpAll(() {
    nock.init();
  });

  setUp(() async {
    await setupTests(loggedIn: true, categories: [category]);
    nock(validServerUrl).get('/config')
      ..reply(200, loadFixture('valid_server_config.json'))
      ..persist(true);
    nock(validServerUrl).get('/API/Household')
      ..reply(200, '')
      ..persist(true);
    nock(validServerUrl).get('/API/Household/invites')
      ..reply(200, '[]')
      ..persist(true);
    nock(validServerUrl).get('/API/Expense/last')
      ..reply(200, '0')
      ..persist(true);
  });

  tearDown(() {
    nock.cleanAll();
  });

  Future<void> showHome(WidgetTester tester, _TestRouter router) async {
    await tester.pumpWidget(_App(router: router));
    await tester.pump();
    // the home screen waits for the categories at its start
    getIt<CategoriesCubit>().getCategories(true);
    await tester.pumpAndSettle();
  }

  Future<void> householdUpdate(WidgetTester tester) async {
    (getIt<UsernamePasswordCubit>().socket as MockSocket).receiveMessage(
      SssSocketMessage(message: const {}, type: SssSocketMessageType.householdUpdate),
    );
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
  }

  testWidgets('The recurring expenses are reloaded when the household changes', (tester) async {
    nock(validServerUrl).get('/API/RecurringExpense').reply(200, recurring('Mine'));
    await showHome(tester, _TestRouter());
    expect(find.text('Mine'), findsOneWidget);

    // another member joined
    final reload = nock(validServerUrl).get('/API/RecurringExpense')..reply(200, recurring('Theirs'));
    await householdUpdate(tester);

    expect(reload.isDone, true);
    expect(find.text('Theirs'), findsOneWidget);
    expect(find.text('Mine'), findsNothing);
  });

  testWidgets('The recurring expenses are reloaded when coming back from the settings', (tester) async {
    nock(validServerUrl).get('/API/RecurringExpense').reply(200, recurring('Mine'));
    final router = _TestRouter();
    await showHome(tester, router);

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();

    // the household was left in the settings
    final reload = nock(validServerUrl).get('/API/RecurringExpense')..reply(200, recurring('Only mine'));
    router.pop();
    await tester.pumpAndSettle();

    expect(reload.isDone, true);
    expect(find.text('Only mine'), findsOneWidget);
  });

  testWidgets('A failed reload keeps the list', (tester) async {
    nock(validServerUrl).get('/API/RecurringExpense').reply(200, recurring('Mine'));
    await showHome(tester, _TestRouter());

    final reload = nock(validServerUrl).get('/API/RecurringExpense')..reply(500, 'Server error');
    await householdUpdate(tester);

    expect(reload.isDone, true);
    expect(find.text('Mine'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('The recurring expenses are not loaded before their tab is shown', (tester) async {
    final load = nock(validServerUrl).get('/API/RecurringExpense')..reply(200, recurring('Mine'));
    await showHome(tester, _TestRouter(recurringFirst: false));

    await householdUpdate(tester);

    expect(load.isDone, false);
    expect(find.byType(RecurringExpenseListTab), findsNothing);
  });
}

const _other = 'TestOtherRoute';

PageInfo _page(String name) => PageInfo(name, builder: (_) => Text(name));

/// The home screen with the recurring tab and the settings as a page without the content of the settings.
class _TestRouter extends RootStackRouter {
  final bool recurringFirst;

  _TestRouter({this.recurringFirst = true});

  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: HomeRoute.page,
      initial: true,
      children: [
        AutoRoute(page: RecurringExpenseListRoute.page, initial: recurringFirst),
        AutoRoute(page: _page(_other), initial: !recurringFirst),
      ],
    ),
    AutoRoute(page: _page(SettingsRoute.name)),
  ];
}

class _App extends StatelessWidget {
  final RootStackRouter router;

  const _App({required this.router});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt.get<CategoriesCubit>()),
        BlocProvider(create: (context) => LastExpenseCubit(0)),
        BlocProvider(create: (context) => AppSettingsCubit(const AppSettingsState())),
        BlocProvider(create: (context) => getIt.get<UsernamePasswordCubit>()),
        BlocProvider(create: (context) => getIt.get<HouseholdCubit>()),
        BlocProvider(create: (context) => getIt.get<NotificationTappedCubit>()),
      ],
      child: MaterialApp.router(routerConfig: router.config()),
    );
  }
}
