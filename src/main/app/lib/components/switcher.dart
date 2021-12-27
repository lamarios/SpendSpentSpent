import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/models/appColors.dart';
import 'package:spend_spent_spent/utils/colorUtils.dart';

class Switcher extends StatefulWidget {
  List<String> labels;

  int selected;
  Function onSelect;

  Switcher({required this.labels, required this.selected, required this.onSelect});

  @override
  SwitcherState createState() => SwitcherState();
}

class SwitcherState extends State<Switcher> with TickerProviderStateMixin, AfterLayoutMixin {
  late List<AnimationController> controllers = [];
  late List<Animation<Color?>> animations = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant Switcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selected != widget.selected) {
      setColors();
    }
  }

  void setColors() {
    for (int i = 0; i < widget.labels.length; i++) {
      if (widget.selected == i) {
        controllers[i].forward();
      } else {
        controllers[i].reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    AppColors colors = get(context);
    // TODO: implement build
    return controllers.length == widget.labels.length
        ? Container(
            height: 30,
            alignment: Alignment.center,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final left = (constraints.maxWidth / widget.labels.length) * widget.selected;
                final right = constraints.maxWidth - ((constraints.maxWidth / widget.labels.length) * widget.selected) - constraints.maxWidth / widget.labels.length;
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
                          gradient: defaultGradient(context),
                        ),
                      ),
                    ),
                    Row(
                      children: widget.labels
                          .asMap()
                          .map((i, e) => MapEntry(
                              i,
                              GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () => widget.onSelect(i),
                                  child: Container(
                                      width: constraints.maxWidth / widget.labels.length,
                                      alignment: Alignment.center,
                                      child: Text(
                                        e,
                                        style: TextStyle(color: animations[i].value),
                                      )))))
                          .values
                          .toList(),
                    )
                  ],
                );
              },
            ),
          )
        : SizedBox.shrink();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    AppColors colors = get(context);

    late List<AnimationController> controllers = [];
    late List<Animation<Color?>> animations = [];
    for (int i = 0; i < widget.labels.length; i++) {
      final controller = AnimationController(duration: panelTransition, vsync: this);
      final animation = (ColorTween(begin: colors.main, end: colors.iconOnMain).animate(controller))
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
}
