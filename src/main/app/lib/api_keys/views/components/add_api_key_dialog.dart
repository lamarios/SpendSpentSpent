import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:spend_spent_spent/api_keys/models/api_key.dart';
import 'package:spend_spent_spent/api_keys/states/add_key_state.dart';
import 'package:spend_spent_spent/utils/dialogs.dart';

enum KeyExpiryPreset {
  days7(7, '7 days'),
  days30(30, '30 days'),
  days60(60, '60 days'),
  days90(90, '90 days'),
  never(null, 'Never');

  final int? days;
  final String label;

  const KeyExpiryPreset(this.days, this.label);
}

class AddApiKeyDialog extends StatelessWidget {
  const AddApiKeyDialog({super.key});

  static Future<AddKeyState?> show(BuildContext context) {
    return showMotorBottomSheet<AddKeyState>(
      context: context,
      child: Wrap(children: [AddApiKeyDialog()]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddKeyCubit(AddKeyState()),
      child: BlocBuilder<AddKeyCubit, AddKeyState>(
        builder: (context, state) {
          final cubit = context.read<AddKeyCubit>();
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Key name'),
                Gap(4),
                TextFormField(controller: cubit.controller),
                Gap(16),
                Text('Expiry'),
                Gap(4),
                DropdownMenu<KeyExpiryPreset>(
                  initialSelection: state.expiry,
                  onSelected: (value) => cubit.setExpiry(value),
                  dropdownMenuEntries: KeyExpiryPreset.values
                      .map(
                        (e) => DropdownMenuEntry<KeyExpiryPreset>(
                          value: e,
                          label: e != KeyExpiryPreset.never
                              ? '${e.label} (${DateFormat.yMMMd().format(DateTime.now().add(Duration(days: e.days!)))})'
                              : '${e.label} (Not recommended)',
                        ),
                      )
                      .toList(),
                ),
                Gap(16),
                FilledButton.tonalIcon(
                  onPressed: state.name.isEmpty
                      ? null
                      : () {
                          Navigator.of(context).pop(state);
                        },
                  icon: Icon(Icons.add),
                  label: Text('Add'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
