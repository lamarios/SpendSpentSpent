import 'package:auto_route/annotations.dart';
import 'package:material_ui/material_ui.dart';
import 'package:spend_spent_spent/stats/views/components/stats.dart';

@RoutePage()
class YearlyStatsTab extends StatelessWidget {
  const YearlyStatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const StatsView(monthly: false);
  }
}
