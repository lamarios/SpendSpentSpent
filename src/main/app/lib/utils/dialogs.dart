import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

void showAlertDialog(BuildContext context, String title, String text) {
  showPlatformDialog(
      context: context,
      builder: (BuildContext context) => PlatformAlertDialog(
            title: Text(title),
            content: Text(text),
            actions: <Widget>[
              PlatformDialogAction(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ));
}

void showPromptDialog(BuildContext context, String title, String label, TextEditingController controller, Function onOk, {int? maxLines}) {
  showPlatformDialog(
      context: context,
      builder: (BuildContext context) => PlatformAlertDialog(
            title: Text(title),
            content: PlatformTextField(
              controller: controller,
              maxLines: maxLines,
            ),
            actions: <Widget>[
              PlatformDialogAction(
                onPressed: () {
                  Navigator.pop(context, 'Cancel');
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              PlatformDialogAction(
                onPressed: () {
                  Navigator.pop(context, 'OK');
                  onOk();
                },
                child: const Text('OK'),
              ),
            ],
          ));
}

EdgeInsetsGeometry getInsetsForMaxSize(MediaQueryData data, {double? maxWidth, double? maxHeight}) {
  var horizontal = max<double>(0, (data.size.width - (maxWidth ?? data.size.width)) / 2);
  var vertical = max<double>(0, (data.size.height - (maxHeight ?? data.size.height)) / 2);
  return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
}
