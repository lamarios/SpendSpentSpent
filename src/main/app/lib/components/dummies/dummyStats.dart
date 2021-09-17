import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/models/appColors.dart';
import 'package:spend_spent_spent/utils/colorUtils.dart';

class DummyStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppColors colors = get(context);
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: FaIcon(
                  FontAwesomeIcons.chevronRight,
                  size: 10,
                  color: colors.dummy,
                ),
              ),
              Spacer(),
              Text(
                '0.00',
                style: TextStyle(color: colors.dummy),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Container(
              alignment: Alignment.topLeft,
              height: 10,
              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: colors.dummy),
            ),
          )
        ],
      ),
    );
  }
}
