import 'package:app/components/recurringExpenses/addExpense.dart';
import 'package:app/components/recurringExpenses/expense.dart';
import 'package:app/models/recurringExpense.dart';
import 'package:flutter/cupertino.dart';

class ExpenseList extends StatelessWidget {
  List<RecurringExpense> expenses;
  Function refreshExpenses;

  ExpenseList({required this.expenses, required this.refreshExpenses});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length + 1,
      itemBuilder: (context, index) {
        if (index < expenses.length) {
          return Expense(
            expense: expenses[index],
            refreshExpenses: refreshExpenses,
          );
        } else {
          return AddExpense(
            refreshExpenses: refreshExpenses,
          );
        }
      },
    );
  }
}
