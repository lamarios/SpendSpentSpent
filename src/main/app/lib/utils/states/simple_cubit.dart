import 'package:flutter_bloc/flutter_bloc.dart';

class SimpleCubitState<T> extends Cubit<T?> {
  final Function(SimpleCubitState<T> cubit)? init;
  final Function(SimpleCubitState<T> cubit)? onClose;

  SimpleCubitState(super.initialState, {this.init, this.onClose}) {
    init?.call(this);
  }

  @override
  Future<void> close() async {
    onClose?.call(this);
    super.close();
  }

  void setValue(T value) {
    emit(value);
  }
}
