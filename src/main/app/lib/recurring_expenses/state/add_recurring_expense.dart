import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spend_spent_spent/categories/models/category.dart';
import 'package:spend_spent_spent/recurring_expenses/models/recurring_expense.dart';

import '../../globals.dart';

part 'add_recurring_expense.freezed.dart';

class AddRecurringExpenseCubit extends Cubit<AddRecurringExpenseState> {
  final TextEditingController nameController = TextEditingController(text: '');

  AddRecurringExpenseCubit(super.initialState) {
    getCategories();

    nameController.addListener(() {
      setName(nameController.value.text);
    });
  }

  Future<void> addRecurringExpense() async {
    double doubleAmount = double.parse(state.amount) / 100;
    int? typeParam = state.typeParam;
    if (state.type != null && state.type == 0) {
      typeParam = 0;
    }

    if (state.category != null &&
        state.type != null &&
        typeParam != null &&
        doubleAmount > 0) {
      RecurringExpense expense = RecurringExpense(
        category: state.category!,
        amount: doubleAmount,
        income: false,
        name: state.name,
        typeParam: typeParam,
        type: state.type!,
      );
      await service.addRecurringExpense(expense);
    } else {
      print('Missing parameters');
    }
  }

  getCategories() async {
    final categories = await service.getCategories();
    emit(state.copyWith(categories: categories));
  }

  setCategory(Category category) {
    emit(state.copyWith(category: category));
    /*
    setState(() {
      this.category = category;
      setStepWidget(step);
    });
*/
  }

  setName(String name) {
    emit(state.copyWith(name: name));
  }

  setType(int type) {
    emit(state.copyWith(type: type, typeParam: null));
    /*
    setState(() {
      this.type = type;
      this.typeParam = null;
      setStepWidget(step);
    });
*/
  }

  setTypeParam(int typeParam) {
    emit(state.copyWith(typeParam: typeParam));
    /*
    setState(() {
      this.typeParam = typeParam;
      setStepWidget(step);
    });
*/
  }

  setAmount(String amount) {
    emit(state.copyWith(amount: amount));
    /*
    setState(() {
      this.amount = amount;
      setStepWidget(step);
    });
*/
  }

  void setStep(int i) {
    emit(state.copyWith(step: i));
  }
}

@freezed
sealed class AddRecurringExpenseState with _$AddRecurringExpenseState {
  const factory AddRecurringExpenseState({
    @Default(0) int step,
    Category? category,
    int? type,
    int? typeParam,
    @Default('') String amount,
    @Default('') String name,
    @Default([]) List<Category> categories,
  }) = _AddRecurringExpenseState;

  const AddRecurringExpenseState._();

  bool get stepValid => switch (step) {
        0 => category != null,
        1 => (type != null && typeParam != null) || (type == 0),
        2 => amount.isNotEmpty,
        _ => false,
      };
}
