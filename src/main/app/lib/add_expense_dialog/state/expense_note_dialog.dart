import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logging/logging.dart';
import 'package:spend_spent_spent/globals.dart';

part 'expense_note_dialog.freezed.dart';

final _log = Logger('ExpenseNoteDialogCubit');

class ExpenseNoteDialogCubit extends Cubit<ExpenseNoteDialogState> {
  late final TextEditingController controller;

  ExpenseNoteDialogCubit(super.initialState) {
    controller = TextEditingController(text: state.note);
    controller.addListener(
      () => setNote(controller.text),
    );
  }

  selectSuggestion(String note) {
    emit(state.copyWith(note: note));
    controller.text = note;
  }

  setNote(String note) {
    emit(state.copyWith(note: note));
    if (note.isNotEmpty) {
      EasyDebounce.debounce(
        'note-suggestions',
        Duration(milliseconds: 200),
        () async {
          try {
            emit(state.copyWith(loading: true));
            final suggestions = await service.getNoteAutoComplete(note);
            List<String> suggestionList = List.from(suggestions.keys);
            suggestionList.sort((a, b) {
              return suggestions[b]!.compareTo(suggestions[a]!);
            });

            emit(state.copyWith(suggestions: suggestionList, loading: false));
          } catch (e) {
            _log.severe(e);
            emit(state.copyWith(loading: false));
          }
        },
      );
    } else {
      EasyDebounce.cancel('note-suggestions');
      emit(state.copyWith(suggestions: []));
    }
  }

  @override
  Future<void> close() {
    controller.dispose();
    return super.close();
  }
}

@freezed
sealed class ExpenseNoteDialogState with _$ExpenseNoteDialogState {
  const factory ExpenseNoteDialogState(
      {@Default(false) bool loading,
      @Default('') String note,
      @Default([]) List<String> suggestions}) = _ExpenseNoteDialogState;
}
