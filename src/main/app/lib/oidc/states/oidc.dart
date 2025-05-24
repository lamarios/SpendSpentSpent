import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logging/logging.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/oidc/utils/client.dart';
import 'package:spend_spent_spent/utils/models/token_type.dart';
import 'package:spend_spent_spent/utils/preferences.dart';

import '../../settings/models/oidc_config.dart';

part 'oidc.freezed.dart';
part 'oidc.g.dart';

final _log = Logger('OidcCubit');

class OidcCubit extends Cubit<OidcState> {
  OidcClient? client;

  OidcCubit(super.initialState);

  Future<bool> login() async {
    _log.fine("logging in via SSO, client Id ${state.clientId}");
    if (client != null) {
      final tokenResponse = await client!.getTokenWithAuthCodeFlow(
          clientId: state.clientId!, scopes: ['openid', 'profile', "email"]);

      // saving refresh token
      if (tokenResponse.refreshToken != null) {
        await Preferences.set(
            Preferences.REFRESH_TOKEN, tokenResponse.refreshToken!);
      }

      if (tokenResponse.accessToken != null) {
        await service.setToken(tokenResponse.accessToken!, TokenType.sso);
      }

      if (tokenResponse.respMap.containsKey("id_token")) {
        await Preferences.set(
            Preferences.ID_TOKEN, tokenResponse.respMap['id_token']);
      }

      return tokenResponse.isValid();
    }

    return false;
  }

  setupClient(OidcConfig config, String clientId) {
    _log.fine("Setting oidc client");
    emit(state.copyWith(oidcConfig: config, clientId: clientId));

    client = OidcClient(
        config: config,
        redirectUri: 'com.spendspentspent.app://oidcRedirect',
        customUriScheme: 'com.spendspentspent.app');
  }
}

@freezed
sealed class OidcState with _$OidcState {
  const factory OidcState({
    String? token,
    OidcConfig? oidcConfig,
    String? clientId,
  }) = _OidcState;

  factory OidcState.fromJson(Map<String, Object?> json) =>
      _$OidcStateFromJson(json);
}
