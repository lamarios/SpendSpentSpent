import 'dart:math';

import 'package:flutter/material.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:stupid_simple_sheet/stupid_simple_sheet.dart';

Future<void> showAlertDialog(
  BuildContext context,
  String title,
  String text,
) async {
  await showDialog(
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
    ),
  );
}

Future<void> okCancelDialog(
  BuildContext context, {
  required String title,
  required Widget content,
  required Function() onOk,
}) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text(title),
      content: content,
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, 'OK');
            onOk();
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

void showPromptDialog(
  BuildContext context,
  String title,
  String label,
  TextEditingController controller,
  Function() onOk, {
  int? maxLines,
  TextInputType? textInputType,
  String Function(String seed)? getAutoComplete,
}) {
  final colors = Theme.of(context).colorScheme;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: TextField(
          decoration: InputDecoration(label: Text(label)),
          controller: controller,
          maxLines: maxLines,
          keyboardType: textInputType ?? TextInputType.multiline,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'Cancel');
            },
            child: Text('Cancel', style: TextStyle(color: colors.secondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'OK');
              onOk();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

EdgeInsetsGeometry getInsetsForMaxSize(
  MediaQueryData data, {
  double? maxWidth,
  double? maxHeight,
}) {
  var horizontal = max<double>(
    0,
    (data.size.width - (maxWidth ?? data.size.width)) / 2,
  );
  var vertical = max<double>(
    0,
    (data.size.height - (maxHeight ?? data.size.height)) / 2,
  );
  return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
}

Future<T?> showMotorBottomSheet<T>({
  required BuildContext context,
  required Widget child,
}) async {
  final colors = Theme.of(context).colorScheme;

  return Navigator.of(context).push(
    StupidSimpleSheetRoute(
      motion: MaterialSpringMotion.expressiveSpatialDefault(),
      child: Builder(
        builder: (ctx) {
          return Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => Navigator.of(ctx).pop(null),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    constraints: BoxConstraints(maxWidth: TABLET),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                      child: Material(
                        color: colors.surfaceContainer,
                        child: SafeArea(top: false, bottom: true, child: child),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    ),
  );
}
