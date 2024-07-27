import 'package:flutter_bloc/flutter_bloc.dart';

class MiddleColumnCubit extends Cubit<int> {
  MiddleColumnCubit(super.initialState);

  setTab(int i) {
    emit(i);
  }
}
