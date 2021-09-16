import 'package:spend_spent_spent/components/dummies/DummyFade.dart';
import 'package:spend_spent_spent/components/dummies/dummyCategory.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spend_spent_spent/globals.dart';

class DummyGrid extends StatelessWidget {
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
        children: <Widget>[
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
