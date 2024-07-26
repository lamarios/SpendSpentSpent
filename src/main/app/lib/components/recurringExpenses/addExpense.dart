import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spend_spent_spent/utils/dialogs.dart';
import 'package:spend_spent_spent/views/addRecurringExpense.dart';

class AddExpense extends StatelessWidget {
  final Function refreshExpenses;

  const AddExpense({super.key, required this.refreshExpenses});

  showAddRecurringExpenseDialog(BuildContext context) {
    showModal(
        context: context,
        builder: (context) => Card(
            margin: getInsetsForMaxSize(MediaQuery.of(context),
                maxWidth: 350, maxHeight: 450),
            child: AddRecurringExpenseDialog(
              refreshRecurringExpenses: refreshExpenses,
            )));
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 8.0),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => showAddRecurringExpenseDialog(context),
        child: Container(
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(25)),
              border:
                  Border.all(width: 3, color: colors.primary.withOpacity(0.5))),
          child: FaIcon(
            FontAwesomeIcons.plus,
            color: colors.primary.withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}
