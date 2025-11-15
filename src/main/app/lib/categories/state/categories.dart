// This file is "main.dart"
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logging/logging.dart';
import 'package:spend_spent_spent/categories/models/category.dart';
import 'package:spend_spent_spent/expenses/models/category_prediction.dart';
import 'package:spend_spent_spent/globals.dart';

part 'categories.freezed.dart';

final _log = Logger('CategoriesCubit');

class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit(super.initialState) {
    getCategories(true);
  }

  Future<void> getCategories(bool loading) async {
    try {
      emit(state.copyWith(loading: loading));
      final categories = await service.getCategories();
      final String currentTimeZone = (await FlutterTimezone.getLocalTimezone()).identifier;
      List<CategoryPrediction> predictions = [];
      if (currentTimeZone != 'Etc/Unknown') {
        predictions = await service.suggestExpenseCategory(currentTimeZone);

        predictions.sort((a, b) => b.probability.compareTo(a.probability));
      }
      emit(state.copyWith(suggestions: predictions, categories: categories, loading: false));
    } catch (e) {
      _log.severe('Could not load categories');
      emit(state.copyWith(loading: false));
    }
  }

  double getProbability(Category category) {
    return state.suggestions.where((p) => p.category.id == category.id).map((c) => c.probability).firstOrNull ?? 0;
  }

  void addCategory(String selected) async {
    await service.addCategory(selected);
    getCategories(false);
  }

  void reset() {
    emit(state.copyWith(categories: []));
  }

  Category? findByName(String name) {
    return state.categories.where((element) => element.icon == name).firstOrNull;
  }
}

@freezed
sealed class CategoriesState with _$CategoriesState {
  const factory CategoriesState({
    @Default(true) bool loading,
    @Default([]) List<Category> categories,
    @Default([]) List<CategoryPrediction> suggestions,
  }) = _CategoriesState;
}
