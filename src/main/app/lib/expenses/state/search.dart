import 'dart:core';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spend_spent_spent/categories/models/category.dart';
import 'package:spend_spent_spent/expenses/models/search_parameters.dart';
import 'package:spend_spent_spent/globals.dart';

part 'search.freezed.dart';

class SearchCubit extends Cubit<SearchState> {
  final Function(SearchParameters params) search;
  final TextEditingController noteController = TextEditingController();

  SearchCubit(super.initialState, this.search) {
    noteController.addListener(setNote);
    getSearchParameters();
  }

  updateRange(RangeValues range) {
    emit(
      state.copyWith.searchParameters(
        minAmount: range.start.floor(),
        maxAmount: range.end.ceil(),
      ),
    );

    triggerSearch();
  }

  triggerSearch() {
    EasyDebounce.debounce(
      'expense-search',
      const Duration(milliseconds: 500),
      () => search(state.searchParameters),
    );
  }

  setNote() {
    emit(state.copyWith.searchParameters(searchQuery: noteController.text));

    triggerSearch();
  }

  selectCategory(Category c) {
    List<Category> categories = List.from(state.searchParameters.categories);
    if (c.id == null) {
      categories = [];
    }

    if (categories.isNotEmpty && categories[0].id == c.id) {
      categories = [];
    } else {
      categories = [c];
    }
    print('selected category ${c.id}');

    emit(state.copyWith.searchParameters(categories: categories));
    triggerSearch();

    getSearchParameters();
  }

  getSearchParameters() {
    int? categoryId;
    if (state.searchParameters.categories.isNotEmpty) {
      categoryId = state.searchParameters.categories[0].id;
    }

    service.getSearchParameters(categoryId).then((value) {
      emit(
        state.copyWith(
          searchParameters: SearchParameters(
            categories: state.searchParameters.categories,
            maxAmount: value.maxAmount,
            minAmount: value.minAmount,
            searchQuery: state.searchParameters.searchQuery,
          ),
          searchParametersBounds: SearchParameters(
            categories: value.categories,
            maxAmount: value.maxAmount,
            minAmount: value.minAmount,
            searchQuery: "",
          ),
        ),
      );
    });
  }
}

@freezed
sealed class SearchState with _$SearchState {
  const factory SearchState({
    @Default(
      SearchParameters(
        categories: [],
        maxAmount: 0,
        minAmount: 0,
        searchQuery: "",
      ),
    )
    SearchParameters searchParametersBounds,
    @Default(
      SearchParameters(
        categories: [],
        maxAmount: 0,
        minAmount: 0,
        searchQuery: "",
      ),
    )
    SearchParameters searchParameters,
  }) = _SearchState;
}
