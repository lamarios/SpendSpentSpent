import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:motor/motor.dart';
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

    return BlocBuilder<AppSettingsCubit, AppSettingsState>(
      builder: (context, state) {
        final isMaterialYou = !state.blackBackground && state.materialYou;

        final borderColor = isMaterialYou
            ? brighten(colors.surfaceContainerHighest, 0.1)
            : colors.surfaceContainerHighest;
        final backgroundColor = isMaterialYou
            ? brighten(colors.surfaceContainerHigh, 0.1)
            : colors.surfaceContainerHigh;

        return SequenceMotionBuilder(
          converter: SingleMotionConverter(),
          sequence: MotionSequence.stepsWithMotions([
            (0.0, Motion.none(Duration(milliseconds: 250))),
            (100.0, MaterialSpringMotion.expressiveSpatialDefault()),
          ]),
          builder: (context, value, _, child) {
            final double opacity = (value / 100).clamp(0, 1);
            return Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: Transform.scale(
                    scaleX: lerpDouble(0.0, 1, value / 100),
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
                      child: Transform.scale(
                        scale: lerpDouble(0, 1.2, value / 100),
                        child: Opacity(
                          opacity: opacity,
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
                Positioned.fill(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () => tabsRouter.setActiveIndex(0),
                        child: Transform.translate(
                          offset: Offset(lerpDouble(110, 0, value / 100)!, 0),
                          child: Opacity(
                            opacity: opacity,
                            child: AnimatedMenuIcon(
                              iconData: Icons.auto_graph,
                              selected: selectedIndex == 0,
                            ),
                          ),
                        ),
                      ),
                      Gap(24),
                      InkWell(
                        onTap: () => tabsRouter.setActiveIndex(1),
                        child: Transform.scale(
                          scale: value / 100,
                          child: AnimatedMenuIcon(
                            iconData: Icons.square_rounded,
                            selected: selectedIndex == 1,
                          ),
                        ),
                      ),
                      Gap(24),
                      InkWell(
                        onTap: () => tabsRouter.setActiveIndex(2),
                        child: Transform.translate(
                          offset: Offset(lerpDouble(-110, 0, value / 100)!, 0),
                          child: Opacity(
                            opacity: opacity,
                            child: AnimatedMenuIcon(
                              iconData: Icons.list,
                              selected: selectedIndex == 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
