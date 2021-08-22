import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecurringExpenseList extends StatefulWidget {
  @override
  RecurringExpenseListState createState() => RecurringExpenseListState();
}

class RecurringExpenseListState extends State<RecurringExpenseList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: Container(width: 400, height: 200, color: Colors.blue, child: Text('yo'))),
      ],
    );
  }
}
