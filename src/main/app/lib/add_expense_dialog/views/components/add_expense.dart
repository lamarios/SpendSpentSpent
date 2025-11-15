import 'dart:math';

import 'package:animations/animations.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:material_loading_indicator/loading_indicator.dart';
import 'package:motor/motor.dart';
import 'package:spend_spent_spent/add_expense_dialog/state/add_expense_dialog.dart';
import 'package:spend_spent_spent/add_expense_dialog/views/components/actions.dart';
import 'package:spend_spent_spent/add_expense_dialog/views/components/currency_converter.dart';
import 'package:spend_spent_spent/add_expense_dialog/views/components/keypad.dart';
import 'package:spend_spent_spent/add_expense_dialog/views/components/note_suggestion_pill.dart';
import 'package:spend_spent_spent/categories/models/category.dart';
import 'package:spend_spent_spent/categories/state/categories.dart';
import 'package:spend_spent_spent/expenses/models/expense.dart';
import 'package:spend_spent_spent/expenses/state/last_expense.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/icons.dart';
import 'package:spend_spent_spent/sss_files/views/components/sss_file_listener.dart';
import 'package:spend_spent_spent/utils/dialogs.dart';
import 'package:spend_spent_spent/utils/views/components/repeated_icons.dart';

const LOCATION_TIMEOUT = 10;

class AddExpense extends StatelessWidget {
  final Category? category;
  final Expense? expense;
  final bool canChangeCategory;

  const AddExpense({super.key, this.category, this.expense, required this.canChangeCategory});

  static Future<Expense?> showDialog(
    BuildContext context, {
    Category? category,
    Expense? expense,
    bool canChangeCategory = false,
  }) async {
    if (foundation.kIsWeb) {
      return showModal<Expense>(
        context: context,
        builder: (context) => Card(
          color: Colors.white.withValues(alpha: 0),
          margin: EdgeInsets.zero,
          child: AddExpense(category: category, expense: expense, canChangeCategory: canChangeCategory),
        ),
      );
    } else {
      return showMotorBottomSheet<Expense>(
        context: context,
        // isScrollControlled: true,
        child: Wrap(
          children: [AddExpense(category: category, expense: expense, canChangeCategory: canChangeCategory)],
        ),
      );
    }
  }

  double getIconHeight(BuildContext context) {
    return min(MediaQuery.sizeOf(context).height / 6, 150);
  }

  Widget getIconHeader(BuildContext context, {required Category cat}) {
    double iconHeight = getIconHeight(context);

    final colors = Theme.of(context).colorScheme;

    return getIcon(cat.icon ?? '', size: iconHeight * 0.66, color: colors.onPrimaryContainer);
  }

