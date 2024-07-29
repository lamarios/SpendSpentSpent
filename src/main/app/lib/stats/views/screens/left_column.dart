import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class LeftColumnTab extends StatelessWidget {
  const LeftColumnTab({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter.tabBar(
        physics: const NeverScrollableScrollPhysics(),
        builder: (context, child, tabController) {
          return Column(
            children: [
              TabBar(
                  dividerHeight: 0,
                  controller: tabController,
                  tabs: const [Tab(text: 'Monthly'), Tab(text: 'Yearly')]),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: child,
              ))
            ],
          );
        });
  }
}
