import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_spent_spent/utils/states/simple_cubit.dart';

class SimpleCubit<T> extends StatelessWidget {
  final T? initialValue;
  final Function(SimpleCubitState<T?> cubit)? init;
  final Function(SimpleCubitState<T?> cubit)? onClose;
  final Widget Function(BuildContext context, T? state) builder;

  const SimpleCubit({super.key, this.initialValue, required this.builder, this.init, this.onClose});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SimpleCubitState<T?>(initialValue, onClose: onClose, init: init),
      child: BlocBuilder<SimpleCubitState<T?>, T?>(builder: builder),
    );
  }
}
