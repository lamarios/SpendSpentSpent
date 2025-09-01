import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_spent_spent/utils/states/simple_cubit.dart';

class SimpleCubit<T> extends StatelessWidget {
  final T? initialValue;
  final Widget Function(BuildContext context, T? state) builder;

  const SimpleCubit({super.key, this.initialValue, required this.builder});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SimpleCubitState<T?>(initialValue),
      child: BlocBuilder<SimpleCubitState<T?>, T?>(builder: builder),
    );
  }
}
