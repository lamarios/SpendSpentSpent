import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/models/appColors.dart';
import 'package:spend_spent_spent/utils/colorUtils.dart';

class Switcher extends StatelessWidget {
  List<String> labels;

  int selected;
  Function onSelect;

  Switcher(
      {required this.labels, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      height: 30,
      alignment: Alignment.center,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final left = (constraints.maxWidth / labels.length) * selected;
          final right = constraints.maxWidth -
              ((constraints.maxWidth / labels.length) * selected) -
              constraints.maxWidth / labels.length;
          return Stack(
            children: [
              AnimatedPositioned(
                duration: panelTransition,
                left: left,
                right: right,
                top: 0,
                bottom: 0,
                curve: Curves.easeInOutQuart,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      color: colors.secondaryContainer),
                ),
              ),
              Row(
                children: labels
                    .asMap()
                    .map((i, e) => MapEntry(
                        i,
                        GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () => onSelect(i),
                            child: Container(
                                width: constraints.maxWidth / labels.length,
                                alignment: Alignment.center,
                                child: Text(
                                  e,
                                  style: TextStyle(
                                      color: selected == i
                                          ? colors.onSecondaryContainer
                                          : colors.primary),
                                )))))
                    .values
                    .toList(),
              )
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
