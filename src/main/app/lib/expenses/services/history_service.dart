import 'package:http/http.dart' as http;
import 'package:spend_spent_spent/service.dart';

extension HistoryService on Service {
  Future<double> getMonthTotal(int month) async {
    final response = await http.get(await formatUrl('$API_URL/History/Monthly/total/$month'), headers: await headers);

    processResponse(response);
    return double.parse(response.body);
  }
}
