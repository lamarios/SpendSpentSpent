import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:nock/nock.dart';
import 'package:spend_spent_spent/categories/models/category.dart';
import 'package:spend_spent_spent/categories/state/categories.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/service.dart';

import '../utils/test_utils.dart';

void main() {
  final shared = Category(categoryOrder: 0, icon: 'house', id: 1, user: testUser);
  final own = Category(categoryOrder: 1, icon: 'gas', id: 2, user: testUser);

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    nock.init();
  });

  setUp(() async {
    await setupTests(loggedIn: true);
  });

  tearDown(() {
    nock.cleanAll();
  });

  test('An older answer does not bring back the categories of a household left', () async {
    final answers = <Completer<List<Category>>>[];
    final previousService = service;
    service = _AnsweredLaterService(answers)
      ..url = previousService.url
      ..version = previousService.version;
    addTearDown(() => service = previousService);

    final cubit = CategoriesCubit(const CategoriesState());
    // a refresh is running when the household is left, the refresh after it is answered first
    final older = cubit.getCategories(false);
    final newer = cubit.getCategories(false);
    expect(answers.length, 3);

    answers[2].complete([own]);
    await newer;
    answers[1].complete([shared, own]);
    await older;
    answers[0].complete([shared, own]);
    await pumpEventQueue();

    expect(cubit.state.categories, [own]);
    expect(cubit.state.loading, false);
    await cubit.close();
  });
}

/// Answers the requests for the categories when the test completes them.
class _AnsweredLaterService extends Service {
  final List<Completer<List<Category>>> answers;

  _AnsweredLaterService(this.answers);

  @override
  Future<List<Category>> getCategories() {
    final answer = Completer<List<Category>>();
    answers.add(answer);
    return answer.future;
  }
}
