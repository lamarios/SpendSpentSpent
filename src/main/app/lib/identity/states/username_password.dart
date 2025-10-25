import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/settings/models/oidc_config.dart';
import 'package:spend_spent_spent/settings/models/user.dart';
import 'package:spend_spent_spent/utils/jwt_utils.dart';
import 'package:spend_spent_spent/utils/models/token_type.dart';
import 'package:spend_spent_spent/utils/preferences.dart';
import 'package:spend_spent_spent/utils/reconnectable_web_socket.dart';

part 'username_password.freezed.dart';

class UsernamePasswordCubit extends Cubit<UsernamePasswordState> {
  UsernamePasswordCubit(super.initialState) {
    if (state.token != null) {
      var user = User.fromJson(decodeJwtPayload(state.token!)['user']);
      emit(state.copyWith(user: user));
    }
  }

  ReconnectableWebSocket? socket;

  Future<void> setToken(String server, String? token) async {
    if (token != null) {
      await Preferences.set(Preferences.TOKEN, token);
      await Preferences.set(
        Preferences.TOKEN_TYPE,
        TokenType.usernamePassword.name,
      );

      await service.setUrl(server);

      var user = User.fromJson(decodeJwtPayload(token)['user']);
      print('user');
      emit(state.copyWith(token: token, user: user));

      connectToSocket();
    } else {
      await logout();
    }
  }

  User? get currentUser => state.user;

  Future<void> connectToSocket() async {
    socket = ReconnectableWebSocket(uri: await service.getWebsocketUrl());
    socket?.connect();
  }

  Future<void> logout() async {
    await Preferences.remove(Preferences.TOKEN);
    await Preferences.remove(Preferences.TOKEN_TYPE);
    socket?.close();
    emit(state.copyWith(token: null, user: null));
  }
}

@freezed
sealed class UsernamePasswordState with _$UsernamePasswordState {
  const factory UsernamePasswordState({
    String? token,
    OidcConfig? oidcConfig,
    User? user,
  }) = _UsernamePasswordState;
}
