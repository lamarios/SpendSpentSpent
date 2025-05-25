import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spend_spent_spent/utils/models/token_type.dart';
import 'package:spend_spent_spent/utils/preferences.dart';

part 'username_password.freezed.dart';

class UsernamePasswordCubit extends Cubit<UsernamePasswordState> {
  UsernamePasswordCubit(super.initialState);

  Future<void> setToken(String? token) async {
    if (token != null) {
      await Preferences.set(Preferences.TOKEN, token);
      await Preferences.set(
          Preferences.TOKEN_TYPE, TokenType.usernamePassword.name);

      emit(state.copyWith(token: token));
    } else {
      await logout();
    }
  }

  Future<void> logout() async {
    await Preferences.remove(Preferences.TOKEN);
    await Preferences.remove(Preferences.TOKEN_TYPE);
    emit(state.copyWith(token: null));
  }
}

@freezed
sealed class UsernamePasswordState with _$UsernamePasswordState {
  const factory UsernamePasswordState({String? token}) = _UsernamePasswordState;
}
