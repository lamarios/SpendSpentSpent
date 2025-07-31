import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:spend_spent_spent/expenses/state/expense_list.dart';
import 'package:spend_spent_spent/expenses/views/components/diff_with_previous_period_settings.dart';

class DiffWithPreviousPeriod extends StatelessWidget {
  final double? diff;

  const DiffWithPreviousPeriod({super.key, this.diff});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    if (diff != null) {
      var finalDiff = (diff! < 1 ? 1 - diff! : diff! - 1) * 100;
      var color = diff! < 1
          ? Colors.green
          : diff! > 1
              ? Colors.red
              : null;
      return InkWell(
        onTap: () =>
            DiffWithPreviousPeriodSettings.showModalSheet(context).then(
          (value) {
            if (context.mounted) {
              context.read<ExpenseListCubit>().getDiff();
            }
          },
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (diff! < 1)
              Icon(
                Icons.trending_down,
                color: color,
              ),
            if (diff! > 1) Icon(Icons.trending_up, color: color),
            Gap(4),
            Text('${finalDiff.toStringAsFixed(2)}%',
                style: textTheme.headlineSmall?.copyWith(color: color)),
          ],
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }
}
