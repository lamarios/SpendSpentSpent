import 'dart:core';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spend_spent_spent/categories/models/category.dart';
import 'package:spend_spent_spent/expenses/models/search_parameters.dart';
import 'package:spend_spent_spent/globals.dart';

part 'search.freezed.dart';

class SearchCubit extends Cubit<SearchState> {
  final int onDayMinusOneMs = 1000 * 60 * 60 * 24 - 1;
  final Function(SearchParameters params) search;
  final TextEditingController noteController = TextEditingController();

  SearchCubit(super.initialState, this.search) {
    noteController.addListener(setNote);
    getSearchParameters();
  }

  void updateRange(RangeValues range) {
    emit(
      state.copyWith.searchParameters(
        minAmount: range.start.floor(),
        maxAmount: range.end.ceil(),
      ),
    );

    triggerSearch();
  }

  void triggerSearch() {
    search(state.searchParameters);
  }

  void setNote() {
    emit(state.copyWith.searchParameters(searchQuery: noteController.text));

    triggerSearch();
  }

  void setDates(DateTimeRange<DateTime>? range) {
    if (range != null) {
      emit(
        state.copyWith(
          searchParameters: state.searchParameters.copyWith(
            minDate: range.start.millisecondsSinceEpoch,
            maxDate: range.end.millisecondsSinceEpoch + onDayMinusOneMs,
          ),
        ),
      );
      triggerSearch();
    }
  }

  void selectCategory(Category c) {
    List<Category> categories = List.from(state.searchParameters.categories);
    if (c.id == null) {
      categories = [];
    }

    if (categories.isNotEmpty && categories[0].id == c.id) {
      categories = [];
    } else {
      categories = [c];
    }
    emit(state.copyWith.searchParameters(categories: categories));

    getSearchParameters();
  }

  void getSearchParameters() {
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
            minDate:
                state.searchParameters.minDate ??
                DateTime.now().add(Duration(days: -7)).millisecondsSinceEpoch,
            maxDate: state.searchParameters.maxDate ?? value.maxDate,
          ),
          searchParametersBounds: SearchParameters(
            categories: value.categories,
            maxAmount: value.maxAmount,
            minAmount: value.minAmount,
            minDate: value.minDate,
            maxDate: value.maxDate,
            searchQuery: "",
          ),
        ),
      );

      triggerSearch();
    });
  }

  Future<Uint8List> downloadData() async {
    return await service.downloadSearchCsv(state.searchParameters);
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
