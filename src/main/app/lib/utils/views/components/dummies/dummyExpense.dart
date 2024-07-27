import 'package:flutter/material.dart';

class DummyExpense extends StatelessWidget {
  final double width;

  const DummyExpense({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          alignment: Alignment.topCenter,
          width: width,
          height: 35,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(25)),
            color: colors.surfaceContainer,
          ),
        ),
      ],
    );
  }
}
