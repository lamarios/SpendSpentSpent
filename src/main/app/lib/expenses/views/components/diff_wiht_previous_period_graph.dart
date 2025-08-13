import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:spend_spent_spent/expenses/state/diff_with_previous_month_graph.dart';
import 'package:spend_spent_spent/globals.dart';

final DateFormat _df = DateFormat.yMMMd();
const double _graphHeight = 300;

class DiffWithPreviousPeriodGraph extends StatelessWidget {
  final DateTimeRange currentPeriod;
  final DateTimeRange previousPeriod;
  final bool includeRecurring;

  const DiffWithPreviousPeriodGraph(
      {super.key,
      required this.currentPeriod,
      required this.previousPeriod,
      required this.includeRecurring});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final List<Color> lineColors = [colors.primary, colors.tertiary];

    final textTheme = Theme.of(context).textTheme;
    return BlocProvider(
        create: (context) => DiffWithPreviousMonthGraphCubit(
            DiffWithPreviousMonthGraphState(
                previousPeriod: previousPeriod,
                currentPeriod: currentPeriod,
                includeRecurring: includeRecurring)),
        child: BlocBuilder<DiffWithPreviousMonthGraphCubit,
            DiffWithPreviousMonthGraphState>(builder: (context, state) {
          return AnimatedSwitcher(
            duration: animationDuration,
            child: state.loading
                ? SizedBox(
                    height: _graphHeight,
                    child: Center(child: CircularProgressIndicator()))
                : Column(
                    children: [
                      SizedBox(
                        height: _graphHeight,
                        child: LineChart(
                          LineChartData(
                              baselineX: 1,
                              baselineY: 0,
                              maxY: max(
                                      state
                                          .spots
                                          .first[state.spots.first.length - 1]
                                          .y,
                                      state
                                          .spots
                                          .last[state.spots.last.length - 1]
                                          .y) *
                                  1.1,
                              minY: 0,
                              lineTouchData: LineTouchData(
                                  touchTooltipData: LineTouchTooltipData(
                                      fitInsideHorizontally: true,
                                      fitInsideVertically: true,
                                      getTooltipColor: (touchedSpot) =>
                                          colors.secondaryContainer,
                                      getTooltipItems: (list) {
                                        return list.map((e) {
                                          final date = e.barIndex == 0
                                              ? currentPeriod.start
                                                  .copyWith(day: e.x.toInt())
                                              : previousPeriod.start
                                                  .copyWith(day: e.x.toInt());

                                          return LineTooltipItem(
                                              '${_df.format(date)}: ${formatCurrency(e.y)}',
                                              textTheme.bodySmall!.copyWith(
                                                  color:
                                                      lineColors[e.barIndex]));
                                        }).toList();
                                      })),
                              titlesData: FlTitlesData(
                                rightTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                                // rightTitles: SideTitles(showTitles: false),
                                topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                                leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 50,
                                        getTitlesWidget: (value, meta) {
                                          var style = TextStyle(
                                            color: colors.onSurface,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                          );
                                          return Text(formatCurrency(value),
                                              style: style);
                                        })),
                              ),
                              lineBarsData: state.spots.indexed
                                  .map<LineChartBarData>(
                                      (s) => LineChartBarData(
                                            isStrokeJoinRound: true,
                                            spots: s.$2,
                                            isCurved: false,
                                            color: lineColors[s.$1],
                                            isStrokeCapRound: true,
                                            dotData: const FlDotData(
                                              show: false,
                                            ),
                                            belowBarData: BarAreaData(
                                              show: false,
                                              color: colors.onSurface
                                                  .withValues(alpha: 0.2),
                                            ),
                                          ))
                                  .toList()),
                        ),
                      ),
                      _Legend(range: currentPeriod, color: lineColors[0]),
                      Gap(4),
                      _Legend(range: previousPeriod, color: lineColors[1]),
                    ],
                  ),
          );
        }));
  }
}

class _Legend extends StatelessWidget {
  final DateTimeRange range;
  final Color color;

  const _Legend({required this.range, required this.color});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
        Gap(8),
        Expanded(
            child: Text(
          '${_df.format(range.start)} to ${_df.format(range.end)}',
          style: textTheme.labelMedium,
        ))
      ],
    );
  }
}
