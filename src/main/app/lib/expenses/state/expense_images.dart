import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spend_spent_spent/expenses/models/sss_file.dart';

part 'expense_images.freezed.dart';

class ExpenseImagesCubit extends Cubit<ExpenseImagesState> {
  ExpenseImagesCubit(super.initialState);

  void updateImage(SssFile file) {
    final List<SssFile> files = List.from(state.files);
    final index = files.indexWhere((element) => element.id == file.id);
    files[index] = file;
    emit(state.copyWith(files: files));
  }
}

@freezed
sealed class ExpenseImagesState with _$ExpenseImagesState {
  const factory ExpenseImagesState({@Default([]) List<SssFile> files}) =
      _ExpenseImagesState;

  const ExpenseImagesState._();

  List<String> get possibleTags {
    return files
        .map((e) => e.aiTags)
        .expand((element) => element)
        .toSet()
        .toList();
  }
}
