import 'package:flutter/material.dart';
import 'package:motor/motor.dart';
import 'package:spend_spent_spent/globals.dart';

class Switcher extends StatelessWidget {
  final List<String> labels;
  final double backgroundPadding;

  final int selected;
  final Function(int index) onSelect;

  const Switcher({
    super.key,
    this.backgroundPadding = 0,
    required this.labels,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      height: 30,
      alignment: Alignment.center,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final left = (constraints.maxWidth / labels.length) * selected;
          final right =
              constraints.maxWidth -
              ((constraints.maxWidth / labels.length) * selected) -
              constraints.maxWidth / labels.length;
          return Stack(
            children: [
              SingleMotionBuilder(
                motion: MaterialSpringMotion.expressiveSpatialDefault(),
                value: left,
                builder: (context, leftValue, child) {
                  return SingleMotionBuilder(
                    motion: MaterialSpringMotion.expressiveSpatialDefault(),
                    value: right,
                    builder: (context, rightValue, child) => Positioned(
                      left: leftValue,
                      right: rightValue,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: AnimatedContainer(
                          height: 30,
                          margin: EdgeInsets.symmetric(horizontal: backgroundPadding),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(25)),
                            color: colors.secondaryContainer,
                          ),
                          duration: animationDuration,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 36),
                            child: Text(labels[selected], style: TextStyle(color: colors.secondaryContainer)),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              Row(
                children: labels
                    .asMap()
                    .map(
                      (i, e) => MapEntry(
                        i,
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () => onSelect(i),
                          child: Container(
                            width: constraints.maxWidth / labels.length,
                            alignment: Alignment.center,
                            child: Text(
                              e,
                              style: TextStyle(color: selected == i ? colors.onSecondaryContainer : colors.primary),
                            ),
                          ),
                        ),
                      ),
                    )
                    .values
                    .toList(),
              ),
            ],
          );
        },
      ),
    );
  }

  /*
  @override
  void afterFirstLayout(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    late List<AnimationController> controllers = [];
    late List<Animation<Color?>> animations = [];
    for (int i = 0; i < labels.length; i++) {
      final controller = AnimationController(duration: panelTransition, vsync: this);
      final animation = (ColorTween(begin: colors.primaryContainer, end: colors.primaryContainer).animate(controller))
        ..addListener(() {
          if (this.mounted) {
            setState(() {});
          }
        });

      controllers.add(controller);
      animations.add(animation);
    }
    if (this.mounted) {
      setState(() {
        this.controllers = controllers;
        this.animations = animations;
      });
    }
    setColors();
  }
*/
}
