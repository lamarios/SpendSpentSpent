// This file is "main.dart"
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spend_spent_spent/categories/models/category.dart';
import 'package:spend_spent_spent/expenses/models/category_prediction.dart';
import 'package:spend_spent_spent/globals.dart';

part 'categories.freezed.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit(super.initialState) {
    getCategories();
  }

  getCategories() async {
    emit(state.copyWith(loading: true));
    final categories = await service.getCategories();
    emit(state.copyWith(categories: categories, loading: false));
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    if (currentTimeZone != 'Etc/Unknown') {
      final predictions = await service.suggestExpenseCategory(currentTimeZone);
      emit(state.copyWith(suggestions: predictions));
    }
  }

  double getProbability(Category category) {
    return state.suggestions
            .where((p) => p.category.id == category.id)
            .map((c) => c.probability)
            .firstOrNull ??
        0;
  }

  void addCategory(String selected) async {
    await service.addCategory(selected);
    getCategories();
  }

  void reset() {
    emit(state.copyWith(categories: []));
  }

  Category? findByName(String name) {
    return state.categories
        .where((element) => element.icon == name)
        .firstOrNull;
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
