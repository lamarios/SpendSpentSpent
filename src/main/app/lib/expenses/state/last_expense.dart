import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_spent_spent/models/expense.dart';

class LastExpenseCubit extends Cubit<Expense?> {
  LastExpenseCubit(super.initialState);

  setLastExpense(Expense? expense) {
    emit(expense);
  }
}
