import 'package:flutter_bloc/flutter_bloc.dart';

class LastExpenseCubit extends Cubit<int> {
  LastExpenseCubit(super.initialState);

  setLastExpense(int time) {
    emit(time);
  }
}
