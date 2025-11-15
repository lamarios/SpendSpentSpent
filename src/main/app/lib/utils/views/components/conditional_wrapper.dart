import 'package:flutter/material.dart';

class ConditionalWrapper extends StatelessWidget {
  final bool wrapIf;
  final Widget Function(Widget child) wrapper;
  final Widget child;

  const ConditionalWrapper({super.key, required this.wrapIf, required this.wrapper, required this.child});

  @override
  Widget build(BuildContext context) {
    if (wrapIf) {
      return wrapper(child);
    } else {
      return child;
    }
  }
}
