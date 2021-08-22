import 'package:after_layout/after_layout.dart';
import 'package:app/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  late List<Animation<Color>> animations = [];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < widget.labels.length; i++) {
      final controller = AnimationController(duration: panelTransition, vsync: this);
      final animation = (ColorTween(begin: Colors.blue, end: Colors.white).animate(controller) as Animation<Color>)
        ..addListener(() {
          setState(() {});
        });

      controllers.add(controller);
      animations.add(animation);
    }
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
    // TODO: implement build
    return Container(
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
                    gradient: LinearGradient(colors: [Colors.blueAccent, Colors.blue], stops: [0, 0.75], begin: Alignment.bottomCenter, end: Alignment.topRight),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      )
                    ],
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
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    setColors();
  }
}
