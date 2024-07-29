import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class MiddleColumnTab extends StatelessWidget {
  const MiddleColumnTab({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter.tabBar(
        physics: const NeverScrollableScrollPhysics(),
        builder: (context, child, controller) {
          return Column(
            children: [
              TabBar(
                  dividerHeight: 0,
                  controller: controller,
                  tabs: const [Tab(text: 'Normal'), Tab(text: ' Recurring')]),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: child,
              ))
            ],
          );
        });
  }
}
