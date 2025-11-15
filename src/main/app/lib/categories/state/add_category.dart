// This file is "main.dart"
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spend_spent_spent/categories/models/available_categories.dart';
import 'package:spend_spent_spent/categories/state/categories.dart';
import 'package:spend_spent_spent/globals.dart';

part 'add_category.freezed.dart';

class AddCategoryCubit extends Cubit<AddCategoryState> {
  final CategoriesCubit categoriesCubit;
  final searchController = TextEditingController();

  AddCategoryCubit(super.initialState, this.categoriesCubit) {
    getAvailableCategories();
    searchController.addListener(search);
  }

  void search() {
    EasyDebounce.debounce('new-category-search', const Duration(milliseconds: 300), () {
      service.searchAvailableCategories(searchController.text).then((value) {
        emit(state.copyWith(selected: '', categories: value));
      });
    });
  }

  getAvailableCategories() async {
    AvailableCategories categories = await service.getAvailableCategories();
    emit(state.copyWith(categories: categories));
  }

  void setSelected(String s) {
    emit(state.copyWith(selected: s));
  }

  saveNewCategory() {}
}

@freezed
sealed class AddCategoryState with _$AddCategoryState {
  const factory AddCategoryState({
    @Default('') String selected,
    @Default(AvailableCategories()) AvailableCategories categories,
  }) = _AddCategoryState;
}
