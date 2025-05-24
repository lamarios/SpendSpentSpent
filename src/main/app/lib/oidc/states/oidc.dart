import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logging/logging.dart';
import 'package:oidc/oidc.dart';
import 'package:oidc_default_store/oidc_default_store.dart';
import 'package:spend_spent_spent/utils/models/token_type.dart';
import 'package:spend_spent_spent/utils/preferences.dart';

import '../../settings/models/oidc_config.dart';

part 'oidc.freezed.dart';

final _log = Logger('OidcCubit');

class OidcCubit extends Cubit<OidcState> {
  OidcUserManager? manager;

  OidcCubit(super.initialState);

  Future<bool> login() async {
    try {
      _log.fine("logging in via SSO, client Id ${state.oidcConfig?.clientId}");
      if (manager != null) {
        OidcProviderMetadata? override;

        // PKCE handling
        if (kIsWeb) {
          final sha256 =
              OidcConstants_AuthorizeRequest_CodeChallengeMethod.s256;
          override = manager?.discoveryDocument
              .copyWith(codeChallengeMethodsSupported: [sha256]);
        }

        final user = await manager!
            .loginAuthorizationCodeFlow(discoveryDocumentOverride: override);

        emit(state.copyWith(user: user));
        await Preferences.set(Preferences.TOKEN_TYPE, TokenType.sso.name);
        await Preferences.remove(Preferences.TOKEN);
        return user != null;
      }

      return false;
    } catch (e) {
      _log.severe(e);
      rethrow;
    }
  }

  String get token => '';

  logout() {
    manager?.forgetUser();
    emit(state.copyWith(user: null));
  }

  setupClient(OidcConfig config) async {
    try {
      _log.fine("Setting oidc client");
      emit(state.copyWith(oidcConfig: config));

      var basePort = Uri.base.port;

      String webUrl = kIsWeb
          ? '${Uri.base.scheme}://${Uri.base.host}${basePort != 80 && basePort != 443 ? ':$basePort' : ''}/redirect.html'
          : '';

      var redirectUri = kIsWeb
          // this url must be an actual html page.
          // see the file in /web/redirect.html for an example.
          //
          // for debugging in flutter, you must run this app with --web-port 22433
          ? Uri.parse(webUrl)
          : Uri.parse('com.spendspentspent.app:/oidcRedirect');
      manager = OidcUserManager.lazy(
          discoveryDocumentUri: OidcUtils.getOpenIdConfigWellKnownUri(
            Uri.parse(config.issuer),
          ),
          clientCredentials:
              OidcClientAuthentication.none(clientId: config.clientId),
          store: OidcDefaultStore(),
          settings: OidcUserManagerSettings(
              postLogoutRedirectUri: redirectUri,
              frontChannelLogoutUri: Uri(path: webUrl).replace(
                  queryParameters: {
                    ...redirectUri.queryParameters,
                    'requestType': 'front-channel-logout'
                  }),
              scope: ["openid", 'profile', 'email'],
              redirectUri: redirectUri,
              options: OidcPlatformSpecificOptions(
                  web: OidcPlatformSpecificOptions_Web(
                broadcastChannel: 'oidc_flutter_web/redirect',
              ))));

      await manager?.init();

      final currentUser = manager?.currentUser;
      _log.info("We have a user ? ${currentUser != null}");
      emit(state.copyWith(user: manager?.currentUser));
    } catch (e) {
      _log.severe(e);
      rethrow;
    }
  }
}

@freezed
sealed class OidcState with _$OidcState {
  const factory OidcState({
    String? token,
    OidcConfig? oidcConfig,
    OidcUser? user,
  }) = _OidcState;
}
