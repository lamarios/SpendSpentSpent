import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spend_spent_spent/add_expense_dialog/state/add_expense_dialog.dart';
import 'package:spend_spent_spent/categories/models/category.dart';
import 'package:spend_spent_spent/components/dummies/DummyFade.dart';
import 'package:spend_spent_spent/components/expenseDialog/actions.dart';
import 'package:spend_spent_spent/components/expenseDialog/currencyConverter.dart';
import 'package:spend_spent_spent/components/expenseDialog/keypad.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/icons.dart';

const LOCATION_TIMEOUT = 10;

class AddExpense extends StatelessWidget {
  final Category category;

  const AddExpense({super.key, required this.category});

  double getIconHeight(MediaQueryData mq) {
    return min(mq.size.height / 6, 150);
  }

  Widget getIconHeader(BuildContext context) {
    final state = context.read<AddExpenseDialogCubit>().state;

    double iconHeight = getIconHeight(MediaQuery.of(context));

    final colors = Theme.of(context).colorScheme;

    if (state.saving && state.savingIcon != null) {
      return state.savingIcon!;
    } else {
      return getIcon(category.icon!,
          size: iconHeight * 0.66, color: colors.onPrimaryContainer);
    }
  }

  double getHeaderHeight(BuildContext context) {
    MediaQueryData mq = MediaQuery.of(context);

    return min(mq.size.height / 6, 150.toDouble());
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return BlocProvider(
      create: (context) => AddExpenseDialogCubit(
          AddExpenseDialogState(expenseDate: DateTime.now()),
          category: category),
      child: BlocBuilder<AddExpenseDialogCubit, AddExpenseDialogState>(
          builder: (context, state) {
        final cubit = context.read<AddExpenseDialogCubit>();

        return Container(
          alignment: Alignment.center,
          color: colors.surface.withOpacity(0),
          padding: const EdgeInsets.all(0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 350),
            decoration: const BoxDecoration(
              borderRadius: defaultBorder,
            ),
            child: LayoutBuilder(builder: (context, constraints) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedSwitcher(
                    duration: panelTransition,
                    switchOutCurve: Curves.easeInOutQuart,
                    switchInCurve: Curves.easeInOutQuart,
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: state.saving
                        ? Container(
                            key: const Key("saving"),
                            height: 150,
                            width: 150,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: colors.primaryContainer,
                                borderRadius: defaultBorder),
                            child: Hero(
                                tag: category.icon!,
                                child: DummyFade(
                                    running: state.saving,
                                    child: AnimatedSwitcher(
                                        duration:
                                            const Duration(milliseconds: 130),
                                        transitionBuilder: (Widget child,
                                            Animation<double> animation) {
                                          return ScaleTransition(
                                              scale: animation, child: child);
                                        },
                                        switchInCurve: Curves.easeInOutQuart,
                                        switchOutCurve: Curves.easeInOutQuart,
                                        child: getIconHeader(context)))),
                          )
                        : Container(
                            key: const Key("input"),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: defaultBorder,
                              color: colors.surfaceContainer,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      height: getHeaderHeight(context),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: colors.primaryContainer,
                                          borderRadius: BorderRadius.vertical(
                                              top: defaultBorder.topLeft)),
                                      child: Hero(
                                          tag: category.icon!,
                                          child: getIconHeader(context)),
                                    ),
                                    Positioned(
                                      right: 10,
                                      top: 10,
                                      child: AnimatedOpacity(
                                        duration: panelTransition,
                                        opacity: state.saving ? 0 : 1,
                                        child: IconButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            icon: FaIcon(
                                              FontAwesomeIcons.xmark,
                                              color: colors.onPrimaryContainer,
                                              size: 20,
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: defaultBorder,
                                      color: colors.surface,
                                    ),
                                    child: Row(
                                      children: [
                                        Visibility(
                                          visible:
                                              !state.showCurrencyConversion,
                                          child: Expanded(
                                              child: Container(
                                                  height: 70,
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Text(
                                                        cubit.valueToStr(
                                                            state.value),
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            color: colors
                                                                .onSurface)),
                                                  ))),
                                        ),
                                        Visibility(
                                          visible: state.showCurrencyConversion,
                                          child: Expanded(
                                              child: CurrencyConverter(
                                            value: state.value,
                                            valueFrom: state.valueFrom,
                                            currencyConversion:
                                                state.currencyConversion,
                                            setCurrencyConversion:
                                                cubit.setCurrencyConversion,
                                            valueToStr: cubit.valueToStr,
                                          )),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                KeyPad(
                                    addNumber: cubit.addNumber,
                                    removeNumber: cubit.removeNumber),
                                ExpenseActions(
                                  noteSuggestions: state.noteSuggestions,
                                  expenseDate: state.expenseDate,
                                  setDate: cubit.setDate,
                                  setNote: cubit.setNote,
                                  location: state.useLocation,
                                  gettingLocation: state.gettingLocation,
                                  setLocation: cubit.setLocation,
                                  currencyConversionEnabled:
                                      state.showCurrencyConversion,
                                  enableCurrencyConversion:
                                      cubit.enableCurrencyConversion,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          child: FilledButton.tonal(
                                        onPressed: state.value.length > 0
                                            ? () async {
                                                double iconHeight =
                                                    getIconHeight(MediaQuery.of(
                                                            context)) *
                                                        0.66;
                                                await cubit.addExpense(
                                                    iconHeight,
                                                    colors.onPrimaryContainer);
                                                Navigator.of(context).pop();
                                              }
                                            : null,
                                        child: const Text('Save'),
                                      )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ],
              );
            }),
          ),
        );
      }),
    );
  }
}
