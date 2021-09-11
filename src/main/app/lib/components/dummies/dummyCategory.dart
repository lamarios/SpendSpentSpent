import 'package:spend_spent_spent/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DummyCategory extends StatefulWidget {
  DummyCategory();

  @override
  DummyCategoryState createState() => DummyCategoryState();
}

class DummyCategoryState extends State<DummyCategory>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 2000),
        vsync: this,
        value: 0.4,
        lowerBound: 0.4,
        upperBound: 1,
        reverseDuration: const Duration(microseconds: 2000));
    _animation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
          decoration: BoxDecoration(
              color: Colors.grey[200], borderRadius: defaultBorder)),
    );
  }
}
