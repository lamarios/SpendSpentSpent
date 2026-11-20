import 'dart:convert';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nock/nock.dart';
import 'package:spend_spent_spent/categories/models/category.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/recurring_expenses/state/add_recurring_expense.dart';
import 'package:spend_spent_spent/recurring_expenses/views/components/recurring_expense_dialog/step2.dart';
import 'package:spend_spent_spent/settings/models/config.dart';

import '../utils/test_utils.dart';

void main() {
  // a Friday
  final now = DateTime(2026, 11, 13, 15, 30);

  group('The first occurrence defaults to the next one from today on, as the server calculates it', () {
    test('daily', () {
      expect(defaultFirstOccurrence(0, null, now), DateTime(2026, 11, 13));
    });

    test('weekly, the type parameter counts from Sunday = 1', () {
      expect(defaultFirstOccurrence(1, 2, now), DateTime(2026, 11, 16));
      expect(defaultFirstOccurrence(1, 6, now), DateTime(2026, 11, 13));
      expect(defaultFirstOccurrence(1, 7, now), DateTime(2026, 11, 14));
      expect(defaultFirstOccurrence(1, 1, now), DateTime(2026, 11, 15));
    });

    test('monthly', () {
      expect(defaultFirstOccurrence(2, 1, now), DateTime(2026, 12, 1));
      expect(defaultFirstOccurrence(2, 13, now), DateTime(2026, 11, 13));
      expect(defaultFirstOccurrence(2, 20, now), DateTime(2026, 11, 20));
      expect(defaultFirstOccurrence(2, 1, DateTime(2026, 12, 2)), DateTime(2027, 1, 1));
    });

    test('yearly, the type parameter is the month from 0', () {
      expect(defaultFirstOccurrence(3, 11, now), DateTime(2026, 12, 1));
      // today in the current month, like the server
      expect(defaultFirstOccurrence(3, 10, now), DateTime(2026, 11, 13));
      expect(defaultFirstOccurrence(3, 2, now), DateTime(2027, 3, 1));
    });

    test('none until the schedule is complete', () {
      expect(defaultFirstOccurrence(2, null, now), isNull);
      expect(defaultFirstOccurrence(null, null, now), isNull);
    });

    test('it is the first day on the schedule from today on and in the date picker range', () {
      // around a year change, a daylight saving change in Europe and a leap day
      for (final at in [
        now,
        DateTime(2026, 12, 31, 23),
        DateTime(2027, 1, 1),
        DateTime(2027, 3, 28, 12),
        DateTime(2028, 2, 29),
        DateTime(2026, 11, 30),
      ]) {
        final today = DateTime(at.year, at.month, at.day);
        final range = firstOccurrenceRange(null, at);
        for (final (type, params) in [
          (0, [0]),
          (1, [for (var i = 1; i <= 7; i++) i]),
          (2, [for (var i = 1; i <= 28; i++) i]),
          (3, [for (var i = 0; i < 12; i++) i]),
        ]) {
          for (final param in params) {
            final first = defaultFirstOccurrence(type, param, at)!;
            var expected = today;
            // the server starts a yearly one of the current month today, whatever the day
            if (!(type == 3 && param + 1 == today.month)) {
              while (!isOnSchedule(type, param, expected)) {
                expected = DateTime(expected.year, expected.month, expected.day + 1);
              }
            }
            expect(first, expected, reason: '$at $type $param');
            expect(first.isBefore(range.first) || first.isAfter(range.last), isFalse, reason: '$at $type $param');
          }
        }
      }
    });
  });

  test('Only dates on the schedule can be chosen', () {
    expect(isOnSchedule(1, 2, DateTime(2026, 11, 16)), isTrue);
    expect(isOnSchedule(1, 2, DateTime(2026, 11, 17)), isFalse);
    expect(isOnSchedule(2, 15, DateTime(2026, 12, 15)), isTrue);
    expect(isOnSchedule(2, 15, DateTime(2026, 12, 14)), isFalse);
    expect(isOnSchedule(3, 2, DateTime(2027, 3, 20)), isTrue);
    expect(isOnSchedule(3, 2, DateTime(2027, 4, 1)), isFalse);
    // it would move to the 28th
    expect(isOnSchedule(3, 1, DateTime(2028, 2, 29)), isFalse);
    expect(isOnSchedule(0, 0, DateTime(2027, 4, 1)), isTrue);
  });

  test('A first occurrence chosen before midnight can still be shown in the date picker after it', () {
    expect(firstOccurrenceRange(DateTime(2026, 1, 1), DateTime(2027, 1, 1, 0, 5)).first, DateTime(2026, 1, 1));
    expect(firstOccurrenceRange(DateTime(2026, 6, 1), DateTime(2027, 1, 1, 0, 5)).first, DateTime(2026, 1, 2));
  });

  group('Adding', () {
    final category = Category(categoryOrder: 0, icon: 'house', id: 1, user: testUser);

    setUpAll(() {
      nock.init();
    });

    tearDown(() {
      nock.cleanAll();
      service.config = null;
    });

    /// The config of a server from before the first occurrence, with what's added to it.
    Config config([Map<String, dynamic> added = const {}]) =>
        Config.fromJson({...jsonDecode(loadFixture('valid_server_config.json')), ...added});

    Future<Map<String, dynamic>> add(void Function(AddRecurringExpenseCubit cubit) fill, {Config? serverConfig}) async {
      await setupTests(loggedIn: true, categories: [category]);
      service.config = serverConfig ?? config({'canChooseRecurringFirstOccurrence': true});
      Map<String, dynamic>? sent;
      // an untyped matcher gets the raw body
      final request = nock(validServerUrl).post('/API/RecurringExpense', (body) {
        sent = jsonDecode(utf8.decode(body as List<int>));
        return true;
      })..reply(200, '{}');

      final cubit = AddRecurringExpenseCubit(const AddRecurringExpenseState());
      cubit.setCategory(category);
      cubit.setAmount('1000');
      fill(cubit);
      await cubit.addRecurringExpense();

      expect(request.isDone, isTrue);
      return sent!;
    }

    test('the first occurrence is shown but only sent when another one is chosen', () async {
      final today = DateTime.now();
      final kept = await add((cubit) {
        cubit.setType(2);
        cubit.setTypeParam(1);
        expect(cubit.state.firstOccurrence, defaultFirstOccurrence(2, 1, today));
      });
      // the server calculates it, as it always did
      expect(kept['nextOccurrence'], isNull);
      expect(kept['typeParam'], 1);
      nock.cleanAll();

      final sent = await add((cubit) {
        cubit.setType(2);
        cubit.setTypeParam(1);
        cubit.setFirstOccurrence(DateTime(today.year + 1, 2, 1, 12));
      });

      expect(sent['nextOccurrence'], '${today.year + 1}-02-01');
      expect(sent['type'], 2);
      expect(sent['typeParam'], 1);
    });

    test('a new schedule resets the first occurrence', () async {
      final today = DateTime.now();
      final sent = await add((cubit) {
        cubit.setType(2);
        cubit.setTypeParam(1);
        cubit.setFirstOccurrence(DateTime(today.year + 1, 2, 1));
        cubit.setTypeParam(15);
        expect(cubit.state.firstOccurrence, defaultFirstOccurrence(2, 15, today));
        expect(cubit.state.firstOccurrenceChosen, isFalse);
        cubit.setType(1);
        expect(cubit.state.firstOccurrence, isNull);
        cubit.setType(0);
      });

      expect(sent['nextOccurrence'], isNull);
    });

    test('the first occurrence is shown when the server config arrives after the schedule was chosen', () async {
      await setupTests(loggedIn: true, categories: [category]);
      final request = nock(validServerUrl).get('/config')
        ..reply(
          200,
          jsonEncode({
            ...jsonDecode(loadFixture('valid_server_config.json')),
            'canChooseRecurringFirstOccurrence': true,
          }),
        );

      final cubit = AddRecurringExpenseCubit(const AddRecurringExpenseState());
      cubit.setType(2);
      cubit.setTypeParam(1);
      expect(cubit.state.firstOccurrence, isNull);

      await pumpEventQueue();

      expect(request.isDone, isTrue);
      expect(cubit.state.firstOccurrence, defaultFirstOccurrence(2, 1, DateTime.now()));
      expect(cubit.state.firstOccurrenceChosen, isFalse);
    });

    test('the dialog shares the request for the server config made at start up', () async {
      await setupTests(loggedIn: true, categories: [category]);
      // a second request would fail
      final request = nock(validServerUrl).get('/config')
        ..reply(200, jsonEncode(config({'canChooseRecurringFirstOccurrence': true}).toJson()));

      final startUp = service.getCurrentServerConfig();
      final cubit = AddRecurringExpenseCubit(const AddRecurringExpenseState());
      cubit.setType(2);
      cubit.setTypeParam(1);

      await startUp;
      await pumpEventQueue();

      expect(request.isDone, isTrue);
      expect(cubit.state.firstOccurrence, defaultFirstOccurrence(2, 1, DateTime.now()));
    });

    test('older servers would ignore the first occurrence, it is neither offered nor sent', () async {
      expect(config().canChooseRecurringFirstOccurrence, isFalse);
      final sent = await add((cubit) {
        cubit.setType(2);
        cubit.setTypeParam(1);
        expect(cubit.state.firstOccurrence, isNull);
      }, serverConfig: config());

      expect(sent['nextOccurrence'], isNull);
      expect(sent['typeParam'], 1);
    });
  });

  group('The first payment field', () {
    Future<void> show(WidgetTester tester, DateTime? firstOccurrence) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Step2(
              type: 2,
              typeParam: 1,
              firstOccurrence: firstOccurrence,
              setType: (_) {},
              setTypeParam: (_) {},
              setFirstOccurrence: (_) {},
            ),
          ),
        ),
      );
    }

    testWidgets('shows the date', (tester) async {
      final next = DateTime.now().add(const Duration(days: 40));
      await show(tester, DateTime(next.year, next.month, 1));

      expect(find.text('First payment'), findsOneWidget);
      expect(find.text('${next.year}-${next.month.toString().padLeft(2, '0')}-01'), findsOneWidget);
      expect(find.textContaining('Already past'), findsNothing);
    });

    testWidgets('says when a past one is added', (tester) async {
      await show(tester, DateTime.now().subtract(const Duration(days: 40)));

      expect(find.textContaining('Already past'), findsOneWidget);
    });

    testWidgets('is hidden until the schedule is complete', (tester) async {
      await show(tester, null);

      expect(find.text('First payment'), findsNothing);
    });
  });
}
