import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:spend_spent_spent/add_expense_dialog/models/category_guess_result.dart';
import 'package:spend_spent_spent/globals.dart';

part 'guess_category.freezed.dart';

part 'guess_category.g.dart';

class GuessCategoryCubit extends Cubit<GuessCategoryState> {
  final SharedMediaFile file;

  GuessCategoryCubit(super.initialState, this.file) {
    init(file);
  }

  Future<void> init(SharedMediaFile file) async {
    XFile xFile = XFile(file.path);

    final response = await service.guessCategory(xFile);

    if (!isClosed) {
      emit(
        state.copyWith(
          loading: false,
          results: response,
          selected: response.categories.firstOrNull,
        ),
      );
    }
  }

  void setSelected(String e) {
    emit(state.copyWith(selected: e));
  }
}

@freezed
sealed class GuessCategoryState with _$GuessCategoryState {
  const factory GuessCategoryState({
    @Default(true) bool loading,
    CategoryGuessResult? results,
    String? selected,
  }) = _GuessCategoryState;

  factory GuessCategoryState.fromJson(Map<String, Object?> json) =>
      _$GuessCategoryStateFromJson(json);
}
