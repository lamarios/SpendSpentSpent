import 'package:after_layout/after_layout.dart';
import 'package:auto_route/annotations.dart';
import 'package:flutter/cupertino.dart';
import 'package:spend_spent_spent/components/dummies/dummyStatsList.dart';
import 'package:spend_spent_spent/components/leftColumn/SingleStat.dart';
import 'package:spend_spent_spent/utils/views/components/switcher.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/models/leftColumnStats.dart';

@RoutePage()
class LeftColumnTab extends StatefulWidget {
  @override
  LeftColumnTabState createState() => LeftColumnTabState();
}

class LeftColumnTabState extends State<LeftColumnTab> with AfterLayoutMixin {
  int selected = 0;
  List<LeftColumnStats> stats = [];
  Widget statsWidget = DummyStatsList();

  switchTab(int selected) {
    setState(() {
      this.selected = selected;
      getStats();
    });
  }

  Future<void> getStats() async {
    setState(() {
      statsWidget = DummyStatsList();
    });
    List<LeftColumnStats> stats = [];
    switch (selected) {
      case 0:
        stats = await service.getMonthStats();
        break;
      case 1:
        stats = await service.getYearStats();
        break;
    }

    if (this.mounted) {
      setState(() {
        this.stats = stats;
        buildWidget();
      });
    }
  }

  void buildWidget() {
    setState(() {
      this.statsWidget = ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: stats.length,
        itemBuilder: (context, index) {
          return SingleStats(
            key: Key(stats[index].category.id.toString()),
            stats: stats[index],
            monthly: selected == 0,
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 20),
            child: Switcher(
              selected: selected,
              labels: ['Monthly', 'Yearly'],
              onSelect: switchTab,
            ),
          ),
          Expanded(child: AnimatedSwitcher(duration: panelTransition,
          child: statsWidget))
        ],
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    getStats();
  }
}
