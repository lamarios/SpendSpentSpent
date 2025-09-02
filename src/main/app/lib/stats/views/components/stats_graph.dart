import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_loading_indicator/loading_indicator.dart';
import 'package:motor/motor.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/stats/state/stats_graph.dart';
import 'package:tinycolor2/tinycolor2.dart';

const AVG_BAR_WIDTH = 1.5;
const MIN_PERIOD = 2;

class StatsGraph extends StatelessWidget {
  final bool monthly;
  final int categoryId;
  final Function close;

  const StatsGraph({
    super.key,
    required this.monthly,
    required this.categoryId,
    required this.close,
  });

  LineChartData getData(BuildContext context) {
    final cubit = context.read<StatsGraphCubit>();
    final state = cubit.state;

    final colors = Theme.of(context).colorScheme;
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          fitInsideHorizontally: true,
          fitInsideVertically: true,
          getTooltipItems: (list) {
            return list.map((e) {
              bool avg = e.bar.barWidth == AVG_BAR_WIDTH;
              String text = avg ? "Avg: " : "";
              return LineTooltipItem(
                text + formatCurrency(e.y),
                TextStyle(
                  color: avg
                      ? Colors.white.withValues(alpha: 0.7)
                      : Colors.white,
                  fontSize: avg ? 12 : 20,
                ),
              );
            }).toList();
          },
        ),
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: colors.onSurface.withValues(alpha: 0.075),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: colors.onSurface.withValues(alpha: 0.075),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        // rightTitles: SideTitles(showTitles: false),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        // topTitles: SideTitles(showTitles: false),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 35,
            getTitlesWidget: (value, meta) {
              var style = TextStyle(
                color: colors.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              );

              if (value == value.roundToDouble()) {
                return Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: RotationTransition(
                    turns: const AlwaysStoppedAnimation(-45 / 360),
                    child: Text(
                      state.graphDataPoints[value.toInt()].date,
                      style: style,
                    ),
                  ),
                );
              } else {
                return const Text('');
              }
            },
          ),
        ),
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
              return Text(formatCurrency(value), style: style);
            },
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(
          color: colors.onSurface.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      minX: 0,
      minY: state.minValue,
      maxY: state.maxValue,
      lineBarsData: [
        LineChartBarData(
          isStrokeJoinRound: true,
          spots: state.avgData,
          isCurved: false,
          color: colors.onSurface.withValues(alpha: 0.5),
          barWidth: AVG_BAR_WIDTH,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: false,
            color: colors.onSurface.withValues(alpha: 0.2),
          ),
        ),
        LineChartBarData(
          spots: state.graphData,
          isCurved: false,
          color: colors.onSurface,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            color: colors.onSurface.withValues(alpha: 0.2),
          ),
        ),
      ],
    );
  }

  String getLabel(BuildContext context) {
    final cubit = context.read<StatsGraphCubit>();
    final state = cubit.state;

    if (monthly) {
      int years = (state.count / 12).floor();
      int months = state.count % 12;

      if (years == 0) {
        return '${state.count} months';
      } else if (months == 0) {
        return '$years year${years > 1 ? 's' : ''}';
      } else {
        return '$years year${years > 1 ? 's' : ''} and $months month${months > 1 ? 's' : ''}';
      }
    } else {
      return '${state.count} years';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return BlocProvider(
      create: (context) => StatsGraphCubit(
        const StatsGraphState(),
        monthly: monthly,
        categoryId: categoryId,
      ),
      child: BlocBuilder<StatsGraphCubit, StatsGraphState>(
        builder: (context, state) {
          final cubit = context.read<StatsGraphCubit>();

          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => close(),
                    behavior: HitTestBehavior.translucent,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0, right: 8.0),
                      child: AnimatedContainer(
                        duration: panelTransition,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15.0,
                            vertical: 5,
                          ),
                          child: Icon(
                            Icons.clear,
                            color: colors.onSurface,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: animationDuration,
                  child: state.loading
                      ? Center(child: LoadingIndicator())
                      : SingleMotionBuilder(
                          motion:
                              MaterialSpringMotion.expressiveSpatialDefault(),
                          from: 0,
                          value: 100,
                          builder: (context, value, child) =>
                              Transform.scale(scale: value / 100, child: child),
                          child: Column(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: LineChart(getData(context)),
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: Text(
                                  getLabel(context),
                                  style: TextStyle(color: colors.onSurface),
                                ),
                              ),
                              Slider.adaptive(
                                min: 1,
                                max: state.periodMax.toDouble(),
                                divisions: state.periodMax - 1,
                                onChangeEnd: (p0) =>
                                    cubit.changeCount(p0.toInt()),
                                value: state.count.toDouble(),
                                activeColor: colors.onSurface,
                                inactiveColor: colors.secondaryContainer,
                                thumbColor: colors.primary.lighten(10),
                                onChanged: (double double) =>
                                    cubit.setLiveCount(double),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
