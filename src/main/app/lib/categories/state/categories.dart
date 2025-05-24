// This file is "main.dart"
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spend_spent_spent/categories/models/category.dart';
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
  }

  void addCategory(String selected) async {
    await service.addCategory(selected);
    getCategories();
  }

  void reset() {
    emit(state.copyWith(categories: []));
  }
}

@freezed
sealed class CategoriesState with _$CategoriesState {
  const factory CategoriesState(
      {@Default(true) bool loading,
      @Default([]) List<Category> categories}) = _CategoriesState;
}
