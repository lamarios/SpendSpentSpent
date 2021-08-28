import 'package:animations/animations.dart';
import 'package:app/utils/dialogs.dart';
import 'package:app/views/addRecurringExpense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddExpense extends StatelessWidget {
  Function refreshExpenses;

  AddExpense({required this.refreshExpenses});

  showAddRecurringExpenseDialog(BuildContext context) {
    showModal(context: context, builder: (context) => Card(margin: getInsetsForMaxSize(MediaQuery.of(context), 600), child: AddRecurringExpenseDialog(refreshRecurringExpenses: refreshExpenses,)));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => showAddRecurringExpenseDialog(context),
        child: Container(
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(25)), border: Border.all(width: 3, color: Colors.blue[100]!)),
          child: FaIcon(
            FontAwesomeIcons.plus,
            color: Colors.blue[100],
          ),
        ),
      ),
    );
  }
}
