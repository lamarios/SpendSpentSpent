import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/models/appColors.dart';
import 'package:spend_spent_spent/utils/colorUtils.dart';

class DummyExpense extends StatelessWidget {
  double width;
  DummyExpense(this.width);

  Random rand = Random();
  @override
  Widget build(BuildContext context) {
    AppColors colors = get(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          alignment: Alignment.topCenter,
          width: width,
          height: 35,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            color: colors.dummy,
          ),
        ),
      ],
    );
  }
}
