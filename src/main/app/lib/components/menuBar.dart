import 'package:after_layout/after_layout.dart';
import 'package:app/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MenuBar extends StatefulWidget {
  Function setPage;
  int page;

  MenuBar({required this.setPage, required this.page});

  @override
  MenuBarState createState() => MenuBarState();
}

class MenuBarState extends State<MenuBar> with TickerProviderStateMixin, AfterLayoutMixin<MenuBar> {
  late Animation<Color> animation0, animation1, animation2;
  late AnimationController controller0, controller1, controller2;

  @override
  void initState() {
    super.initState();
    controller0 = AnimationController(duration: panelTransition, vsync: this);
    animation0 = (ColorTween(begin: Colors.white, end: Colors.blue).animate(controller0) as Animation<Color>)
      ..addListener(() {
        setState(() {});
      });
    controller1 = AnimationController(duration: panelTransition, vsync: this);
    animation1 = (ColorTween(begin: Colors.white, end: Colors.blue).animate(controller1) as Animation<Color>)
      ..addListener(() {
        setState(() {});
      });
    controller2 = AnimationController(duration: panelTransition, vsync: this);
    animation2 = (ColorTween(begin: Colors.white, end: Colors.blue).animate(controller2) as Animation<Color>)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void didUpdateWidget(covariant MenuBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.page != widget.page) {
      setIconColors();
    }
  }

  void setIconColors() {
    switch (widget.page) {
      case 0:
        controller0.forward();
        controller1.reverse();
        controller2.reverse();
        break;
      case 1:
        controller0.reverse();
        controller1.forward();
        controller2.reverse();
        break;
      case 2:
        controller0.reverse();
        controller1.reverse();
        controller2.forward();
        break;
    }
  }

  void setSelected(int s) {
    widget.setPage(s);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 200,
      alignment: Alignment.center,
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          double? left = 0, right = 0;
          double oneThird =  constraints.maxWidth / 3;
          switch (widget.page) {
            case 0:
              left = 0;
              right = oneThird*2;
              break;
            case 1:
              left = oneThird;
              right = oneThird;
              break;
            case 2:
              left = oneThird*2;
              right = 0;
              break;
          }

          return Stack(
            children: [
              AnimatedPositioned(
                  right: right,
                  left: left,
                  top: 3.5,
                  bottom: 3.5,
                  curve: Curves.easeInOutQuart,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Container(
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(40)), boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 3,
                          offset: Offset(0, 2),
                        )
                      ]),
                      height: 1,
                      width: 1,
                    ),
                  ),
                  duration: panelTransition),
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: IconButton(
                          color: animation0.value,
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          icon: FaIcon(FontAwesomeIcons.chartBar),
                          onPressed: () {
                            setSelected(0);
                          }),
                    ),
                    Expanded(
                        child: Container(
                      child: IconButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          color: animation1.value,
                          icon: FaIcon(FontAwesomeIcons.squareFull),
                          onPressed: () {
                            setSelected(1);
                          }),
                    )),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: IconButton(
                          color: animation2.value,
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          icon: FaIcon(FontAwesomeIcons.bars),
                          onPressed: () {
                            setSelected(2);
                          }),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    setIconColors();
  }
}
