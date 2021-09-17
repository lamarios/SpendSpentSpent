import 'package:after_layout/after_layout.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/models/appColors.dart';
import 'package:spend_spent_spent/models/graphDataPoint.dart';
import 'package:spend_spent_spent/utils/colorUtils.dart';

class StatsGraph extends StatefulWidget {
  bool monthly;
  int categoryId;

  StatsGraph({required this.monthly, required this.categoryId});

  @override
  StatsGraphState createState() => StatsGraphState();
}

class StatsGraphState extends State<StatsGraph> with AfterLayoutMixin {
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
  bool avg = false;

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

  Future<void> getGraphData() async {
    List<GraphDataPoint> data = [];
    if (widget.monthly) {
      data = await service.getMonthlyData(widget.categoryId, count);
    } else {
      data = await service.getYearlyData(widget.categoryId, count);
    }
    data = data.reversed.toList();

    List<FlSpot> graphPoints = [];
    double total = 0;
    for (int i = 0; i < data.length; i++) {
      GraphDataPoint e = data[i];
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
        graphData = graphPoints;
        graphDataPoints = data;
        this.avgData = avgData;
      });
    }
  }

  LineChartData getData(BuildContext context) {
    AppColors colors = get(context);
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: colors.textOnMain.withOpacity(0.2),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: colors.textOnMain.withOpacity(0.2),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 35,
          rotateAngle: 90,
          getTextStyles: (context, value) => TextStyle(color: colors.textOnMain, fontSize: 10),
          getTitles: (value) {
            return graphDataPoints[value.toInt()].date;
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          reservedSize: 50,
          getTextStyles: (context, value) {
            return TextStyle(
              color: colors.textOnMain,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            );
          },
          getTitles: (value) {
            return formatCurrency(value);
          },
          margin: 12,
        ),
      ),
      borderData: FlBorderData(show: true, border: Border.all(color: colors.textOnMain.withOpacity(0.3), width: 1)),
      minX: 0,
      minY: avg && avgData.length > 0 ? (avgData[0].y * 0.7).ceil().toDouble() : 0,
      maxY: avg && avgData.length > 0 ? (avgData[0].y * 1.3).ceil().toDouble() : null,
      lineBarsData: [
        LineChartBarData(
          spots: avg ? avgData : graphData,
          isCurved: false,
          colors: [colors.textOnMain],
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors: [colors.textOnMain.withOpacity(0), colors.textOnMain.withOpacity(1)].map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    AppColors colors = get(context);
    return Column(
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  avg = !avg;
                });
              },
              behavior: HitTestBehavior.translucent,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                child: AnimatedContainer(
                    duration: panelTransition,
                    decoration: BoxDecoration(
                      color: avg ? colors.text : colors.iconOnMain,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                      child: Text(
                        'avg',
                        style: TextStyle(color: avg ? colors.iconOnMain : colors.text, fontSize: 10),
                      ),
                    )),
              ),
            )
          ],
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: LineChart(getData(context)),
          )),
        )),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  if (count > 5) {
                    setState(() {
                      count = count - 1;
                      getGraphData();
                    });
                  }
                },
                behavior: HitTestBehavior.translucent,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 14),
                  child: FaIcon(
                    FontAwesomeIcons.minus,
                    color: colors.textOnMain,
                    size: 15,
                  ),
                ),
              ),
              Text(
                count.toString() + (widget.monthly ? ' Months' : ' Years'),
                style: TextStyle(color: colors.textOnMain),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  setState(() {
                    count++;
                    getGraphData();
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 14),
                  child: FaIcon(
                    FontAwesomeIcons.plus,
                    size: 15,
                    color: colors.textOnMain,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    print('hello');
    getGraphData();
  }
}
