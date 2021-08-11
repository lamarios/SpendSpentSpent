import 'dart:convert';

import 'package:app/models/category.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

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

  Service([url = "https://exp.ftpix.com"]) {
    this.url = url;
    headers.update("Content-Type", (value) => "application/json",
        ifAbsent: () => "application/json");
  }

  void setUrl(String url) {
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

  Uri formatUrl(String url, [List<String> params = emptyList]) {
    url = url.replaceFirst("\{apiUrl\}", this.url);

    params.asMap().forEach((key, value) {
      url = url.replaceFirst('\{$key\}', value);
    });
    print("$url");
    return Uri.parse(url);
  }

  Future<bool> setToken(String token) async {
    Preferences.set(Preferences.TOKEN, token);
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

    final response = await http.post(this.formatUrl(SESSION_LOGIN),
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

  Future<List<Category>> getCategories() async {
    final response =
        await http.get(this.formatUrl(CATEGORY_ALL), headers: headers);
    if (response.statusCode == 200) {
      Iterable i = jsonDecode(response.body);
      return List<Category>.from(i.map((e) => Category.fromJson(e)));
    } else {
      throw Exception("Couldn't get categories ${response.body}");
    }
  }
}
