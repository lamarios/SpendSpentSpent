import 'package:flutter/material.dart';
import 'package:spend_spent_spent/expenses/models/expense_cluster.dart';
import 'package:spend_spent_spent/expenses/views/components/expense.dart';
import 'package:spend_spent_spent/expenses/views/components/stylized_amount.dart';
import 'package:spend_spent_spent/utils/dialogs.dart';

class MapExpenseList extends StatelessWidget {
  final ExpenseCluster cluster;

  const MapExpenseList({super.key, required this.cluster});

  static Future<void> show(BuildContext context, {required ExpenseCluster cluster}) async {
    showMotorBottomSheet(
      context: context,

      child: Wrap(children: [MapExpenseList(cluster: cluster)]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 16,
        children: [
          StylizedAmount(amount: cluster.total, size: 30),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 600),
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: cluster.expenses.length,
              itemBuilder: (context, index) =>
                  OneExpense(expense: cluster.expenses[index], showDate: true, showIcons: false),
            ),
          ),
        ],
      ),
    );
  }
}
