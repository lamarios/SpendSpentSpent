import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:spend_spent_spent/expenses/state/diff_with_previous_month_settings.dart';

class DiffWithPreviousPeriodSettings extends StatelessWidget {
  const DiffWithPreviousPeriodSettings({super.key});

  static Future<void> showModalSheet(BuildContext context) async {
    await showModalBottomSheet(
        context: context,
        builder: (context) => Wrap(
              children: [
                SafeArea(bottom: true, child: DiffWithPreviousPeriodSettings()),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocProvider(
      create: (context) => DiffWithPreviousMonthSettingsCubit(
          DiffWithPreviousMonthSettingsState()),
      child: BlocBuilder<DiffWithPreviousMonthSettingsCubit,
          DiffWithPreviousMonthSettingsState>(builder: (context, state) {
        var cubit = context.read<DiffWithPreviousMonthSettingsCubit>();
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            children: [
              Text(
                'This shows the difference with the previous month in the same period. If we\'re the 15th of July, the difference will be between  from 1st to 15th of June and 1st to 15th of July. For past months, it will compare whole months.',
                style: textTheme.labelMedium,
              ),
              Gap(16),
              SwitchListTile(
                value: state.includeRecurringExpenses,
                title: Text('Include recurring expenses in comparison'),
                onChanged: (value) => cubit.setIncludeRecurringExpenses(value),
              )
            ],
          ),
        );
      }),
    );
  }
}
