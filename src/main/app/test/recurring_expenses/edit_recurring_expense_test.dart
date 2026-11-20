import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nock/nock.dart';
import 'package:spend_spent_spent/categories/models/category.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/recurring_expenses/models/recurring_expense.dart';
import 'package:spend_spent_spent/recurring_expenses/state/add_recurring_expense.dart';
import 'package:spend_spent_spent/recurring_expenses/views/components/recurring_expense_dialog/step2.dart';
import 'package:spend_spent_spent/settings/models/config.dart';

import '../utils/test_utils.dart';

void main() {
  final house = Category(categoryOrder: 0, icon: 'house', id: 1, user: testUser);
  final cloud = Category(categoryOrder: 1, icon: 'cloud', id: 2, user: testUser);

  final next = DateTime.now().add(const Duration(days: 20));
  final nextOccurrence = '${next.year}-${next.month.toString().padLeft(2, '0')}-15';
  final lastOccurrence = '${next.year - 1}-${next.month.toString().padLeft(2, '0')}-15';

  final gym = RecurringExpense(
    id: 7,
    category: house,
    amount: 12.34,
    name: 'gym',
    type: 2,
    typeParam: 15,
    nextOccurrence: nextOccurrence,
    lastOccurrence: lastOccurrence,
  );

  group('Editing', () {
    setUpAll(() {
      nock.init();
    });

    tearDown(() {
      nock.cleanAll();
      service.config = null;
    });

    /// The config of a server from before the schedule could be changed, with what's added to it.
    Config config([Map<String, dynamic> added = const {}]) => Config.fromJson({
      ...jsonDecode(loadFixture('valid_server_config.json')),
      'canChooseRecurringFirstOccurrence': true,
      ...added,
    });

    final current = config({'canEditRecurringSchedule': true});

    Future<AddRecurringExpenseCubit> open({Config? serverConfig}) async {
      await setupTests(loggedIn: true, categories: [house, cloud]);
      service.config = serverConfig ?? current;
      final cubit = AddRecurringExpenseCubit(editRecurringExpenseState(gym), editing: gym);
      // it loads the categories
      await pumpEventQueue();
      return cubit;
    }

    Future<Map<String, dynamic>> save(AddRecurringExpenseCubit cubit) async {
      Map<String, dynamic>? sent;
      // an untyped matcher gets the raw body
      final request = nock(validServerUrl).post('/API/RecurringExpense/7', (body) {
        sent = jsonDecode(utf8.decode(body as List<int>));
        return true;
      })..reply(200, 'true');

      await cubit.save();

      expect(request.isDone, isTrue);
      return sent!;
    }

    test('starts with the recurring expense as it is', () async {
      final cubit = await open();

      expect(cubit.state.category, house);
      expect(cubit.state.amount, '1234');
      expect(cubit.state.name, 'gym');
      expect(cubit.nameController.text, 'gym');
      expect(cubit.state.type, 2);
      expect(cubit.state.typeParam, 15);
      expect(cubit.state.firstOccurrence, DateTime.parse(nextOccurrence));
      expect(cubit.state.firstOccurrenceChosen, isFalse);
      expect(cubit.lastOccurrence, DateTime.parse(lastOccurrence));
    });

    test('the rest is changed and the server keeps its next occurrence', () async {
      final cubit = await open();
      cubit.setCategory(cloud);
      cubit.nameController.text = 'swimming';
      cubit.setAmount('2500');

      final sent = await save(cubit);

      expect(sent['id'], 7);
      expect(sent['category']['id'], 2);
      expect(sent['name'], 'swimming');
      expect(sent['amount'], 25.0);
      expect(sent['type'], 2);
      expect(sent['typeParam'], 15);
      // the background job might have booked it since the dialog was opened
      expect(sent['nextOccurrence'], isNull);
    });

    test('a new schedule shows where the server starts it, and sends none', () async {
      final cubit = await open();
      cubit.setTypeParam(1);

      expect(cubit.state.firstOccurrence, defaultFirstOccurrence(2, 1, DateTime.now()));
      final sent = await save(cubit);
      expect(sent['typeParam'], 1);
      expect(sent['nextOccurrence'], isNull);
    });

    test('going back to the schedule shows its next occurrence again', () async {
      final cubit = await open();
      cubit.setType(1);
      expect(cubit.state.firstOccurrence, isNull);
      cubit.setType(2);
      cubit.setTypeParam(15);

      expect(cubit.state.firstOccurrence, DateTime.parse(nextOccurrence));
      expect((await save(cubit))['nextOccurrence'], isNull);
    });

    test('a chosen next occurrence is sent', () async {
      final cubit = await open();
      cubit.setFirstOccurrence(DateTime(next.year + 1, 3, 15, 12));

      expect((await save(cubit))['nextOccurrence'], '${next.year + 1}-03-15');
    });

    test('a chosen next occurrence is sent with a new schedule', () async {
      final cubit = await open();
      cubit.setTypeParam(1);
      cubit.setFirstOccurrence(DateTime(next.year + 1, 3, 1));

      final sent = await save(cubit);
      expect(sent['type'], 2);
      expect(sent['typeParam'], 1);
      expect(sent['nextOccurrence'], '${next.year + 1}-03-01');
    });

    test('daily ones are sent with 0 as before', () async {
      final cubit = await open();
      cubit.setType(0);

      final sent = await save(cubit);
      expect(sent['type'], 0);
      expect(sent['typeParam'], 0);
      expect(sent['nextOccurrence'], isNull);
    });

    test('older servers would keep the next occurrence, the schedule stays as it is', () async {
      final cubit = await open(serverConfig: config());

      expect(cubit.canEditSchedule, isFalse);
      expect(cubit.state.firstOccurrence, isNull);
      cubit.setType(1);
      cubit.setTypeParam(3);
      expect(cubit.state.type, 2);
      expect(cubit.state.typeParam, 15);

      cubit.setAmount('999');
      final sent = await save(cubit);
      expect(sent['type'], 2);
      expect(sent['typeParam'], 15);
      expect(sent['nextOccurrence'], isNull);
      expect(sent['amount'], 9.99);
    });

    test('a new schedule starts after the last occurrence when that was today', () async {
      final now = DateTime.now();
      final today = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      final bookedToday = gym.copyWith(type: 1, typeParam: now.weekday % 7 + 1, lastOccurrence: today);
      await setupTests(loggedIn: true, categories: [house, cloud]);
      service.config = current;
      final cubit = AddRecurringExpenseCubit(editRecurringExpenseState(bookedToday), editing: bookedToday);
      await pumpEventQueue();

      cubit.setType(0);

      expect(cubit.state.firstOccurrence, DateTime(now.year, now.month, now.day + 1));
      expect(
        firstOccurrenceRange(cubit.state.firstOccurrence, now, after: cubit.lastOccurrence).first,
        DateTime(now.year, now.month, now.day + 1),
      );
    });

    test('the next occurrence is shown when the server config arrives', () async {
      await setupTests(loggedIn: true, categories: [house, cloud]);
      final request = nock(validServerUrl).get('/config')..reply(200, jsonEncode(current.toJson()));

      final cubit = AddRecurringExpenseCubit(editRecurringExpenseState(gym), editing: gym);
      expect(cubit.state.firstOccurrence, isNull);
      await pumpEventQueue();

      expect(request.isDone, isTrue);
      expect(cubit.canEditSchedule, isTrue);
      expect(cubit.state.firstOccurrence, DateTime.parse(nextOccurrence));
    });
  });

  group('The next occurrence can be chosen', () {
    final now = DateTime(2026, 11, 20, 15, 30);

    test('after the last one', () {
      expect(firstOccurrenceRange(null, now, after: DateTime(2026, 11, 1)).first, DateTime(2026, 11, 2));
      expect(firstOccurrenceRange(null, now, after: DateTime(2026, 11, 20)).first, DateTime(2026, 11, 21));
    });

    test('from a year ago on when the last one is older', () {
      expect(firstOccurrenceRange(null, now, after: DateTime(2025, 6, 1)).first, DateTime(2025, 11, 21));
      expect(firstOccurrenceRange(null, now).first, DateTime(2025, 11, 21));
    });
  });

  group('The schedule step when editing', () {
    Future<void> show(WidgetTester tester, {required bool scheduleEditable}) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Step2(
              type: 2,
              typeParam: 15,
              firstOccurrence: scheduleEditable ? DateTime.parse(nextOccurrence) : null,
              editing: true,
              scheduleEditable: scheduleEditable,
              setType: (_) {},
              setTypeParam: (_) {},
              setFirstOccurrence: (_) {},
            ),
          ),
        ),
      );
    }

    testWidgets('shows the next payment', (tester) async {
      await show(tester, scheduleEditable: true);

      expect(find.text('Next payment'), findsOneWidget);
      expect(find.text(nextOccurrence), findsOneWidget);
      expect(find.textContaining('newer server'), findsNothing);
    });

    testWidgets('says when the server cannot change the schedule', (tester) async {
      await show(tester, scheduleEditable: false);

      expect(find.textContaining('newer server'), findsOneWidget);
      expect(find.text('Next payment'), findsNothing);
    });
  });
}
