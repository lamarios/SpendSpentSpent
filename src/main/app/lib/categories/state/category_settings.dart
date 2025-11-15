// This file is "main.dart"
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spend_spent_spent/categories/models/category.dart';
import 'package:spend_spent_spent/categories/state/categories.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/utils/models/with_error.dart';

part 'category_settings.freezed.dart';

class CategorySettingsCubit extends Cubit<CategorySettingsState> {
  final CategoriesCubit categoriesCubit;

  CategorySettingsCubit(super.initialState, this.categoriesCubit) {
    emit(state.copyWith(categories: categoriesCubit.state.categories));
  }

  onItemReorder(int oldItemIndex, int newItemIndex) {
    List<Category> categories = List.from(state.categories);

    if (oldItemIndex < newItemIndex) {
      newItemIndex -= 1;
    }

    var movedItem = categories.removeAt(oldItemIndex);
    categories.insert(newItemIndex, movedItem);
    for (int i = 0; i < categories.length; i++) {
      categories[i] = categories[i].copyWith(categoryOrder: i);
    }
    emit(state.copyWith(categories: categories));
  }

  updateCategoryIcon(Category category, String newIcon) {
    List<Category> categories = List.from(state.categories);
    for (int i = 0; i < categories.length; i++) {
      final element = categories[i];
      if (element.id == category.id) {
        categories[i] = categories[i].copyWith(icon: newIcon);
      }
    }
    emit(state.copyWith(categories: categories));
  }

  addToDelete(Category category) async {
    int expenses = await service.countCategoryExpenses(category.id!);
    List<Category> toDelete = List.from(state.toDelete);
    List<Category> categories = List.from(state.categories);

    toDelete.add(category);
    int index = categories.indexWhere((element) => element.id == category.id);
    categories.removeAt(index);

    emit(
      state.copyWith(toDelete: toDelete, categories: categories, expensesToDelete: state.expensesToDelete + expenses),
    );

    emit(state.copyWith(categories: categories));
  }

  saveCategories() async {
    try {
      await service.saveAllCategories(state.categories);

      for (final category in state.toDelete) {
        await service.deleteCategory(category.id!);
      }

      categoriesCubit.getCategories(true);
    } catch (e, s) {
      emit(state.copyWith(error: e, stackTrace: s));
    }
  }
}

@freezed
sealed class CategorySettingsState with _$CategorySettingsState implements WithError {
  @Implements<WithError>()
  const factory CategorySettingsState({
    @Default([]) List<Category> categories,
    @Default([]) List<Category> toDelete,
    @Default(0) int expensesToDelete,
    dynamic error,
    StackTrace? stackTrace,
  }) = _CategorySettingsState;
}
