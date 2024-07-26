import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/icons.dart';
import 'package:spend_spent_spent/models/appColors.dart';
import 'package:spend_spent_spent/models/expense.dart';
import 'package:spend_spent_spent/models/recurringExpense.dart';
import 'package:spend_spent_spent/utils/colorUtils.dart';

import '../utils/dialogs.dart';

class RecurringExpenseView extends StatefulWidget {
  RecurringExpense expense;
  Function refreshExpenses;

  RecurringExpenseView(this.expense, {required this.refreshExpenses});

  @override
  RecurringExpenseViewState createState() => RecurringExpenseViewState();
}

class RecurringExpenseViewState extends State<RecurringExpenseView> with AfterLayoutMixin {
  TextEditingController nameController = TextEditingController(text: '');

  Widget getRepeatedIcon(ColorScheme colors) {
    List<Widget> icons = [];

    for (int i = 0; i < 150; i++) {
      icons.add(getIcon(widget.expense.category.icon!, color: colors.onSurface, size: 40));
    }

    return Opacity(
      opacity: 0.03,
      child: Wrap(
        children: icons,
        spacing: 20,
        runSpacing: 20,
      ),
    );
  }

  setName(BuildContext context) {
    showPromptDialog(context, 'Change expense name', "", nameController, () async {
      print('New expense name: ${nameController.text}');
      widget.expense.name = nameController.text;
      await service.updateRecurringExpense(widget.expense);
      widget.refreshExpenses();
    }, maxLines: 1);
  }

  deleteExpense(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    showPlatformDialog(
      context: context,
      builder: (_) => PlatformAlertDialog(
        title: Text('Delete recurring expense ?'),
        content: Text('This will delete the scheduling of the expense, existing expenses won\'t be deleted.'),
        actions: <Widget>[
          PlatformDialogAction(
            onPressed: () => Navigator.pop(context),
            child: PlatformText(
              'Cancel',
              style: TextStyle(color: colors.secondary),
            ),
          ),
          PlatformDialogAction(
            onPressed: () async {
              await service.deleteRecurringExpense(widget.expense.id!);
              widget.refreshExpenses();
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: PlatformText('Delete', style: TextStyle(color: Colors.red)),
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
        Positioned(
          top: -20,
          left: -30,
          right: -30,
          bottom: -20,
          child: getRepeatedIcon(colors),
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
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: FaIcon(
                        FontAwesomeIcons.pencilAlt,
                        color: colors.onSurface,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => deleteExpense(context),
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: FaIcon(
                        FontAwesomeIcons.trash,
                        color: Colors.red,
                      ),
                    ),
                  ),
                )
              ],
            )),
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
                    decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FaIcon(
                        FontAwesomeIcons.times,
                        color: colors.onSurface,
                        size: 15,
                      ),
                    ),
                  ),
                )
              ],
            )),
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
                child: getIcon(widget.expense.category.icon!, color: colors.onPrimaryContainer, size: 50),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: colors.primaryContainer),
                width: 100,
                alignment: Alignment.center,
                height: 100,
              ),
              Visibility(
                visible: widget.expense.name.trim().length > 0,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: defaultBorder,
                      color: Colors.transparent,
                    ),
                    child: Text(
                      widget.expense.name,
                      style: TextStyle(fontSize: 50, color: colors.primary, fontWeight: FontWeight.w300),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: defaultBorder,
                    color: Colors.transparent,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
                    child: Text(
                      formatCurrency(widget.expense.amount),
                      style: TextStyle(fontSize: 50, color: colors.onSurface, fontWeight: FontWeight.w300),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 0.0),
                child: Container(
                  width: 300,
                  decoration: BoxDecoration(borderRadius: defaultBorder, color: colors.tertiaryContainer),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
                    child: Column(
                      children: [
                        Visibility(
                            visible: widget.expense.lastOccurrence != null,
                            child: Text('Last: ' + (widget.expense.lastOccurrence ?? ''),
                                textAlign: TextAlign.center, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300, color: colors.onTertiaryContainer))),
                        Visibility(
                            visible: widget.expense.nextOccurrence != null,
                            child: Text('Next: ' + (widget.expense.nextOccurrence ?? ''),
                                textAlign: TextAlign.center, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300, color: colors.onTertiaryContainer))),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    nameController.text = widget.expense.name;
  }
}
