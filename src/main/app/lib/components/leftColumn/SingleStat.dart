import 'package:after_layout/after_layout.dart';
import 'package:animated_rotation/animated_rotation.dart';
import 'package:app/components/leftColumn/StatsGraph.dart';
import 'package:app/globals.dart';
import 'package:app/icons.dart';
import 'package:app/models/leftColumnStats.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SingleStats extends StatefulWidget {
  LeftColumnStats stats;
  bool monthly;
  Key key;

  SingleStats({required this.monthly, required this.key, required this.stats});

  @override
  SingleStatsState createState() => SingleStatsState();
}

class SingleStatsState extends State<SingleStats> with AfterLayoutMixin {
  bool open = false, showGraph = false, showPercentage = false;
  double openedHeight = 300;

  double getBarWidth(BoxConstraints constraints) {
    if (open) {
      return constraints.maxWidth;
    } else if (showPercentage && widget.stats.total > 0) {
      double percentage = widget.stats.amount / widget.stats.total;
      return constraints.maxWidth * percentage;
    } else {
      return 0;
    }
  }

  toggleContainer() {
    setState(() {
      open = !open;
      Future.delayed(panelTransition, () {
        if (open) {
          setState(() {
            showGraph = true;
          });
        }
      });

      if (!open) {
        showGraph = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: GestureDetector(
        onTap: toggleContainer,
        behavior: HitTestBehavior.translucent,
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: AnimatedRotation(angle: open ? 90 : 0, duration: panelTransition, curve: Curves.easeInOutQuart, child: FaIcon(FontAwesomeIcons.chevronRight, size: 10)),
                ),
                Visibility(visible: widget.stats.category.id != -1, child: getIcon(widget.stats.category.icon!, color: Theme.of(context).primaryColor, size: 20)),
                Spacer(),
                Text(formatCurrency(widget.stats.amount)),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: AnimatedContainer(
                duration: panelTransition,
                curve: Curves.easeInOutQuart,
                alignment: Alignment.topLeft,
                height: open ? openedHeight : 10,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    // gradient: LinearGradient(colors: [Colors.blueAccent, Colors.blue], stops: [0, 0.75], begin: Alignment.bottomCenter, end: Alignment.topRight),
                    color: Colors.grey[300]),
                child: LayoutBuilder(
                  builder: (context, constraints) => AnimatedContainer(
                    duration: panelTransition,
                    curve: Curves.easeInOutQuart,
                    width: getBarWidth(constraints),
                    height: open ? openedHeight : 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      gradient: LinearGradient(colors: [Colors.blueAccent, Colors.blue], stops: [0, 0.75], begin: Alignment.bottomCenter, end: Alignment.topRight),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: widget.stats.amount > 0 ? 1 : 0,
                          blurRadius: widget.stats.amount > 0 ? 2 : 0,
                          offset: Offset(2, 2),
                        )
                      ],
                    ),
                    child: Visibility(
                      visible: showGraph,
                      child: FadeIn(
                        duration: panelTransition,
                        child: StatsGraph(categoryId: widget.stats.category.id!, monthly: widget.monthly),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    setState(() {
      showPercentage = true;
    });
  }
}
