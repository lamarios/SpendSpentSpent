import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/models/appColors.dart';
import 'package:spend_spent_spent/utils/colorUtils.dart';

class DummyCategory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppColors colors = get(context);
    return Container(decoration: BoxDecoration(color: colors.dummy, borderRadius: defaultBorder));
  }
}
