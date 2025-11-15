import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:spend_spent_spent/api_keys/models/api_key.dart';
import 'package:spend_spent_spent/service.dart';

extension ApiKeyService on Service {
  Future<ApiKey> createKey({required String name, int? expiryDate}) async {
    Map<String, dynamic> body = {'keyName': name};

    if (expiryDate != null) {
      body['expiryDate'] = expiryDate;
    }

    final response = await http.post(
      await formatUrl('$API_URL/ApiKey'),
      headers: await headers,
      body: jsonEncode(body),
    );

    processResponse(response);

    return ApiKey.fromJson(jsonDecode(response.body));
  }

  Future<List<ApiKey>> getKeys() async {
    final response = await http.get(await formatUrl('$API_URL/ApiKey'), headers: await headers);

    processResponse(response);

    Iterable i = jsonDecode(response.body);
    return i.map((e) => ApiKey.fromJson(e)).toList();
  }

  Future<bool> deleteKey(String keyId) async {
    final response = await http.delete(await formatUrl('$API_URL/ApiKey/$keyId'), headers: await headers);
    processResponse(response);
    return true;
  }
}
