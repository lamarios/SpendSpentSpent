import 'dart:async';

import 'package:flutter/material.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/identity/states/username_password.dart';

import '../../models/socket_message.dart';

class SssSocketListener extends StatefulWidget {
  final Widget child;
  final void Function(SssSocketMessage message) onFileChange;

  const SssSocketListener({
    super.key,
    required this.child,
    required this.onFileChange,
  });

  @override
  State<SssSocketListener> createState() => _SssSocketListenerState();
}

class _SssSocketListenerState extends State<SssSocketListener> {
  StreamSubscription<SssSocketMessage>? _sub;

  @override
  void initState() {
    super.initState();
    _sub = getIt<UsernamePasswordCubit>().socket?.stream.listen((data) {
      widget.onFileChange(data); // 👈 called every time there’s a new event
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
