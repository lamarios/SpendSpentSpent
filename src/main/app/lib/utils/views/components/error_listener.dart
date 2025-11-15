import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_spent_spent/utils/views/components/error_dialog.dart';

import '../../models/with_error.dart';

class ErrorHandler<C extends Cubit<S>, S extends WithError> extends StatelessWidget {
  final bool showAsSnack;
  final Widget child;

  const ErrorHandler({super.key, this.showAsSnack = false, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<C, S>(
      listenWhen: (previous, current) => current.error != null && previous.error != current.error,
      listener: (context, state) {
        if (showAsSnack) {
          ErrorDialog.showSnack(context, error: state.error, trace: state.stackTrace);
        } else {
          ErrorDialog.show(context, error: state.error, trace: state.stackTrace);
        }
      },
      child: child,
    );
  }
}
