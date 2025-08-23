import 'package:flutter/material.dart';

class KeyPad extends StatelessWidget {
  final Function(String number) addNumber;
  final Function() removeNumber;

  const KeyPad({
    super.key,
    required this.addNumber,
    required this.removeNumber,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    TextStyle keyPadStyle = TextStyle(fontSize: 25, color: colors.onSurface);

    return Column(
      children: [
        Row(
          children: [
            KeyPadButton(
              onPress: () => addNumber('1'),
              child: Text('1', textAlign: TextAlign.center, style: keyPadStyle),
            ),
            KeyPadButton(
              onPress: () => addNumber('2'),
              child: Text('2', textAlign: TextAlign.center, style: keyPadStyle),
            ),
            KeyPadButton(
              onPress: () => addNumber('3'),
              child: Text('3', textAlign: TextAlign.center, style: keyPadStyle),
            ),
          ],
        ),
        Row(
          children: [
            KeyPadButton(
              onPress: () => addNumber('4'),
              child: Text('4', textAlign: TextAlign.center, style: keyPadStyle),
            ),
            KeyPadButton(
              onPress: () => addNumber('5'),
              child: Text('5', textAlign: TextAlign.center, style: keyPadStyle),
            ),
            KeyPadButton(
              onPress: () => addNumber('6'),
              child: Text('6', textAlign: TextAlign.center, style: keyPadStyle),
            ),
          ],
        ),
        Row(
          children: [
            KeyPadButton(
              onPress: () => addNumber('7'),
              child: Text('7', textAlign: TextAlign.center, style: keyPadStyle),
            ),
            KeyPadButton(
              onPress: () => addNumber('8'),
              child: Text('8', textAlign: TextAlign.center, style: keyPadStyle),
            ),
            KeyPadButton(
              onPress: () => addNumber('9'),
              child: Text('9', textAlign: TextAlign.center, style: keyPadStyle),
            ),
          ],
        ),
        Row(
          children: [
            KeyPadButton(
              onPress: () => removeNumber(),
              child: Container(
                alignment: Alignment.center,
                child: Icon(
                  Icons.arrow_back,
                  size: 30,
                  color: colors.onSurface,
                ),
              ),
            ),
            KeyPadButton(
              onPress: () => addNumber('0'),
              child: Text('0', textAlign: TextAlign.center, style: keyPadStyle),
            ),
            KeyPadButton(
              onPress: () => addNumber('00'),
              child: Text(
                '00',
                textAlign: TextAlign.center,
                style: keyPadStyle,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class KeyPadButton extends StatelessWidget {
  final Function() onPress;
  final Widget child;

  const KeyPadButton({super.key, required this.onPress, required this.child});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPress,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
