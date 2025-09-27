import 'dart:convert';

/// Decodes the payload of a JWT without verifying the signature.
/// Returns a Map of claims (or throws FormatException on invalid token).
Map<String, dynamic> decodeJwtPayload(String token) {
  final parts = token.split('.');
  if (parts.length != 3) throw FormatException('Invalid JWT: expected 3 parts');

  final payloadPart = parts[1];

  // Base64Url decode with padding fix
  String normalized = base64Url.normalize(payloadPart);
  final payloadBytes = base64Url.decode(normalized);
  final payloadString = utf8.decode(payloadBytes);

  final payloadMap = json.decode(payloadString);
  if (payloadMap is! Map<String, dynamic>) {
    throw FormatException('Invalid JWT payload format');
  }
  return payloadMap;
}
