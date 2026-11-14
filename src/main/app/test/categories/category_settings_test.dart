import 'dart:convert';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nock/nock.dart';
import 'package:spend_spent_spent/categories/models/category.dart';
import 'package:spend_spent_spent/categories/state/category_settings.dart';
import 'package:spend_spent_spent/categories/views/screens/category_settings.dart';

import '../helper_widget/test_app_setup_widget.dart';
import '../utils/test_utils.dart';

void main() {
  final categories = [
    Category(categoryOrder: 0, icon: 'house', id: 1, user: testUser),
    Category(categoryOrder: 1, icon: 'food', id: 2, user: testUser),
    Category(categoryOrder: 2, icon: 'gas', id: 3, user: testUser),
  ];

  setUpAll(() {
    nock.init();
  });

  setUp(() async {
    await setupTests(loggedIn: true, categories: categories);
    nock(validServerUrl).get('/config')
      ..reply(200, loadFixture('valid_server_config.json'))
      ..persist(true);
    nock(validServerUrl).get('/API/Category/expenses/count')
      ..reply(200, '{}')
      ..persist(true);
    nock(validServerUrl).get('/API/Category/1/expenses/count').reply(200, '0');
    nock(validServerUrl).get('/API/Category/2/expenses/count').reply(200, '0');
    nock(validServerUrl).put('/API/Category', (body) => true).reply(200, jsonEncode(categories));
  });

  tearDown(() {
    nock.cleanAll();
  });

  Future<void> saveWithDeletions(WidgetTester tester, List<Category> toDelete) async {
    await tester.pumpWidget(
      TestSetup(
        child: Builder(
          builder: (context) => TextButton(
            onPressed: () =>
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CategorySettingsScreen())),
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    final cubit = tester.element(find.text('Save')).read<CategorySettingsCubit>();
    for (final category in toDelete) {
      await cubit.addToDelete(category);
    }
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.byType(CategorySettingsScreen), findsNothing);
  }

  testWidgets('A refused delete is shown', (tester) async {
    nock(validServerUrl).delete('/API/Category/1').reply(200, 'false');

    await saveWithDeletions(tester, [categories[0]]);

    expect(
      find.text('1 category was not deleted, only its creator or a household admin can delete it.'),
      findsOneWidget,
    );
  });

  testWidgets('Only the refused deletes are counted', (tester) async {
    nock(validServerUrl).delete('/API/Category/1').reply(200, 'true');
    nock(validServerUrl).delete('/API/Category/2').reply(200, 'false');

    await saveWithDeletions(tester, [categories[0], categories[1]]);

    expect(
      find.text('1 category was not deleted, only its creator or a household admin can delete it.'),
      findsOneWidget,
    );
  });

  testWidgets('Several refused deletes are shown', (tester) async {
    nock(validServerUrl).delete('/API/Category/1').reply(200, 'false');
    nock(validServerUrl).delete('/API/Category/2').reply(200, 'false');

    await saveWithDeletions(tester, [categories[0], categories[1]]);

    expect(
      find.text('2 categories were not deleted, only their creator or a household admin can delete them.'),
      findsOneWidget,
    );
  });

  testWidgets('A delete going through shows nothing', (tester) async {
    nock(validServerUrl).delete('/API/Category/1').reply(200, 'true');

    await saveWithDeletions(tester, [categories[0]]);

    expect(find.byType(SnackBar), findsNothing);
  });
}
