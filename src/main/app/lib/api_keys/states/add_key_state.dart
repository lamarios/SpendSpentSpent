import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spend_spent_spent/api_keys/views/components/add_api_key_dialog.dart';

part 'add_key_state.freezed.dart';

class AddKeyCubit extends Cubit<AddKeyState> {
  final TextEditingController controller = TextEditingController();

  AddKeyCubit(super.initialState) {
    controller.addListener(() => emit(state.copyWith(name: controller.value.text)));
  }

  void setExpiry(KeyExpiryPreset? preset) {
    if (preset != null) {
      emit(state.copyWith(expiry: preset));
    }
  }

  @override
  Future<void> close() {
    controller.dispose();
    return super.close();
  }
}

@freezed
sealed class AddKeyState with _$AddKeyState {
  const factory AddKeyState({@Default("") String name, @Default(KeyExpiryPreset.days7) KeyExpiryPreset expiry}) =
      _AddKeyState;
}
