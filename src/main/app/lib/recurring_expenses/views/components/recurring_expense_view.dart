import 'package:flutter/material.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/icons.dart';
import 'package:spend_spent_spent/recurring_expenses/models/recurring_expense.dart';
import 'package:spend_spent_spent/utils/dialogs.dart';
import 'package:spend_spent_spent/utils/views/components/repeated_icons.dart';

class RecurringExpenseView extends StatefulWidget {
  final RecurringExpense expense;
  final Function() refreshExpenses;

  const RecurringExpenseView(
    this.expense, {
    super.key,
    required this.refreshExpenses,
  });

  @override
  RecurringExpenseViewState createState() => RecurringExpenseViewState();
}

class RecurringExpenseViewState extends State<RecurringExpenseView> {
  late final TextEditingController nameController = TextEditingController(
    text: widget.expense.name,
  );

  @override
  dispose() {
    nameController.dispose();
    super.dispose();
  }

  Widget getRepeatedIcon(ColorScheme colors) {
    List<Widget> icons = [];

    for (int i = 0; i < 150; i++) {
      icons.add(
        getIcon(
          widget.expense.category.icon!,
          color: colors.onSurface,
          size: 40,
        ),
      );
    }

    return Opacity(
      opacity: 0.03,
      child: Wrap(spacing: 20, runSpacing: 20, children: icons),
    );
  }

  setName(BuildContext context) {
    showPromptDialog(
      context,
      'Change expense name',
      "",
      nameController,
      () async {
        await service.updateRecurringExpense(
          widget.expense.copyWith(name: nameController.text),
        );
        widget.refreshExpenses();
      },
      maxLines: 1,
    );
  }

  deleteExpense(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete recurring expense ?'),
        content: const Text(
          'This will delete the scheduling of the expense, existing expenses won\'t be deleted.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: colors.secondary)),
          ),
          TextButton(
            onPressed: () async {
              await service.deleteRecurringExpense(widget.expense.id!);
              widget.refreshExpenses();
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Stack(
      children: [
        RepeatedIconsBackground(
          icon: widget.expense.category.icon!,
          color: colors.onSurface.withValues(alpha: 0.05),
          size: 40,
          child: const SizedBox.shrink(),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => setName(context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Icon(Icons.edit, color: colors.onSurface),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => deleteExpense(context),
                child: const Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Icon(Icons.delete, color: Colors.red),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 20,
          right: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.clear, color: colors.onSurface, size: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          bottom: 70,
          left: 0,
          right: 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: colors.primaryContainer,
                ),
                width: 100,
                alignment: Alignment.center,
                height: 100,
                child: getIcon(
                  widget.expense.category.icon!,
                  color: colors.onPrimaryContainer,
                  size: 50,
                ),
              ),
              Visibility(
                visible: widget.expense.name.trim().isNotEmpty,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: defaultBorder,
                      color: Colors.transparent,
                    ),
                    child: Text(
                      widget.expense.name,
                      style: TextStyle(
                        fontSize: 50,
                        color: colors.primary,
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: defaultBorder,
                    color: Colors.transparent,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30.0,
                      vertical: 10,
                    ),
                    child: Text(
                      formatCurrency(widget.expense.amount),
                      style: TextStyle(
                        fontSize: 50,
                        color: colors.onSurface,
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 0.0),
                child: Container(
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: defaultBorder,
                    color: colors.tertiaryContainer,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30.0,
                      vertical: 10,
                    ),
                    child: Column(
                      children: [
                        Visibility(
                          visible: widget.expense.lastOccurrence != null,
                          child: Text(
                            'Last: ${widget.expense.lastOccurrence ?? ''}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                              color: colors.onTertiaryContainer,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: widget.expense.nextOccurrence != null,
                          child: Text(
                            'Next: ${widget.expense.nextOccurrence ?? ''}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                              color: colors.onTertiaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
