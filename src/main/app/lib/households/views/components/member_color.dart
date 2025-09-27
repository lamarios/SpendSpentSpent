import 'package:flutter/material.dart';
import 'package:spend_spent_spent/households/models/household_enums.dart';
import 'package:spend_spent_spent/households/views/components/member_colored_container.dart';
import 'package:spend_spent_spent/utils/dialogs.dart';

class MemberColor extends StatelessWidget {
  final HouseholdColor value;
  final List<HouseholdColor> usedColors;

  const MemberColor({super.key, required this.value, required this.usedColors});

  static Future<HouseholdColor?> showSheet(
    BuildContext context, {
    required HouseholdColor value,
    required List<HouseholdColor> usedColors,
  }) => showMotorBottomSheet<HouseholdColor>(
    context: context,
    child: Wrap(
      children: [MemberColor(value: value, usedColors: usedColors)],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final availableColors = List.of(HouseholdColor.values);
    availableColors.removeWhere((color) => usedColors.contains(color));

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 16,
        children: [
          Text('Select color'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              InkWell(
                onTap: () => Navigator.of(context).pop(value),
                child: MemberColorContainer(color: value, selected: true),
              ),
              ...availableColors.map(
                (color) => InkWell(
                  onTap: () => Navigator.of(context).pop(color),
                  child: MemberColorContainer(color: color, selected: false),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
