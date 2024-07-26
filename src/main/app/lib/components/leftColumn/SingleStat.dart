import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spend_spent_spent/components/leftColumn/StatsGraph.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/icons.dart';
import 'package:spend_spent_spent/models/leftColumnStats.dart';

class SingleStats extends StatefulWidget {
  final LeftColumnStats stats;
  final bool monthly;

  const SingleStats({super.key, required this.monthly, required this.stats});

  @override
  SingleStatsState createState() => SingleStatsState();
}

class SingleStatsState extends State<SingleStats> {
  bool open = false, showGraph = false;
  double openedHeight = 400;

  double getBarWidth(BuildContext context, BoxConstraints constraints) {
    final percentage = widget.stats.amount / widget.stats.total;

    if (open) {
      return constraints.maxWidth;
    } else if (widget.stats.total > 0) {
      return constraints.maxWidth * percentage;
    } else {
      return 0;
    }
  }

  openContainer(BuildContext context) {
    setState(() {
      if (!open) {
        open = true;
        Future.delayed(panelTransition, () {
          if (open) {
            Scrollable.ensureVisible(context,
                curve: Curves.easeInOutQuart,
                duration: panelTransition,
                alignmentPolicy:
                    ScrollPositionAlignmentPolicy.keepVisibleAtEnd);
            setState(() {
              showGraph = true;
            });
          }
        });
      }
    });
  }

  closeContainer() {
    setState(() {
      open = false;
      showGraph = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: GestureDetector(
        onTap: () => openContainer(context),
        behavior: HitTestBehavior.translucent,
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: AnimatedRotation(
                      turns: open ? 0.25 : 0,
                      duration: panelTransition,
                      curve: Curves.easeInOutQuart,
                      child: FaIcon(
                        FontAwesomeIcons.chevronRight,
                        size: 10,
                        color: colors.onSurface,
                      )),
                ),
                Visibility(
                    visible: widget.stats.category.id != -1,
                    child: getIcon(widget.stats.category.icon!,
                        color: colors.primary, size: 20)),
                const Spacer(),
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
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    // gradient: LinearGradient(colors: [Colors.blueAccent, Colors.blue], stops: [0, 0.75], begin: Alignment.bottomCenter, end: Alignment.topRight),
                    color: colors.surfaceContainer),
                child: LayoutBuilder(
                  builder: (context, constraints) => AnimatedContainer(
                    duration: panelTransition,
                    curve: Curves.easeInOutQuart,
                    width: getBarWidth(context, constraints),
                    height: open ? openedHeight : 10,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        color: colors.primaryContainer),
                    child: Visibility(
                      visible: showGraph,
                      child: FadeIn(
                        duration: panelTransition,
                        child: StatsGraph(
                            categoryId: widget.stats.category.id!,
                            monthly: widget.monthly,
                            close: closeContainer),
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
}
