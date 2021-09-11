import 'package:spend_spent_spent/components/dummies/dummyCategory.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DummyGrid extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.only(top: 20),
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      crossAxisCount: 4,
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
    );
  }
}
