import 'package:flutter_bloc/flutter_bloc.dart';

class LastExpenseCubit extends Cubit<int> {
  LastExpenseCubit(super.initialState);

  void refresh() {
    emit(DateTime.now().millisecondsSinceEpoch);
  }
}
