import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:spend_spent_spent/utils/views/components/switcher.dart';

@RoutePage()
class LeftColumnTab extends StatelessWidget {
  const LeftColumnTab({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter.tabBar(
      physics: const NeverScrollableScrollPhysics(),
      builder: (context, child, tabController) {
        return Column(
          spacing: 16,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Switcher(
                labels: ['Monthly', 'Yearly'],
                onSelect: (index) => tabController.animateTo(index),
                selected: tabController.index,
              ),
            ),
            /*
            TabBar(
              dividerHeight: 0,
              controller: tabController,
              tabs: const [
                Tab(text: 'Monthly'),
                Tab(text: 'Yearly'),
              ],
            ),
*/
            Expanded(
              child: Padding(padding: const EdgeInsets.only(top: 8), child: child),
            ),
          ],
        );
      },
    );
  }
}
