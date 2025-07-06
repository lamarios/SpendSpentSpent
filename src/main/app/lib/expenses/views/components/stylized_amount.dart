import 'package:flutter/material.dart';

class StylizedAmount extends StatelessWidget {
  final double amount;
  final double? size;

  const StylizedAmount({super.key, required this.amount, this.size});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final int rootAmount = amount.floor();
    final int remainder = ((amount * 100) % 100).toInt();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$rootAmount',
          style: textTheme.bodyLarge
              ?.copyWith(color: colors.onSurface, fontSize: size, height: 0),
        ),
        Text('.$remainder',
            style: textTheme.bodyLarge?.copyWith(
                color: colors.onSurface.withValues(
                  alpha: 0.5,
                ),
                height: 1.5))
      ],
    );
  }
}
