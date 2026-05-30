import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:spend_spent_spent/service.dart';

extension HistoryService on Service {
  Future<double> getMonthTotal(int month) async {
    final response = await http.get(await formatUrl('$API_URL/History/Monthly/total/$month'), headers: await headers);

    processResponse(response);
    return double.parse(response.body);
  }

  Future<Map<int, double>> getMonthTotalForYear(int year) async {
    final response = await http.get(await formatUrl('$API_URL/History/Year/$year/Monthly'), headers: await headers);

    processResponse(response);

    Map<String, dynamic> result = jsonDecode(response.body);

    return result.map((key, value) => MapEntry(int.parse(key), value as double));
  }
}
