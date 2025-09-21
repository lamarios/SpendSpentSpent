import 'package:flutter/material.dart';
import 'package:spend_spent_spent/households/models/household_enums.dart';

class MemberColorContainer extends StatelessWidget {
  final HouseholdColor color;
  final bool selected;

  const MemberColorContainer({
    super.key,
    required this.color,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    var hmColor = color.getColor(context);
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: hmColor.primaryContainer,
        border: Border.all(
          width: 1,
          color: selected ? hmColor.primary : hmColor.primaryContainer,
        ),
      ),
    );
  }
}
