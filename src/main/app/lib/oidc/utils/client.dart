import 'package:oauth2_client/oauth2_client.dart';
import 'package:spend_spent_spent/settings/models/oidc_config.dart';

class OidcClient extends OAuth2Client {
  OidcClient(
      {required OidcConfig config,
      required String redirectUri,
      required String customUriScheme})
      : super(
          authorizeUrl: config.authorizationEndpoint,
          //Your service's authorization url
          tokenUrl: config.tokenUrl,
          //Your service access token url
          redirectUri: redirectUri,
          customUriScheme: customUriScheme,
        );
}
