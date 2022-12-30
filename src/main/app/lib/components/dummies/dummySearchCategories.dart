import 'package:flutter/cupertino.dart';
import 'package:spend_spent_spent/components/dummies/DummyFade.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/models/appColors.dart';
import 'package:spend_spent_spent/utils/colorUtils.dart';

import '../../icons.dart';

class DummySearchCategories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> icons = ['restaurant', 'camera', 'gas', 'food', 'gift', 'games', 'internet', 'train', 'music', 'school'];
    AppColors colors = get(context);
    return Row(
      children: [
        Expanded(
          child: DummyFade(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                  children: icons.map((c) {
                return Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: getIcon(c, color: colors.dummy, size: 20),
                    ),
                  ),
                );
              }).toList()),
            ),
          ),
        )
      ],
    );
  }
}
