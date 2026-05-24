import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:spend_spent_spent/service.dart';

extension CategoryService on Service {
  Future<Map<int, int>> countExpensesForAllCategories() async {
    final response = await http.get(await formatUrl('$API_URL/Category/expenses/count'), headers: await headers);

    processResponse(response);

    Map<String, dynamic> map = jsonDecode(response.body);

    return map.map((key, value) => MapEntry(int.parse(key), value));
  }
}
