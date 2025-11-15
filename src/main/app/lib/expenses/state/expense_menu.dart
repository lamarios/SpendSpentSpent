import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spend_spent_spent/expenses/models/expense.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/identity/states/username_password.dart';

part 'expense_menu.freezed.dart';

class ExpenseMenuCubit extends Cubit<ExpenseMenuState> {
  ExpenseMenuCubit(super.initialState) {
    init();
  }

  Future<void> init() async {
    final exp = await service.getExpense(state.expense.id!);

    if (!isClosed) {
      emit(state.copyWith(expense: exp, loading: false));
    }
  }

  void setExpense(Expense expense) {
    emit(state.copyWith(expense: expense));
  }
}

@freezed
sealed class ExpenseMenuState with _$ExpenseMenuState {
  const factory ExpenseMenuState({required Expense expense, @Default(true) bool loading}) = _ExpenseMenuState;

  const ExpenseMenuState._();

  bool get isOwnExpense => getIt<UsernamePasswordCubit>().currentUser?.id == expense.category.user?.id;
}
