import 'package:flutter_bloc/flutter_bloc.dart';

class SimpleCubitState<T> extends Cubit<T?> {
  SimpleCubitState(super.initialState);

  setValue(T value) {
    emit(value);
  }
}
