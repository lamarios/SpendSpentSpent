import 'package:flutter/material.dart';
import 'package:spend_spent_spent/globals.dart';

class StylizedAmount extends StatelessWidget {
  final double amount;
  final double? size;

  const StylizedAmount({super.key, required this.amount, this.size});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final formattedAmount = formatCurrency(amount);

    final String rootAmount = formattedAmount.substring(0, formattedAmount.length - 3);
    final String remainder = formattedAmount.substring(formattedAmount.length - 3, formattedAmount.length);
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          rootAmount,
          style: textTheme.bodyLarge?.copyWith(color: colors.onSurface, fontSize: size, height: 0),
        ),
        Text(
          remainder,
          style: textTheme.bodyLarge?.copyWith(color: colors.onSurface.withValues(alpha: 0.5), height: 1.5),
        ),
      ],
    );
  }
}
