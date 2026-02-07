import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nock/nock.dart';
import 'package:snaptest/snaptest.dart';
import 'package:spend_spent_spent/add_expense_dialog/views/components/add_expense.dart';
import 'package:spend_spent_spent/add_expense_dialog/views/components/expense_note_dialog.dart';
import 'package:spend_spent_spent/add_expense_dialog/views/components/note_suggestion_pill.dart';
import 'package:spend_spent_spent/categories/models/category.dart';
import 'package:spend_spent_spent/expenses/models/expense.dart';
import 'package:spend_spent_spent/icons.dart';

import '../helper_widget/test_app_setup_widget.dart';
import '../utils/test_utils.dart';

void main() {
  var categories = List<Category>.from([
    Category(categoryOrder: 0, icon: 'google', id: 1, user: testUser),
    Category(categoryOrder: 1, icon: 'food', id: 2, user: testUser),
    Category(categoryOrder: 2, icon: 'apple', id: 3, user: testUser),
    Category(categoryOrder: 3, icon: 'cloud', id: 4, user: testUser),
  ]);

  setUpAll(() {
    nock.init();
  });

  setUp(() async {
    await setupTests(loggedIn: true, categories: categories);
    nock.cleanAll();
  });

  testWidgets('Test note dialog', (tester) async {
    await tester.pumpWidget(TestSetup(child: AddExpense(canChangeCategory: false, category: categories.first)));
    await tester.pump(Duration(seconds: 1));

    final noteButton = find.byIcon(Icons.comment_rounded);
    expect(noteButton, findsOneWidget);

    await tester.tap(noteButton);
    await tester.pumpAndSettle();

    var dialog = find.byType(ExpenseNoteDialog);
    var ok = find.text('Ok');
    var cancel = find.text('Cancel');

    expect(dialog, findsOneWidget);

    expect(ok, findsOneWidget);
    expect(cancel, findsOneWidget);

    var textField = find.descendant(of: dialog, matching: find.byType(TextField));
    expect(textField, findsOneWidget);

    var autoComplete = nock(validServerUrl).post('/API/Expense/notes-autocomplete', (body) => true)
      ..reply(200, '{"suggestion 1": 5, "suggestion 2":10}');

    await tester.enterText(textField, 'some note');
    await tester.pump(Duration(seconds: 1));
    expect(autoComplete.isDone, true);
    await snap(name: 'expense_note_dialog', matchToGolden: true, from: dialog);

    var suggestion1 = find.text('suggestion 1');
    var suggestion2 = find.text('suggestion 2');
    expect(suggestion1, findsOneWidget);
    expect(suggestion2, findsOneWidget);

    await tester.tap(suggestion2);
    await tester.pumpAndSettle();

    // the suggestion button and now the text field should also have the 'suggestion 2' as text
    expect(suggestion2, findsNWidgets(2));

    final clearButton = find.byIcon(Icons.clear);
    expect(clearButton, findsOneWidget);

    await tester.tap(clearButton);
    await tester.pump(Duration(seconds: 1));
    expect(suggestion2, findsNWidgets(0));

    autoComplete = nock(validServerUrl).post('/API/Expense/notes-autocomplete', (body) => true)
      ..reply(200, '{}');

    await tester.enterText(textField, 'my note');
    await tester.pump(Duration(seconds: 1));

    expect(autoComplete.isDone, true);

     await tester.tap(ok);
     await tester.pumpAndSettle();
     await snap(name: 'note_saved');
     expect(dialog, findsNothing);

     expect(find.text('my note'), findsOneWidget);


  });

  testWidgets('Test expense basic flow dialog', (tester) async {
    await tester.pumpWidget(TestSetup(child: AddExpense(canChangeCategory: false, category: categories.first)));

    // for this test we don't care about suggestions
    var suggestions = nock(validServerUrl).post('/API/Expense/suggest-notes', (body) => true)
      ..reply(200, '{"google drive": 11}');

    await tester.pumpAndSettle();
    await tester.pump(Duration(seconds: 1));

    await snap(name: 'expense_dialog', matchToGolden: true);

    final categoryIcon = find.text(iconMap['google']!);
    expect(categoryIcon, findsAtLeastNWidgets(1));

    final saveButton = find.ancestor(of: find.text('Save'), matching: find.byType(FilledButton));
    expect(saveButton, findsOneWidget);

    FilledButton saveButtonWidget = tester.widget(saveButton);
    expect(saveButtonWidget.enabled, false);

    // default amount should be 0.00
    expect(find.text('0.00'), findsOneWidget);

    final button0 = find.text('0');
    final button1 = find.text('1');
    final button2 = find.text('2');
    final button3 = find.text('3');
    final button4 = find.text('4');
    final button5 = find.text('5');
    final button6 = find.text('6');
    final button7 = find.text('7');
    final button8 = find.text('8');
    final button9 = find.text('9');
    final button00 = find.text('00');
    final buttonDelete = find.byIcon(Icons.arrow_back);

    // testing all the buttons
    expect(button0, findsOneWidget);
    expect(button1, findsOneWidget);
    expect(button2, findsOneWidget);
    expect(button3, findsOneWidget);
    expect(button4, findsOneWidget);
    expect(button5, findsOneWidget);
    expect(button6, findsOneWidget);
    expect(button7, findsOneWidget);
    expect(button8, findsOneWidget);
    expect(button9, findsOneWidget);
    expect(button00, findsOneWidget);
    expect(buttonDelete, findsOneWidget);

    // now we press all the buttons from 9 to 0;
    await tester.tap(button9);
    await tester.tap(button8);
    await tester.tap(button7);
    await tester.tap(button6);
    await tester.tap(button5);
    await tester.tap(button4);
    await tester.tap(button3);
    await tester.tap(button2);
    await tester.tap(button1);
    await tester.tap(button0);
    await tester.tap(button00);
    await tester.tap(buttonDelete);
    await tester.pump(Duration(seconds: 1));

    expect(find.text('987654321.00'), findsOneWidget);
    // the suggestions endpoint should also be called once since we have a debounce and the suggestions showing
    expect(suggestions.isDone, true);

    // the save button should be enabled now that we have an amount
    saveButtonWidget = tester.widget(saveButton);
    expect(saveButtonWidget.enabled, true);

    await snap(name: 'with suggestion');

    final suggestionPill = find.byType(NoteSuggestionPill);
    expect(suggestionPill, findsOneWidget);

    final suggestion = find.descendant(of: suggestionPill, matching: find.text('google drive'));
    expect(suggestion, findsOneWidget);

    NoteSuggestionPill pill = tester.firstWidget(suggestionPill);
    expect(pill.current, false);

    await tester.tap(suggestionPill);
    await tester.pumpAndSettle();

    pill = tester.firstWidget(suggestionPill);
    expect(pill.current, true);

    final saveCall = nock(validServerUrl).post('/API/Expense', (body) => true)
      ..reply(
        200,
        // the response does not matter here
        jsonEncode(Expense(amount: 987654321.00, timestamp: 123, category: categories.first)),
      );

    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(saveCall.isDone, true);
  });

  testWidgets('Test opening expense dialog with set amount', (tester) async {
    await tester.pumpWidget(
      TestSetup(
        child: AddExpense(
          canChangeCategory: false,
          expense: Expense(
            amount: 1337,
            timestamp: DateTime(2026, 1, 23, 15, 00).millisecondsSinceEpoch,
            category: categories.first,
          ),
        ),
      ),
    );

    // for this test we don't care about suggestions
    nock(validServerUrl).post('/API/Expense/suggest-notes', (body) => true).reply(200, '{}');

    await tester.pumpAndSettle();
    await tester.pump(Duration(seconds: 1));
    await snap(settings: .new(blockText: false));

    final amount = find.text('1337.00');
    expect(amount, findsOneWidget);
    final categoryIcon = find.text(iconMap['google']!);
    expect(categoryIcon, findsAtLeastNWidgets(1));

    // we make sure that the date is respected
    expect(find.text('2026-01-23'), findsOneWidget);
  });
}
