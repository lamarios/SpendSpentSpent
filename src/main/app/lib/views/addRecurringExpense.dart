import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:spend_spent_spent/components/addRecurringExpenseDialog/step1.dart';
import 'package:spend_spent_spent/components/addRecurringExpenseDialog/step2.dart';
import 'package:spend_spent_spent/components/addRecurringExpenseDialog/step3.dart';
import 'package:spend_spent_spent/utils/views/components/switcher.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/models/appColors.dart';
import 'package:spend_spent_spent/categories/models/category.dart';
import 'package:spend_spent_spent/models/recurringExpense.dart';

class AddRecurringExpenseDialog extends StatefulWidget {
  Function refreshRecurringExpenses;

  AddRecurringExpenseDialog({required this.refreshRecurringExpenses});

  @override
  AddRecurringExpenseDialogState createState() => AddRecurringExpenseDialogState();
}

class AddRecurringExpenseDialogState extends State<AddRecurringExpenseDialog> with AfterLayoutMixin {
  int step = 0;
  Widget? stepWidget;
  Category? category;
  int? type;
  int? typeParam;
  String amount = '', name = '';

  Future<void> forward(BuildContext context) async {
    if (step == 2) {
      // add expense
      await addRecurringExpense();
      Navigator.of(context).pop();
      widget.refreshRecurringExpenses();
    } else {
      setState(() {
        step++;
        setStepWidget(step);
      });
    }
  }

  Future<void> addRecurringExpense() async {
    double doubleAmount = double.parse(amount) / 100;

    if (type != null && type == 0) {
      typeParam = 0;
    }
    if (category != null && type != null && typeParam != null && doubleAmount > 0) {
      RecurringExpense expense = RecurringExpense(category: category!, amount: doubleAmount, income: false, name: name, typeParam: typeParam!, type: type!);
      await service.addRecurringExpense(expense);
    } else {
      print('Missing parameters');
    }
  }

  setCategory(Category category) {
    setState(() {
      this.category = category;
      setStepWidget(step);
    });
  }

  setName(String name) {
    setState(() {
      this.name = name;
    });
  }

  setType(int type) {
    setState(() {
      this.type = type;
      this.typeParam = null;
      setStepWidget(step);
    });
  }

  setTypeParam(int typeParam) {
    setState(() {
      this.typeParam = typeParam;
      setStepWidget(step);
    });
  }

  setAmount(String amount) {
    setState(() {
      this.amount = amount;
      setStepWidget(step);
    });
  }

  setStepWidget(step) {
    switch (step) {
      case 0:
        this.stepWidget = Step1(
          selected: category,
          setCategory: setCategory,
          setName: setName,
          name: name,
        );
        break;
      case 1:
        this.stepWidget = Step2(
          type: type,
          typeParam: typeParam,
          setType: setType,
          setTypeParam: setTypeParam,
        );
        break;
      case 2:
        this.stepWidget = Step3(amount: amount, setAmount: setAmount);
        break;
    }
  }

  bool stepValid() {
    switch (step) {
      case 0:
        return category != null;
      case 1:
        return (type != null && typeParam != null) || (type == 0);
      case 2:
        return amount.length > 0;
      default:
        return false;
    }
  }

  void backward(BuildContext context) {
    if (step == 0) {
      Navigator.of(context).pop();
    } else {
      setState(() {
        step--;
        setStepWidget(step);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      child: Visibility(
        visible: stepWidget != null,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Switcher(labels: ['What ?', 'How often ?', 'How much ?'], selected: step, onSelect: (step) {}),
              Expanded(
                  child: SingleChildScrollView(
                child: AnimatedSwitcher(
                  duration: panelTransition,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: stepWidget,
                  ),
                ),
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PlatformDialogAction(
                    onPressed: () => backward(context),
                    child: PlatformText(
                      step == 0 ? 'Cancel' : 'Back',
                      style: TextStyle(color: colors.secondary),
                    ),
                  ),
                  PlatformDialogAction(
                    onPressed: stepValid() ? () => forward(context) : null,
                    child: PlatformText(step == 2 ? 'Add' : 'Next'),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    setState(() {
      setStepWidget(0);
    });
  }
}
