import 'package:flutter/material.dart';
import 'package:spend_spent_spent/icons.dart';
import 'package:spend_spent_spent/utils/views/components/dummies/DummyFade.dart';

class DummySearchCategories extends StatelessWidget {
  const DummySearchCategories({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> icons = [
      'restaurant',
      'camera',
      'gas',
      'food',
      'gift',
      'games',
      'internet',
      'train',
      'music',
      'school'
    ];
    final colors = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: DummyFade(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                  children: icons.map((c) {
                return Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child:
                          getIcon(c, color: colors.surfaceContainer, size: 20),
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
