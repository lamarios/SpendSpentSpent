import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/settings/models/oidc_config.dart';
import 'package:spend_spent_spent/utils/models/token_type.dart';
import 'package:spend_spent_spent/utils/preferences.dart';
import 'package:spend_spent_spent/utils/reconnectable_web_socket.dart';

part 'username_password.freezed.dart';

class UsernamePasswordCubit extends Cubit<UsernamePasswordState> {
  UsernamePasswordCubit(super.initialState);

  ReconnectableWebSocket? socket;

  Future<void> setToken(String? token) async {
    if (token != null) {
      await Preferences.set(Preferences.TOKEN, token);
      await Preferences.set(
        Preferences.TOKEN_TYPE,
        TokenType.usernamePassword.name,
      );

      emit(state.copyWith(token: token));

      connectToSocket();
    } else {
      await logout();
    }
  }

  Future<void> connectToSocket() async {
    socket = ReconnectableWebSocket(uri: await service.getWebsocketUrl());
    socket?.connect();
  }

  Future<void> logout() async {
    await Preferences.remove(Preferences.TOKEN);
    await Preferences.remove(Preferences.TOKEN_TYPE);
    socket?.close();
    emit(state.copyWith(token: null));
  }
}

@freezed
sealed class UsernamePasswordState with _$UsernamePasswordState {
  const factory UsernamePasswordState({String? token, OidcConfig? oidcConfig}) =
      _UsernamePasswordState;
}
