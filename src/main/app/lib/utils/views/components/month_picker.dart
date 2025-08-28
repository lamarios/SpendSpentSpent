import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/utils/states/month_picker.dart';
import 'package:spend_spent_spent/utils/views/components/conditional_wrapper.dart';

const double _borderRadius = 20;
const double _arrowSizes = 44;
const List<String> _monthNames = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December",
];

class MonthPicker extends StatelessWidget {
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime initialDate;
  final bool Function(DateTime date) monthPredicate;
  final Widget Function(DateTime date)? belowDateWidget;

  const MonthPicker({
    super.key,
    required this.firstDate,
    required this.lastDate,
    required this.initialDate,
    required this.monthPredicate,
    this.belowDateWidget,
  });

  static Future<DateTime?> show(
    BuildContext context, {
    required DateTime firstDate,
    required DateTime lastDate,
    required DateTime initialDate,
    required bool Function(DateTime date) monthPredicate,
    Widget Function(DateTime date)? belowDateWidget,
  }) async {
    return showDialog<DateTime>(
      context: context,
      builder: (context) => MonthPicker(
        firstDate: firstDate,
        lastDate: lastDate,
        initialDate: initialDate,
        monthPredicate: monthPredicate,
        belowDateWidget: belowDateWidget,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BlocProvider(
            create: (context) => MonthPickerCubit(
              MonthPickerState(
                selected: initialDate,
                selectedYear: initialDate.year,
              ),
            ),
            child: Container(
              margin: EdgeInsets.all(36),
              constraints: BoxConstraints(maxWidth: BIG_PHONE.toDouble()),
              decoration: BoxDecoration(
                color: colors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(_borderRadius),
              ),
              child: BlocBuilder<MonthPickerCubit, MonthPickerState>(
                builder: (context, state) {
                  final List<Widget> months = [];

                  for (int i = 1; i <= 12; i++) {
                    months.add(
                      _Month(
                        month: i,
                        selected:
                            state.selected.year == state.selectedYear &&
                            state.selected.month == i,
                        enabled: monthPredicate(
                          DateTime(state.selectedYear, i),
                        ),
                        belowDateWidget: belowDateWidget != null
                            ? belowDateWidget!(DateTime(state.selectedYear, i))
                            : null,
                      ),
                    );
                  }

                  final cubit = context.read<MonthPickerCubit>();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: colors.primaryContainer,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(_borderRadius),
                            topRight: Radius.circular(_borderRadius),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(36.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      state.selectedYear.toString(),
                                      style: textTheme.displaySmall,
                                    ),
                                    Text(
                                      'Selected: ${monthFormatter.format(state.selected)}',
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: state.selectedYear > firstDate.year
                                    ? () {
                                        if (state.selectedYear >
                                            firstDate.year) {
                                          cubit.setYear(state.selectedYear - 1);
                                        }
                                      }
                                    : null,
                                icon: Icon(
                                  Icons.chevron_left,
                                  size: _arrowSizes,
                                ),
                              ),
                              IconButton(
                                onPressed: state.selectedYear < lastDate.year
                                    ? () {
                                        if (state.selectedYear <
                                            lastDate.year) {
                                          cubit.setYear(state.selectedYear + 1);
                                        }
                                      }
                                    : null,
                                icon: Icon(
                                  Icons.chevron_right,
                                  size: _arrowSizes,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child:
                            GridView.count(
                                  key: ValueKey(state.selectedYear),
                                  crossAxisCount:
                                      isTabletFromSize(
                                        MediaQuery.sizeOf(context),
                                      )
                                      ? 4
                                      : 3,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  children: months,
                                )
                                .animate(key: ValueKey(state.selectedYear))
                                .fadeIn(duration: animationDuration, begin: 0)
                                .slideY(
                                  curve: animationCurve,
                                  duration: animationDuration,
                                  begin: 0.05,
                                ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(null),
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () =>
                                Navigator.of(context).pop(state.selected),
                            child: Text('Select'),
                          ),
                        ],
                      ),
                      Gap(8),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Month extends StatelessWidget {
  final int month;
  final bool selected;
  final bool enabled;
  final Widget? belowDateWidget;

  const _Month({
    required this.month,
    required this.selected,
    required this.enabled,
    this.belowDateWidget,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: enabled
          ? () {
              var cubit = context.read<MonthPickerCubit>();
              return cubit.setMonth(DateTime(cubit.state.selectedYear, month));
            }
          : null,
      child: AnimatedScale(
        duration: animationDuration,
        curve: animationCurve,
        scale: selected ? 1.15 : 1,
        child: AnimatedContainer(
          duration: animationDuration,
          curve: animationCurve,
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: selected
                ? colors.primaryContainer
                : colors.surfaceContainerHigh,
          ),
          child: Center(
            child: ConditionalWrapper(
              wrapIf: enabled && belowDateWidget != null,
              wrapper: (child) => Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [child, belowDateWidget!],
              ),
              child: Text(
                _monthNames[month - 1],
                style: textTheme.bodyMedium?.copyWith(
                  color: selected
                      ? colors.onPrimaryContainer
                      : enabled
                      ? colors.onSurface
                      : colors.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
