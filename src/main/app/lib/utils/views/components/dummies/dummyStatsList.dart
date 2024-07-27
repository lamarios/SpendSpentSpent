import 'package:flutter/cupertino.dart';
import 'package:spend_spent_spent/utils/views/components/dummies/DummyFade.dart';
import 'package:spend_spent_spent/utils/views/components/dummies/dummyStats.dart';

class DummyStatsList extends StatelessWidget {
  const DummyStatsList({super.key});

  @override
  Widget build(BuildContext context) {
    return DummyFade(
        child: ListView(
      children: const [
        DummyStats(),
        DummyStats(),
        DummyStats(),
        DummyStats(),
        DummyStats(),
        DummyStats(),
        DummyStats(),
        DummyStats(),
        DummyStats(),
        DummyStats(),
        DummyStats(),
        DummyStats(),
      ],
    ));
  }
}
