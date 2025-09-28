import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:spend_spent_spent/expenses/models/expense.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/households/states/household.dart';
import 'package:spend_spent_spent/icons.dart';
import 'package:spend_spent_spent/router.dart';
import 'package:spend_spent_spent/utils/views/components/conditional_wrapper.dart';
import 'package:spend_spent_spent/utils/views/components/expense_image.dart';

const double MAP_HEIGHT = 200;
const double NOTE_HEIGHT = 30;
final _formatter = DateFormat.yMMMMd('en_US');

class OneExpense extends StatelessWidget {
  final Expense expense;
  final Function(Expense expense)? showExpense;
  final bool showIcons;
  final bool showDate;

  const OneExpense({
    super.key,
    this.showExpense,
    required this.expense,
    this.showIcons = true,
    this.showDate = false,
  });

  void openContainer() {
    if (showExpense != null) {
      showExpense!(expense);
    }
  }

  bool hasNote() {
    return (expense.note?.length ?? 0) > 0;
  }

  bool hasLocation() {
    return expense.longitude != 0 && expense.latitude != 0;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final expenseColors = context.read<HouseholdCubit>().state.getCategoryColor(
      context,
      expense.category,
    );

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: openContainer,
      child: Row(
        spacing: 16,
        children: [
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: expenseColors.primaryContainer,
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: getIcon(
                expense.category.icon!,
                size: 20,
                color: expenseColors.onPrimaryContainer,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 2,
              children: [
                Visibility(
                  visible: hasNote(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      expense.note ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                if (showDate)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      _formatter.format(
                        DateTime.fromMillisecondsSinceEpoch(expense.timestamp),
                      ),
                      style: textTheme.bodySmall?.copyWith(
                        color: colors.secondary,
                      ),
                    ),
                  ),
                if (showIcons)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Visibility(
                        visible: hasLocation(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(
                            Icons.near_me,
                            color: colors.onSurface.withValues(alpha: 0.5),
                            size: 15,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: expense.type == 2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(
                            Icons.refresh,
                            color: colors.onSurface.withValues(alpha: 0.5),
                            size: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          ConditionalWrapper(
            wrapIf: expense.files.isNotEmpty,
            wrapper: (child) => SizedBox(
              width: 170,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (expense.files.isNotEmpty)
                    ConditionalWrapper(
                      wrapIf: showExpense == null,
                      wrapper: (child) => InkWell(
                        onTap: () {
                          AutoRouter.of(context).push(
                            ImageViewerRoute(
                              images: expense.files,
                              initiallySelected: 0,
                            ),
                          );
                        },
                        child: child,
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ExpenseImage(
                            file: expense.files.first,
                            width: 50,
                            height: 50,
                            showStatus: false,
                          ),
                          if (expense.files.length > 1)
                            Positioned(
                              top: -10,
                              right: -10,
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: colors.primaryContainer,
                                ),
                                child: Center(
                                  child: Text(
                                    expense.files.length.toString(),
                                    style: textTheme.labelSmall?.copyWith(
                                      color: colors.onPrimaryContainer,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  Expanded(child: child),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                textAlign: TextAlign.right,
                formatCurrency(expense.amount),
                style: TextStyle(color: colors.onSurface),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
