import 'package:flutter/material.dart';
import 'package:spend_spent_spent/expenses/models/sss_file.dart';
import 'package:spend_spent_spent/utils/models/socket_message.dart';
import 'package:spend_spent_spent/utils/views/components/sss_socket_listener.dart';

class SssFileListener extends StatelessWidget {
  final Widget child;
  final Function(SssFile file) onFile;

  const SssFileListener({super.key, required this.child, required this.onFile});

  @override
  Widget build(BuildContext context) {
    return SssSocketListener(
      onFileChange: (message) {
        if (message.type == SssSocketMessageType.sssFile) {
          onFile(SssFile.fromJson(message.message));
        }
      },
      child: child,
    );
  }
}
