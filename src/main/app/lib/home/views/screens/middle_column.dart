import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_spent_spent/categories/views/components/category_list.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/home/states/middle_column.dart';
import 'package:spend_spent_spent/recurring_expenses/views/components/recurring_expense_list.dart';
import 'package:spend_spent_spent/utils/views/components/switcher.dart';

@RoutePage()
class MiddleColumnTab extends StatelessWidget {
  const MiddleColumnTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MiddleColumnCubit(0),
      child: BlocBuilder<MiddleColumnCubit, int>(builder: (context, selected) {
        final cubit = context.read<MiddleColumnCubit>();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Switcher(
                    selected: selected,
                    labels: const ['Normal', 'Recurring'],
                    onSelect: cubit.setTab),
              ),
              Expanded(
                  child: AnimatedSwitcher(
                      duration: panelTransition,
                      switchInCurve: Curves.easeInOutQuart,
                      switchOutCurve: Curves.easeInOutQuart,
                      child: selected == 0
                          ? const CategoryList()
                          : const RecurringExpenseList()))
            ],
          ),
        );
      }),
    );
  }
}
