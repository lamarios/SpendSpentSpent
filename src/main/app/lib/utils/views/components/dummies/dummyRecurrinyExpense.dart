import 'package:flutter/material.dart';

class DummyRecurringExpense extends StatelessWidget {
  const DummyRecurringExpense({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        alignment: Alignment.center,
        height: 40,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(25)),
            color: colors.surfaceContainer),
      ),
    );
  }
}
