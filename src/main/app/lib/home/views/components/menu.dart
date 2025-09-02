import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:motor/motor.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/home/views/components/animated_icon.dart';
import 'package:spend_spent_spent/settings/state/app_settings.dart';
import 'package:spend_spent_spent/utils/colorUtils.dart';

const double _selectedContainerPosition = 185;
const double bottomPadding = 150;

class MainMenu extends StatelessWidget {
  final TabsRouter tabsRouter;
  final int selectedIndex;

  const MainMenu({
    super.key,
    required this.tabsRouter,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    // var selectedColor = colors.primary;
    return BlocBuilder<AppSettingsCubit, AppSettingsState>(
      builder: (context, state) {
        final isMaterialYou = !state.blackBackground && state.materialYou;

        final borderColor = isMaterialYou
            ? brighten(colors.surfaceContainerHighest, 0.1)
            : colors.surfaceContainerHighest;
        final backgroundColor = isMaterialYou
            ? brighten(colors.surfaceContainerHigh, 0.1)
            : colors.surfaceContainerHigh;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: SingleMotionBuilder(
                motion: MaterialSpringMotion.expressiveSpatialDefault(),
                value: 100,
                from: 10,
                builder: (context, value, child) =>
                    Transform.scale(scaleX: value / 100, child: child),
                child: Container(
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.fromBorderSide(
                      BorderSide(color: borderColor, width: 1),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.25),
                        spreadRadius: 1,
                        blurRadius: 30,
                        offset: Offset(0, 0), // changes position of shadow
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SingleMotionBuilder(
              motion: MaterialSpringMotion.expressiveSpatialDefault(),
              value: selectedIndex == 0 ? _selectedContainerPosition : 0,
              builder: (context, right, child) => SingleMotionBuilder(
                value: selectedIndex == 2 ? _selectedContainerPosition : 0,
                motion: MaterialSpringMotion.expressiveSpatialDefault(),
                builder: (context, left, child2) => Positioned(
                  left: left,
                  bottom: 0,
                  top: 0,
                  right: right,
                  child: SingleMotionBuilder(
                    motion: MaterialSpringMotion.expressiveSpatialDefault(),
                    value: 120,
                    from: 0,
                    builder: (context, value, child1) => Transform.scale(
                      scale: max(0, value / 100),
                      child: Opacity(
                        opacity: min(1, max(0, value / 100)),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colors.inversePrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () => tabsRouter.setActiveIndex(0),
                    child: SingleMotionBuilder(
                      motion: MaterialSpringMotion.expressiveSpatialDefault(),
                      value: 0,
                      from: 110,
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(value, 0),
                          child: child,
                        );
                      },
                      child: AnimatedMenuIcon(
                        iconData: Icons.auto_graph,
                        selected: selectedIndex == 0,
                      ).animate().fadeIn(begin: 0, duration: animationDuration),
                    ),
                  ),
                  Gap(24),
                  InkWell(
                    onTap: () => tabsRouter.setActiveIndex(1),
                    child: SingleMotionBuilder(
                      motion: MaterialSpringMotion.expressiveSpatialDefault(),
                      value: 1,
                      from: 0,
                      builder: (context, value, child) {
                        return Transform.scale(scale: value, child: child);
                      },
                      child: AnimatedMenuIcon(
                        iconData: Icons.square_rounded,
                        selected: selectedIndex == 1,
                      ),
                    ),
                  ),
                  Gap(24),
                  InkWell(
                    onTap: () => tabsRouter.setActiveIndex(2),
                    child: SingleMotionBuilder(
                      motion: MaterialSpringMotion.expressiveSpatialDefault(),
                      value: 0,
                      from: -110,
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(value, 0),
                          child: child,
                        );
                      },
                      child: AnimatedMenuIcon(
                        iconData: Icons.list,
                        selected: selectedIndex == 2,
                      ).animate().fadeIn(duration: animationDuration),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
