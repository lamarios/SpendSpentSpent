import 'dart:convert';

import 'package:app/globals.dart';
import 'package:app/models/availableCategories.dart';
import 'package:app/models/category.dart';
import 'package:app/models/expense.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'models/searchCategories.dart';
import 'utils/preferences.dart';

const API_ROOT = "{apiUrl}";
const API_URL = API_ROOT + '/API';

const CATEGORY_ALL = API_URL + '/Category';
const CATEGORY_AVAILABLE = API_URL + '/Category/Available';
const CATEGORY_ADD = API_URL + '/Category';
const CATEGORY_GET = API_URL + '/Category/ById/{0}';
const CATEGORY_MERGE_CATEGORY = API_URL + '/Category/{0}';
const CATEGORY_UPDATE_ALL = API_URL + '/Category';
const CATEGORY_DELETE = API_URL + '/Category/{0}';
const CATEGORY_SEARCH = API_URL + '/Category/search-icon';
const CATEGORY_IS_USING_LEGACY = API_URL + "/Category/is-using-legacy";
const EXPENSE_ADD = API_URL + '/Expense';
const EXPENSE_BY_MONTH = API_URL + '/Expense/ByDay?month={0}';
const EXPENSE_GET_MONTHS = API_URL + '/Expense/GetMonths';
const EXPENSE_DELETE = API_URL + '/Expense/{0}';
const HISTORY_OVERALL_MONTH = API_URL + "/History/CurrentMonth";
const HISTORY_OVERALL_YEAR = API_URL + "/History/CurrentYear";
const HISTORY_YEARLY = API_URL + "/History/Yearly/{0}/{1}";
const HISTORY_MONTHLY = API_URL + "/History/Monthly/{0}/{1}";
const RECURRING_GET = API_URL + '/RecurringExpense';
const RECURRING_ADD = API_URL + '/RecurringExpense';
const RECURRING_DELETE = API_URL + '/RecurringExpense/{0}';
const SESSION_LOGIN = API_ROOT + '/Login';
const SESSION_SIGNUP = API_ROOT + '/SignUp';
const SESSION_RESET_PASSWORD_REQUEST = API_ROOT + "/ResetPasswordRequest";
const SESSION_RESET_PASSWORD = API_ROOT + "/ResetPassword";
const SETTINGS_UPDATE = API_URL + '/Settings';
const SETTINGS_ALL = API_URL + '/Settings';
const SETTINGS_GET = API_URL + '/Settings/{0}';
const MISC_VERSION = API_URL + '/Misc/version';
const MISC_GET_CONFIG = API_ROOT + "/config";
const USER_EDIT_PROFILE = API_URL + "/User";
const USER_GET = API_URL + "/User";
const USER_SET_ADMIN = API_URL + "/User/{0}/setAdmin/{1}";
const USER_UPDATE_PASSWORD = API_URL + "/User/{0}/setPassword";
const USER_ADD_USER = API_URL + "/User";
const USER_DELETE_USER = API_URL + "/User/{0}";
const CURRENCY_GET = API_URL + '/Currency/{0}/{1}';

const List<String> emptyList = [];

class Service {
  String url = "";

  Map<String, String> headers = Map();

  Service([url]) {
    headers.update("Content-Type", (value) => "application/json",
        ifAbsent: () => "application/json");
  }

  Future<void> setUrl(String url) async {
    await Preferences.set(Preferences.SERVER_URL, url);
    this.url = url;
  }

  Future<bool> needLogin() async {
    try {
      var token = await Preferences.get(Preferences.TOKEN);

      bool expired = JwtDecoder.isExpired(token);
      if (!expired) {
        await setToken(token);
      }
      return expired;
    } catch (e) {
      return true;
    }
  }

  Future<String> getUrl() async {
    if (url == '') {
      var server = await Preferences.get(Preferences.SERVER_URL, "");
      print('saved server $server');
      await setUrl(server);
    }

    return url;
  }

  Future<Uri> formatUrl(String url, [List<String> params = emptyList]) async {
    final serverUrl = await this.getUrl();
    url = url.replaceFirst("\{apiUrl\}", serverUrl);

    params.asMap().forEach((key, value) {
      url = url.replaceFirst('\{$key\}', value);
    });
    print("Calling $url");
    return Uri.parse(url);
  }

  Future<bool> setToken(String token) async {
    await Preferences.set(Preferences.TOKEN, token);
    token = token.replaceAll('"', '');
    token = "Bearer " + token;

    headers.update("Authorization", (value) => token, ifAbsent: () => token);

    return true;
  }

  /// Logs in to the server
  Future<bool> login(String username, String password) async {
    Map<String, String> creds = Map();
    creds.putIfAbsent("email", () => username);
    creds.putIfAbsent("password", () => password);

    final response = await http.post(await this.formatUrl(SESSION_LOGIN),
        body: jsonEncode(creds), headers: this.headers);

    if (response.body == '"Invalid username or password"') {
      throw Exception("Invalid email/password combination");
    } else if (response.statusCode == 200) {
      final tokenSet = await setToken(response.body);
      return tokenSet;
    } else {
      throw Exception("Error while connecting to server");
    }
  }

  Future<AvailableCategories> getAvailableCategories() async {
    final response =
        await http.get(await this.formatUrl(CATEGORY_AVAILABLE), headers: headers);

    processResponse(response);
    return AvailableCategories.fromJson(jsonDecode(response.body));
  }

  Future<AvailableCategories> searchAvailableCategories(String search) async {
    if (search == '') {
      return getAvailableCategories();
    }

    final response = await http.post(await this.formatUrl(CATEGORY_SEARCH),
        body: '"$search"', headers: headers);

    processResponse(response);
    return SearchCategories.fromJson(jsonDecode(response.body)).results;
  }

  Future<bool> addCategory(String category) async {
    Map<String, dynamic> data = Map();
    data.putIfAbsent('icon', () => category);
    data.putIfAbsent('order', () => 0);

    final response = await http.post(await this.formatUrl(CATEGORY_ADD),
        body: jsonEncode(data), headers: headers);

    processResponse(response);
    return true;
  }

  Future<Expense> addExpense(Expense expense) async {
    Map map = expense.toJson();

    final response = await http.post(await this.formatUrl(EXPENSE_ADD),
        body: jsonEncode(map), headers: headers);

    processResponse(response);
    return Expense.fromJson(jsonDecode(response.body));
  }

  Future<List<Category>> getCategories() async {
    final response =
        await http.get(await this.formatUrl(CATEGORY_ALL), headers: headers);

    processResponse(response);
    Iterable i = jsonDecode(response.body);
    return List<Category>.from(i.map((e) => Category.fromJson(e)));
  }

  Future<double> getCurrencyRate(String from, String to) async {
    final response = await http.get(await this.formatUrl(CURRENCY_GET, [from, to]),
        headers: headers);

    processResponse(response);
    return double.parse(response.body);
  }

  Future<void> logout() async {
    await Preferences.remove(Preferences.TOKEN);
    await Preferences.remove(Preferences.SERVER_URL);

    FBroadcast.instance().broadcast(BROADCAST_LOGGED_OUT);
  }

  void processResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        return;
      case 401:
        logout();
        throw Exception("Couldn't execute request ${response.body}");
      default:
        throw Exception("Couldn't execute request ${response.body}");
    }
  }
}