  double getHeaderHeight(BuildContext context) {
    return min(MediaQuery.sizeOf(context).height / 6, 150.toDouble());
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return BlocProvider(
      create: (context) => AddExpenseDialogCubit(
        AddExpenseDialogState(
          expenseDate: DateTime.now(),
          category: category ?? expense?.category ?? context.read<CategoriesCubit>().state.categories.first,
        ),
        expense: expense,
        lastExpenseCubit: context.read<LastExpenseCubit>(),
      ),
      child: BlocBuilder<AddExpenseDialogCubit, AddExpenseDialogState>(
        builder: (context, state) {
          final cubit = context.read<AddExpenseDialogCubit>();

          var isWeb = foundation.kIsWeb;
          return SssFileListener(
            onFile: (file) => cubit.updateFile(file),
            child: Container(
              alignment: Alignment.center,
              color: colors.surface.withValues(alpha: 0),
              padding: const EdgeInsets.all(0),
              child: Container(
                constraints: isWeb ? const BoxConstraints(maxWidth: 350) : null,
                decoration: const BoxDecoration(borderRadius: defaultBorder),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final availableCategories = context.select((CategoriesCubit c) => c.state.categories);

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedSwitcher(
                          duration: panelTransition,
                          switchOutCurve: Curves.easeInOutQuart,
                          switchInCurve: Curves.easeInOutQuart,
                          transitionBuilder: (Widget child, Animation<double> animation) {
                            return ScaleTransition(scale: animation, child: child);
                          },
                          child: state.saving
                              ? SizedBox(height: 200, child: Center(child: LoadingIndicator()))
                              : Container(
                                  key: const Key("input"),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: defaultBorder,
                                    color: colors.surfaceContainer,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Stack(
                                        children: [
                                          Container(
                                            height: getHeaderHeight(context),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: colors.primaryContainer,
                                              borderRadius: BorderRadius.vertical(top: defaultBorder.topLeft),
                                            ),
                                            child: RepeatedIconsBackground(
                                              icon: state.category.icon!,
                                              size: 40,
                                              color: colors.onPrimaryContainer.withValues(alpha: 0.05),
                                              child: !canChangeCategory
                                                  ? getIconHeader(context, cat: state.category)
                                                  : Row(
                                                      children: [
                                                        Expanded(
                                                          child: CarouselSlider(
                                                            items: availableCategories
                                                                .map((e) => getIconHeader(context, cat: e))
                                                                .toList(),
                                                            options: CarouselOptions(
                                                              initialPage: context.select(
                                                                (CategoriesCubit c) => c.state.categories.indexWhere(
                                                                  (cat2) => cat2.id == state.category.id,
                                                                ),
                                                              ),
                                                              enlargeCenterPage: true,
                                                              enlargeFactor: 0.5,
                                                              viewportFraction: 0.35,
                                                              clipBehavior: Clip.none,
                                                              animateToClosest: true,
                                                              onPageChanged: (index, reason) =>
                                                                  cubit.setCategory(availableCategories[index]),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                            ),
                                          ),
                                          if (isWeb)
                                            Positioned(
                                              right: 10,
                                              top: 10,
                                              child: AnimatedOpacity(
                                                duration: panelTransition,
                                                opacity: state.saving ? 0 : 1,
                                                child: IconButton(
                                                  onPressed: () => Navigator.of(context).pop(),
                                                  icon: Icon(Icons.clear, color: colors.onPrimaryContainer, size: 20),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: defaultBorder,
                                            color: colors.secondaryContainer,
                                          ),
                                          child: Row(
                                            children: [
                                              Visibility(
                                                visible: !state.showCurrencyConversion,
                                                child: Expanded(
                                                  child: Container(
                                                    height: 70,
                                                    alignment: Alignment.centerRight,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(10.0),
                                                      child: Text(
                                                        cubit.valueToStr(state.value),
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          color: colors.onSecondaryContainer,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Visibility(
                                                visible: state.showCurrencyConversion,
                                                child: Expanded(
                                                  child: CurrencyConverter(
                                                    value: state.value,
                                                    valueFrom: state.valueFrom,
                                                    currencyConversion: state.currencyConversion,
                                                    setCurrencyConversion: cubit.setCurrencyConversion,
                                                    valueToStr: cubit.valueToStr,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      if (state.possiblePrices.isNotEmpty)
                                        SingleMotionBuilder(
                                          motion: MaterialSpringMotion.expressiveSpatialDefault(),
                                          from: 0,
                                          value: 100,
                                          builder: (context, value, child) =>
                                              Transform.scale(scaleY: value / 100, child: child),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 8),
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                spacing: 4,
                                                children: [
                                                  Icon(Icons.auto_awesome, size: 20, color: colors.primary),
                                                  Gap(8),
                                                  ...state.possiblePrices.map(
                                                    (e) => NoteSuggestionPill(
                                                      text: formatCurrency(e),
                                                      tapSuggestion: (text) {
                                                        cubit.setAmount(text);
                                                      },
                                                      current: false,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      KeyPad(addNumber: cubit.addNumber, removeNumber: cubit.removeNumber),
                                      const ExpenseActions(),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: FilledButton.tonal(
                                                onPressed: state.value.isNotEmpty
                                                    ? () async {
                                                        double iconHeight = getIconHeight(context) * 0.66;
                                                        final newExpense = await cubit.addExpense(
                                                          iconHeight,
                                                          colors.onPrimaryContainer,
                                                        );
                                                        if (context.mounted) {
                                                          Navigator.of(context).pop(newExpense);
                                                        }
                                                      }
                                                    : null,
                                                child: const Text('Save'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
