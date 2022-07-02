import 'dart:math';
import 'package:after_layout/after_layout.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spend_spent_spent/components/dummies/DummyFade.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/models/appColors.dart';
import 'package:spend_spent_spent/models/expenseLimit.dart';
import 'package:spend_spent_spent/models/graphDataPoint.dart';
import 'package:spend_spent_spent/utils/colorUtils.dart';
import 'package:tinycolor2/tinycolor2.dart';

import '../../utils/debouncer.dart';

class StatsGraph extends StatefulWidget {
  bool monthly;
  int categoryId;
  Function close;

  StatsGraph({required this.monthly, required this.categoryId, required this.close});

  @override
  StatsGraphState createState() => StatsGraphState();
}

class StatsGraphState extends State<StatsGraph> with AfterLayoutMixin {
  static const AVG_BAR_WIDTH = 1.5;
  static const MIN_PERIOD = 2;
  Debouncer debouncer = Debouncer(milliseconds: 500);

  int periodMax = 10;

  bool loadingFirst = true;
  List<FlSpot> graphData = [
    FlSpot(0, 0),
    FlSpot(1, 0),
    FlSpot(2, 0),
    FlSpot(3, 0),
    FlSpot(4, 0),
  ];

  List<FlSpot> avgData = [
    FlSpot(0, 0),
    FlSpot(1, 0),
    FlSpot(2, 0),
    FlSpot(3, 0),
    FlSpot(4, 0),
  ];

  List<GraphDataPoint> graphDataPoints = [
    GraphDataPoint(date: '2021', amount: 0),
    GraphDataPoint(date: '2020', amount: 0),
    GraphDataPoint(date: '2019', amount: 0),
    GraphDataPoint(date: '2018', amount: 0),
    GraphDataPoint(date: '2017', amount: 0),
  ];

  int count = 5;
  double minValue = 0, maxValue = 0;

  List<Color> gradientColors = [
    const Color.fromRGBO(255, 255, 255, 0),
    const Color.fromRGBO(255, 255, 255, 1),
  ];

  @override
  didUpdateWidget(StatsGraph oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.monthly != oldWidget.monthly) {
      getGraphData();
    }
  }

  changeCount(int count) {
    setState(() {
      this.count = max(count, MIN_PERIOD);
      debouncer.run(() => getGraphData());
    });
  }

  Future<void> getLimits() async {
    var expenseLimits = await service.getExpenseLimits();
    setState(() {
      periodMax = max(periodMax, widget.monthly ? expenseLimits.months + 3 : expenseLimits.years + 3);
    });
  }

  Future<void> getGraphData() async {
    this.getLimits().then((value) async {
      List<GraphDataPoint> data = [];
      if (widget.monthly) {
        data = await service.getMonthlyData(widget.categoryId, count);
      } else {
        data = await service.getYearlyData(widget.categoryId, count);
      }
      data = data.reversed.toList();

      List<FlSpot> graphPoints = [];
      double total = 0;
      double minValue = 99999999999;
      double maxValue = 0;
      for (int i = 0; i < data.length; i++) {
        GraphDataPoint e = data[i];
        minValue = min(minValue, e.amount);
        maxValue = max(maxValue, e.amount);
        total += e.amount;
        graphPoints.add(FlSpot(i.toDouble(), e.amount));
      }

      double average = total / data.length;

      List<FlSpot> avgData = [];
      for (int i = 0; i < data.length; i++) {
        avgData.add(FlSpot(i.toDouble(), average));
      }

      if (this.mounted) {
        setState(() {
          loadingFirst = false;
          graphData = graphPoints;
          graphDataPoints = data;
          this.avgData = avgData;
          this.minValue = minValue * 0.7;
          this.maxValue = maxValue * 1.3;
        });
      }
    });
  }

  LineChartData getData(BuildContext context) {
    AppColors colors = get(context);
    return LineChartData(
      lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
              fitInsideHorizontally: true,
              fitInsideVertically: true,
              getTooltipItems: (list) {
                return list.map((e) {
                  bool avg = e.bar.barWidth == AVG_BAR_WIDTH;
                  String text = avg ? "Avg: " : "";
                  return LineTooltipItem(text + formatCurrency(e.y), TextStyle(color: avg ? colors.textOnMain.withOpacity(0.7) : colors.textOnMain, fontSize: avg ? 12 : 20));
                }).toList();
              })),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: colors.textOnMain.withOpacity(0.075),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: colors.textOnMain.withOpacity(0.075),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        // rightTitles: SideTitles(showTitles: false),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        // topTitles: SideTitles(showTitles: false),
        bottomTitles: AxisTitles(
            sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 35,
                getTitlesWidget: (value, meta) {
                  var style = TextStyle(
                    color: colors.textOnMain,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  );

                  if (value == value.roundToDouble()) {
                    return Padding(
                        padding: EdgeInsets.only(top: 12), child: RotationTransition(turns: AlwaysStoppedAnimation(-45 / 360), child: Text(graphDataPoints[value.toInt()].date, style: style)));
                  } else {
                    return Text('');
                  }
                })),
        leftTitles: AxisTitles(
            sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 50,
                getTitlesWidget: (value, meta) {
                  var style = TextStyle(
                    color: colors.textOnMain,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  );
                  return Text(formatCurrency(value), style: style);
                })),
      ),
      borderData: FlBorderData(show: true, border: Border.all(color: colors.textOnMain.withOpacity(0.3), width: 1)),
      minX: 0,
      minY: this.minValue,
      maxY: this.maxValue,
      lineBarsData: [
        LineChartBarData(
          isStrokeJoinRound: true,
          spots: avgData,
          isCurved: false,
          color: colors.textOnMain.withOpacity(0.5),
          barWidth: AVG_BAR_WIDTH,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: false,
            color: colors.textOnMain.withOpacity(0.2),
          ),
        ),
        LineChartBarData(
          spots: graphData,
          isCurved: false,
          color: colors.textOnMain,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            color: colors.textOnMain.withOpacity(0.2),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    String label = '$count ${widget.monthly ? "months" : "years"}';
    AppColors colors = get(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () => widget.close(),
              behavior: HitTestBehavior.translucent,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, right: 8.0),
                child: AnimatedContainer(
                    duration: panelTransition,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                      child: FaIcon(
                        FontAwesomeIcons.xmark,
                        color: colors.textOnMain,
                        size: 20,
                      ),
                    )),
              ),
            )
          ],
        ),
        Expanded(
          child: AnimatedSwitcher(
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            duration: panelTransition,
            switchInCurve: Curves.easeInOutQuart,
            switchOutCurve: Curves.easeInOutQuart,
            child: loadingFirst
                ? DummyFade(child: FaIcon(FontAwesomeIcons.chartLine, color: colors.mainDark, size: 90, key: Key('loading')))
                : Column(
                    children: [
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: LineChart(getData(context)),
                        )),
                      )),
                      Container(
                        child: Text(label, style: TextStyle(color: colors.textOnMain)),
                        alignment: Alignment.center,
                      ),
                      Slider.adaptive(

                        min: 1,
                        max: periodMax.toDouble(),
                        divisions: this.periodMax-1,
                        onChangeEnd: (p0) => this.changeCount(p0.toInt()),
                        value: count.toDouble(),
                        activeColor: colors.textOnMain,
                        inactiveColor: colors.mainDark,
                        thumbColor: colors.main.lighten(10),
                        onChanged: (double) {
                          setState(() {
                            if (double >= MIN_PERIOD) {
                              this.count = double.toInt();
                            }
                          });
                        },
                      )
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    getGraphData();
  }
}
