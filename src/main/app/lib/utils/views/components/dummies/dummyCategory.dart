import 'package:flutter/material.dart';
import 'package:spend_spent_spent/globals.dart';

class DummyCategory extends StatelessWidget {
  const DummyCategory({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
        decoration: BoxDecoration(
            color: colors.surfaceContainer, borderRadius: defaultBorder));
  }
}
