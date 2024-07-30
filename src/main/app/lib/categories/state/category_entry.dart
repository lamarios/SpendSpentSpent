import 'package:flutter_bloc/flutter_bloc.dart';

import '../../globals.dart';
import '../models/category.dart';

class CategoryEntryCubit extends Cubit<int?> {
  final Category category;

  CategoryEntryCubit(super.initialState, this.category) {
    getData();
  }

  getData() async {
    try {
      int expenses = await service.countCategoryExpenses(category.id!);
      emit(expenses);
    } catch (e) {
      emit(-1);
    }
  }
}
