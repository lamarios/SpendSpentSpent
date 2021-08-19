import 'dart:math';

import 'package:flutter/material.dart';

void showAlertDialog(BuildContext context, String title, String text) {
  showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            title: Text(title),
            content: Text(text),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ));
}

void showPromptDialog(BuildContext context, String title, String label,
    TextEditingController controller, Function onOk) {
  showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            title: Text(title),
            content: TextField(
              controller: controller,
              decoration: InputDecoration(labelText: label),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context, 'OK');
                  onOk();
                },
                child: const Text('OK'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, 'Cancel');
                },
                child: const Text('Cancel'),
              ),
            ],
          ));
}

EdgeInsetsGeometry getInsetsForMaxSize(MediaQueryData data, double maxSize,
    {double? bottom}) {
  var width = max<double>(0, (data.size.width - maxSize) / 2);
  return EdgeInsets.only(left: width, right: width, bottom: bottom ?? 0);
}
