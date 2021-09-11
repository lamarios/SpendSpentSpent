import 'package:after_layout/after_layout.dart';
import 'package:spend_spent_spent/components/leftColumn/SingleStat.dart';
import 'package:spend_spent_spent/components/switcher.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/models/leftColumnStats.dart';
import 'package:flutter/cupertino.dart';

class LeftColumn extends StatefulWidget {
  @override
  LeftColumnState createState() => LeftColumnState();
}

class LeftColumnState extends State<LeftColumn> with AfterLayoutMixin {
  int selected = 0;
  List<LeftColumnStats> stats = [];

  switchTab(int selected) {
    setState(() {
      this.selected = selected;
      getStats();
    });
  }

  Future<void> getStats() async {
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Switcher(
              selected: selected,
              labels: ['Monthly', 'Yearly'],
              onSelect: switchTab,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: stats.length,
              itemBuilder: (context, index) {
                return SingleStats(
                  key: Key(stats[index].category.id.toString()),
                  stats: stats[index],
                  monthly: selected == 0,
                );
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    getStats();
  }
}
