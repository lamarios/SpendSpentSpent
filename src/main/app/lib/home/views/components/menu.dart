import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:spend_spent_spent/home/views/components/animated_icon.dart';

const double _selectedContainerPosition = 185;
const double bottomPadding = 150;

class MainMenu extends StatelessWidget {
  final TabsRouter tabsRouter;
  final int selectedIndex;

  const MainMenu(
      {super.key, required this.tabsRouter, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    // var selectedColor = colors.primary;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
            child: Container(
          decoration: BoxDecoration(
              color: colors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(50),
              border: Border.fromBorderSide(
                  BorderSide(color: colors.surfaceContainerHighest, width: 1)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  spreadRadius: 1,
                  blurRadius: 30,
                  offset: Offset(0, 0), // changes position of shadow
                )
              ]),
        ).animate().scaleX(
                delay: Duration(milliseconds: 250),
                begin: 0,
                end: 1,
                alignment: Alignment.center,
                curve: Curves.easeInOutBack)),
        AnimatedPositioned(
          left: selectedIndex == 2 ? _selectedContainerPosition : 0,
          bottom: 0,
          top: 0,
          right: selectedIndex == 0 ? _selectedContainerPosition : 0,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOutQuint,
          child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: colors.inversePrimary),
          ).animate().fadeIn(delay: Duration(milliseconds: 500)).scaleXY(
              delay: Duration(milliseconds: 500),
              curve: Curves.easeInOutBack,
              alignment: Alignment.center,
              begin: 0.5,
              end: 1.2),
        ),
        Positioned.fill(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () => tabsRouter.setActiveIndex(0),
                child: AnimatedMenuIcon(
                  iconData: Icons.auto_graph,
                  selected: selectedIndex == 0,
                )
                    .animate()
                    .slideX(
                        delay: Duration(milliseconds: 250),
                        begin: 1.1,
                        end: 0,
                        curve: Curves.easeInOutBack)
                    .fadeIn(
                        delay: Duration(milliseconds: 250),
                        begin: 0,
                        duration: Duration(milliseconds: 250)),
              ),
              Gap(24),
              InkWell(
                onTap: () => tabsRouter.setActiveIndex(1),
                child: AnimatedMenuIcon(
                  iconData: Icons.square_rounded,
                  selected: selectedIndex == 1,
                )
                    .animate()
                    .fadeIn(duration: Duration(milliseconds: 250), begin: 0)
                    .scale(
                        duration: Duration(milliseconds: 250),
                        curve: Curves.easeInOutBack,
                        begin: Offset(0.7, 0.7),
                        end: Offset(1.2, 1.2))
                    .rotate(
                      begin: 0,
                      end: 0.02,
                      duration: Duration(milliseconds: 250),
                    )
                    .scale(
                        delay: Duration(milliseconds: 100),
                        end: Offset(0.8, 0.8),
                        begin: Offset(1.2, 1.2))
                    .rotate(
                      delay: Duration(milliseconds: 100),
                      begin: 0,
                      end: -0.02,
                      duration: Duration(milliseconds: 250),
                    ),
              ),
              Gap(24),
              InkWell(
                onTap: () => tabsRouter.setActiveIndex(2),
                child: AnimatedMenuIcon(
                  iconData: Icons.list,
                  selected: selectedIndex == 2,
                )
                    .animate()
                    .slideX(
                        delay: Duration(milliseconds: 250),
                        begin: -1.1,
                        end: 0,
                        curve: Curves.easeInOutBack)
                    .fadeIn(
                        delay: Duration(milliseconds: 250),
                        begin: 0,
                        duration: Duration(milliseconds: 250)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
