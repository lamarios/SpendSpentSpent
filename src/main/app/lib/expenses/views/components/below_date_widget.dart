import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_loading_indicator/loading_indicator.dart';
import 'package:motor/motor.dart';
import 'package:spend_spent_spent/expenses/state/monthly_picker_wrapper.dart';
import 'package:spend_spent_spent/globals.dart';

class BelowDateInCalendarWidget extends StatelessWidget {
  final DateTime month;

  const BelowDateInCalendarWidget({super.key, required this.month});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return BlocBuilder<MonthlyPickerWrapperCubit, MonthlyPickerWrapperState>(
      builder: (context, state) {
        double total = state.totals[int.parse('${month.year}${month.month.toString().padLeft(2, "0")}')] ?? 0;
        return Padding(
          padding: const EdgeInsets.only(top: 4),
          child: SizedBox(
            height: 20,
            child: AnimatedSwitcher(
              duration: animationDuration,
              switchInCurve: animationCurve,
              switchOutCurve: animationCurve,
              child: state.loading
                  ? SizedBox(width: 20, height: 20, child: LoadingIndicator())
                  : SingleMotionBuilder(
                      motion: MaterialSpringMotion.expressiveSpatialDefault(),
                      from: -50,
                      value: 0,
                      builder: (context, value, child) => Transform.translate(offset: Offset(0, value), child: child),
                      child: Text(formatCurrency(total), style: textTheme.labelMedium?.copyWith(color: colors.primary)),
                    ),
            ),
          ),
        );
      },
    );
  }
}
