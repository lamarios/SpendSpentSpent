import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:spend_spent_spent/stats/views/components/stats.dart';

@RoutePage()
class YearlyStatsTab extends StatelessWidget {
  const YearlyStatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const StatsView(monthly: false);
  }
}
