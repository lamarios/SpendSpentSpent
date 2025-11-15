import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ExpenseSeparator extends StatelessWidget {
  final List<String> texts;

  const ExpenseSeparator({super.key, required this.texts});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final dividerColor = colors.onSurface.withValues(alpha: 0.5);
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Gap(16),
        Expanded(child: Divider(color: dividerColor)),
        Gap(16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          spacing: 4,
          children: texts.map((t) => Text(t, style: textTheme.bodySmall?.copyWith(color: dividerColor))).toList(),
        ),
      ],
    );
  }
}
