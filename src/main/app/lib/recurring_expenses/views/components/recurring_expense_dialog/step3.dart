import 'package:flutter/material.dart';
import 'package:spend_spent_spent/add_expense_dialog/views/components/keypad.dart';

class Step3 extends StatelessWidget {
  final Function setAmount;
  final String amount;

  const Step3({super.key, required this.setAmount, required this.amount});

  String valueToStr(from) {
    String str = from.padLeft(3, '0');
    List<String> split = str.split('');
    split.insert(split.length - 2, '.');

    str = split.join('');

    return str;
  }

  void addNumber(String i) {
    String value = (amount + i).replaceFirst(RegExp(r'^0+'), '');
    setAmount(value);
  }

  void removeNumber() {
    if (amount.isNotEmpty) {
      String value = amount.substring(0, amount.length - 1);
      setAmount(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      children: [
        Row(children: [
          Expanded(
              child: Container(
                  height: 70,
                  alignment: Alignment.centerRight,
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: const BorderRadius.all(Radius.circular(25)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(valueToStr(amount),
                        style:
                            TextStyle(fontSize: 20, color: colors.onSurface)),
                  ))),
        ]),
        KeyPad(addNumber: addNumber, removeNumber: removeNumber)
      ],
    );
  }
}
