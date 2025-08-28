import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_loading_indicator/loading_indicator.dart';
import 'package:spend_spent_spent/expenses/state/below_date_in_calendar.dart';
import 'package:spend_spent_spent/globals.dart';

class BelowDateInCalendarWidget extends StatelessWidget {
  final DateTime month;

  const BelowDateInCalendarWidget({super.key, required this.month});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: BlocProvider(
        create: (context) =>
            BelowDateInCalendarCubit(BelowDateInCalendarState(), month),
        child: BlocBuilder<BelowDateInCalendarCubit, BelowDateInCalendarState>(
          builder: (context, state) {
            return SizedBox(
              height: 20,
              child: AnimatedSwitcher(
                duration: animationDuration,
                switchInCurve: animationCurve,
                switchOutCurve: animationCurve,
                child: state.loading
                    ? SizedBox(width: 20, height: 20, child: LoadingIndicator())
                    : Text(
                        formatCurrency(state.amount ?? 0),
                        style: textTheme.labelMedium?.copyWith(
                          color: colors.primary,
                        ),
                      ).animate().slideY(
                        duration: animationDuration,
                        curve: animationCurve,
                        begin: 0.5,
                      ),
              ),
            );
          },
        ),
      ),
    );
  }
}
