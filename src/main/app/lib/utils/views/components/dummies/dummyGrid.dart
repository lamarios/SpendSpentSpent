import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/utils/views/components/dummies/DummyFade.dart';
import 'package:spend_spent_spent/utils/views/components/dummies/dummyCategory.dart';

class DummyGrid extends StatelessWidget {
  const DummyGrid({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DummyFade(
      child: GridView.count(
        primary: false,
        padding: const EdgeInsets.only(top: 20),
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        crossAxisCount: columnCount(MediaQuery.of(context)),
        scrollDirection: Axis.vertical,
        children: const <Widget>[
          DummyCategory(),
          DummyCategory(),
          DummyCategory(),
          DummyCategory(),
          DummyCategory(),
          DummyCategory(),
          DummyCategory(),
          DummyCategory(),
          DummyCategory(),
          DummyCategory(),
          DummyCategory(),
        ],
      ),
    );
  }
}
