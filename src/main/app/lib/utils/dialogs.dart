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

void showPromptDialog(BuildContext context, String title, String label, TextEditingController controller, Function onOk) {
  showPlatformDialog(
      context: context,
      builder: (BuildContext context) => PlatformAlertDialog(
            title: Text(title),
            content: PlatformTextField(
              controller: controller,
            ),
            actions: <Widget>[
              PlatformDialogAction(
                onPressed: () {
                  Navigator.pop(context, 'OK');
                  onOk();
                },
                child: const Text('OK'),
              ),
              PlatformDialogAction(
                onPressed: () {
                  Navigator.pop(context, 'Cancel');
                },
                child: const Text('Cancel'),
              ),
            ],
          ));
}

EdgeInsetsGeometry getInsetsForMaxSize(MediaQueryData data, double maxSize, {double? bottom}) {
  var width = max<double>(0, (data.size.width - maxSize) / 2);
  return EdgeInsets.only(left: width, right: width, bottom: bottom ?? 0);
}
