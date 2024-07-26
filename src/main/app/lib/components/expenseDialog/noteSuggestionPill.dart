import 'dart:async';
import 'dart:math';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';

import '../../globals.dart';
import '../../models/appColors.dart';
import '../../utils/colorUtils.dart';

class NoteSuggestionPill extends StatefulWidget{
  String text;
  Function tapSuggestion;
  Key? key;
  NoteSuggestionPill({this.key, required this.text, required this.tapSuggestion});

  @override
  NoteSuggestionPillState createState() => NoteSuggestionPillState();
}

class NoteSuggestionPillState extends State<NoteSuggestionPill> with AfterLayoutMixin<NoteSuggestionPill>{
  Offset offset = Offset(1, 0);
  double opacity = 0;

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    Random rand = Random();
    Future.delayed(Duration(milliseconds: rand.nextInt(250)), () {
      setState(() {
        offset = const Offset(0, 0);
        opacity = 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: GestureDetector(
        onTap: () => widget.tapSuggestion(widget.text),
        child: AnimatedOpacity(
          duration: panelTransition,
          opacity: opacity,
          child: AnimatedSlide(
            duration: panelTransition,
            offset: offset,
            curve: Curves.easeInOutQuart,
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: defaultBorder,
                  color: colors.primaryContainer,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.text,
                    style: TextStyle(color: colors.onPrimaryContainer),
                  ),
                )),
          ),
        ),
      ),
    );
  }

}