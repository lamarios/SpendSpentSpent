import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ErrorDialog extends StatelessWidget {
  final dynamic error;
  final StackTrace? trace;

  const ErrorDialog({super.key, required this.error, this.trace});

  static show(
    BuildContext context, {
    required dynamic error,
    StackTrace? trace,
  }) {
    showDialog(
      context: context,
      builder: (context) => ErrorDialog(error: error, trace: trace),
    );
  }

  static showSnack(
    BuildContext context, {
    required dynamic error,
    StackTrace? trace,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildError(context, error, trace),
        ),
      ),
    );
  }

  static List<Widget> _buildError(
    BuildContext context,
    dynamic error,
    StackTrace? trace,
  ) {
    // we really don't know what's going on
    return [Text(error.toString())];
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Dialog(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Error', style: textTheme.headlineSmall),
            const Gap(20),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: [..._buildError(context, error, trace)],
                ),
              ),
            ),
            const Gap(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('ok'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
