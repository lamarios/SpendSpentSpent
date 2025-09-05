import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:spend_spent_spent/utils/views/components/switcher.dart';

@RoutePage()
class MiddleColumnTab extends StatelessWidget {
  const MiddleColumnTab({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter.tabBar(
      physics: const NeverScrollableScrollPhysics(),
      builder: (context, child, controller) {
        return Column(
          spacing: 16,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Switcher(
                labels: ['Normal', 'Recurring'],
                onSelect: (index) => controller.animateTo(index),
                selected: controller.index,
              ),
            ),
            /*
            TabBar(
              dividerHeight: 0,
              controller: controller,
              tabs: const [
                Tab(text: 'Normal'),
                Tab(text: 'Recurring'),
              ],
            ),
*/
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: child,
              ),
            ),
          ],
        );
      },
    );
  }
}
