import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:spend_spent_spent/categories/models/available_categories.dart';
import 'package:spend_spent_spent/categories/models/category.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/expenses/models/day_expense.dart';
import 'package:spend_spent_spent/expenses/models/expense.dart';
import 'package:spend_spent_spent/stats/models/graph_data_point.dart';
import 'package:spend_spent_spent/utils/models/paginatedResults.dart';
import 'package:spend_spent_spent/expenses/models/search_parameters.dart';
import 'package:spend_spent_spent/settings/models/settings.dart';
import 'package:spend_spent_spent/utils/models/token_type.dart';

import 'settings/models/config.dart';
import 'expenses/models/expense_limits.dart';
import 'expenses/models/search_categories.dart';
import 'settings/models/user.dart';
import 'recurring_expenses/models/recurring_expense.dart';
import 'stats/models/left_column_stats.dart';
import 'utils/models/exceptions/BackendNeedUpgradeException.dart';
import 'utils/models/exceptions/NeedUpgradeException.dart';
import 'utils/models/pagination.dart';
import 'utils/preferences.dart';

const API_ROOT = "{apiUrl}";
const API_URL = '$API_ROOT/API';

const CATEGORY_ALL = '$API_URL/Category';
const CATEGORY_AVAILABLE = '$API_URL/Category/Available';
const CATEGORY_ADD = '$API_URL/Category';
const CATEGORY_GET = '$API_URL/Category/ById/{0}';
const CATEGORY_MERGE_CATEGORY = '$API_URL/Category/{0}';
const CATEGORY_UPDATE_ALL = '$API_URL/Category';
const CATEGORY_DELETE = '$API_URL/Category/{0}';
const CATEGORY_SEARCH = '$API_URL/Category/search-icon';
const CATEGORY_IS_USING_LEGACY = "$API_URL/Category/is-using-legacy";
const CATEGORY_COUNT_EXPENSES = "$API_URL/Category/{0}/expenses/count";
const EXPENSE_ADD = '$API_URL/Expense';
const EXPENSE_BY_MONTH = '$API_URL/Expense/ByDay?month={0}';
const EXPENSE_GET_MONTHS = '$API_URL/Expense/GetMonths';
const EXPENSE_DELETE = '$API_URL/Expense/{0}';
const EXPENSE_GET_NOTE_SUGGESTIONS = '$API_URL/Expense/suggest-notes';
const EXPENSE_GET_NOTE_AUTOCOMPLETE = '$API_URL/Expense/notes-autocomplete';
const EXPENSE_GET_LIMITS = '$API_URL/Expense/limits';
const HISTORY_OVERALL_MONTH = "$API_URL/History/CurrentMonth";
const HISTORY_OVERALL_YEAR = "$API_URL/History/CurrentYear";
const HISTORY_YEARLY = "$API_URL/History/Yearly/{0}/{1}";
const HISTORY_MONTHLY = "$API_URL/History/Monthly/{0}/{1}";
const RECURRING_GET = '$API_URL/RecurringExpense';
const RECURRING_ADD = '$API_URL/RecurringExpense';
const RECURRING_DELETE = '$API_URL/RecurringExpense/{0}';
const RECURRING_UPDATE = '$API_URL/RecurringExpense/{0}';
const SESSION_LOGIN = '$API_ROOT/Login';
const SESSION_SIGNUP = '$API_ROOT/SignUp';
const SESSION_RESET_PASSWORD_REQUEST = "$API_ROOT/ResetPasswordRequest";
const SESSION_RESET_PASSWORD = "$API_ROOT/ResetPassword";
const SETTINGS_UPDATE = '$API_URL/Settings';
const SETTINGS_ALL = '$API_URL/Settings';
const SETTINGS_GET = '$API_URL/Settings/{0}';
const MISC_VERSION = '$API_URL/Misc/version';
const MISC_GET_CONFIG = "$API_ROOT/config";
const USER_EDIT_PROFILE = "$API_URL/User";
const USER_GET = "$API_URL/User?search={0}&page={1}&pageSize={2}";
const USER_CURRENT = "$API_URL/User/current";
const USER_SET_ADMIN = "$API_URL/User/{0}/setAdmin/{1}";
const USER_UPDATE_PASSWORD = "$API_URL/User/{0}/setPassword";
const USER_ADD_USER = "$API_URL/User";
const USER_DELETE_USER = "$API_URL/User/{0}";
const CURRENCY_GET = '$API_URL/Currency/{0}/{1}';
const CONFIG = '${API_ROOT}config';
const SEARCH = '$API_URL/Search';

const List<String> emptyList = [];

class Service {
  String url = "";

  String? version;

  Future<Map<String, String>> get headers async {
    var headers = {'Content-Type': 'application/json'};

    var token = await Preferences.get(Preferences.TOKEN);
    if (token != "") {
      token = token.replaceAll('"', '');
      token = "Bearer $token";
      headers['Authorization'] = token;
    }

    if (version != null) {
      headers['x-version'] = version!;
    }

    return headers;
  }

  int? appBuildVersion;

  Config? config;

  Service([url]);

  Future<void> setUrl(String url) async {
    await Preferences.set(Preferences.SERVER_URL, url);
    this.url = url;
  }

  Future<int> getVersion() async {
    // ugly but that should work
    if (appBuildVersion == null) {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      appBuildVersion = int.parse(packageInfo.buildNumber);
      version = appBuildVersion!.toString();
      return appBuildVersion!;
    } else {
      return appBuildVersion!;
    }
  }

  Future<bool> needLogin() async {
    try {
      var token = await Preferences.get(Preferences.TOKEN);

      bool expired = JwtDecoder.isExpired(token);
      if (!expired) {
        await setToken(token, TokenType.usernamePassword);
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
    final serverUrl = await getUrl();

    if (serverUrl.isEmpty) {
      logout();
      throw Exception("No server url, going back to login screen");
    }

    url = url.replaceFirst("{apiUrl}", serverUrl);

    params.asMap().forEach((key, value) {
      url = url.replaceFirst('{$key}', value);
    });

    print("Calling $url");
    return Uri.parse(url);
  }

  Future<bool> setToken(String token, TokenType type) async {
    await Preferences.set(Preferences.TOKEN, token);
    await Preferences.set(Preferences.TOKEN_TYPE, type.name);
    token = token.replaceAll('"', '');
    token = "Bearer $token";

    // headers.update("Authorization", (value) => token, ifAbsent: () => token);

    return true;
  }

  /// Logs in to the server
  Future<bool> login(String username, String password) async {
    Map<String, String> creds = {};
    creds.putIfAbsent("email", () => username);
    creds.putIfAbsent("password", () => password);

    final response = await http.post(await formatUrl(SESSION_LOGIN),
        body: jsonEncode(creds), headers: await headers);

    if (response.body == '"Invalid username or password"') {
      throw Exception("Invalid email/password combination");
    } else if (response.statusCode == 200) {
      final tokenSet =
          await setToken(response.body, TokenType.usernamePassword);
      await getServerConfig(url);
      return tokenSet;
    } else {
      throw Exception("Error while connecting to server");
    }
  }

  Future<AvailableCategories> getAvailableCategories() async {
    final response = await http.get(await formatUrl(CATEGORY_AVAILABLE),
        headers: await headers);

    processResponse(response);
    return AvailableCategories.fromJson(jsonDecode(response.body));
  }

  Future<AvailableCategories> searchAvailableCategories(String search) async {
    if (search == '') {
      return getAvailableCategories();
    }

    final response = await http.post(await formatUrl(CATEGORY_SEARCH),
        body: '"$search"', headers: await headers);

    processResponse(response);
    return SearchCategories.fromJson(jsonDecode(response.body)).results;
  }

  Future<bool> addCategory(String category) async {
    Map<String, dynamic> data = {};
    data.putIfAbsent('icon', () => category);
    data.putIfAbsent('order', () => 0);

    final response = await http.post(await formatUrl(CATEGORY_ADD),
        body: jsonEncode(data), headers: await headers);

    processResponse(response);
    return true;
  }

  Future<Expense> addExpense(Expense expense) async {
    Map map = expense.toJson();

    final response = await http.post(await formatUrl(EXPENSE_ADD),
        body: jsonEncode(map), headers: await headers);

    processResponse(response);
    return Expense.fromJson(jsonDecode(response.body));
  }

  Future<ExpenseLimits> getExpenseLimits() async {
    final response = await http.get(await formatUrl(EXPENSE_GET_LIMITS),
        headers: await headers);

    processResponse(response);
    return ExpenseLimits.fromJson(jsonDecode(response.body));
  }

  Future<Map<String, int>> getNoteSuggestions(Expense expense) async {
    Map map = expense.toJson();

    final response = await http.post(
        await formatUrl(EXPENSE_GET_NOTE_SUGGESTIONS),
        body: jsonEncode(map),
        headers: await headers);

    processResponse(response);
    Map<String, dynamic> result = jsonDecode(response.body);
    return result.map((key, value) {
      return MapEntry(key, value as int);
    });
  }

  Future<Map<String, int>> getNoteAutoComplete(String seed) async {
    final response = await http.post(
        await formatUrl(EXPENSE_GET_NOTE_AUTOCOMPLETE),
        body: seed,
        headers: await headers);

    processResponse(response);
    Map<String, dynamic> result = jsonDecode(response.body);
    return result.map((key, value) {
      return MapEntry(key, value as int);
    });
  }

  Future<List<Category>> getCategories() async {
    final response =
        await http.get(await formatUrl(CATEGORY_ALL), headers: await headers);

    processResponse(response);
    Iterable i = jsonDecode(response.body);
    return List<Category>.from(i.map((e) => Category.fromJson(e)));
  }

  Future<double> getCurrencyRate(String from, String to) async {
    final response = await http.get(await formatUrl(CURRENCY_GET, [from, to]),
        headers: await headers);

    processResponse(response);
    return double.parse(response.body);
  }

  Future<void> logout() async {
    await Preferences.remove(Preferences.TOKEN);
    config = null;
    url = "";
  }

  Future<List<RecurringExpense>> getRecurringExpenses() async {
    final response =
        await http.get(await formatUrl(RECURRING_GET), headers: await headers);

    processResponse(response);
    Iterable i = jsonDecode(response.body);
    return List<RecurringExpense>.from(
        i.map((e) => RecurringExpense.fromJson(e)));
  }

  Future<bool> updateRecurringExpense(RecurringExpense expense) async {
    final response = await http.post(
        await formatUrl(RECURRING_UPDATE, [expense.id.toString()]),
        headers: await headers,
        body: jsonEncode(expense));
    processResponse(response);
    return true;
  }

  Future<bool> deleteRecurringExpense(int id) async {
    final response = await http.delete(
        await formatUrl(RECURRING_DELETE, [id.toString()]),
        headers: await headers);
    processResponse(response);
    return true;
  }

  Future<bool> addRecurringExpense(RecurringExpense expense) async {
    final response = await http.post(await formatUrl(RECURRING_ADD),
        headers: await headers, body: jsonEncode(expense));

    processResponse(response);
    return true;
  }

  Future<List<String>> getExpensesMonths() async {
    final response = await http.get(await formatUrl(EXPENSE_GET_MONTHS),
        headers: await headers);
    processResponse(response);
    Iterable i = jsonDecode(response.body);
    return List<String>.from(i.map((e) => e as String));
  }

  Future<Map<String, DayExpense>> getMonthExpenses(String month) async {
    final response = await http.get(await formatUrl(EXPENSE_BY_MONTH, [month]),
        headers: await headers);
    processResponse(response);
    Map<String, dynamic> map = jsonDecode(response.body);

    return map.map((key, value) => MapEntry(key, DayExpense.fromJson(value)));
  }

  Future<bool> deleteExpense(int id) async {
    final response = await http.delete(
        await formatUrl(EXPENSE_DELETE, [id.toString()]),
        headers: await headers);
    processResponse(response);

    return true;
  }

  Future<List<LeftColumnStats>> getMonthStats() async {
    final response = await http.get(await formatUrl(HISTORY_OVERALL_MONTH),
        headers: await headers);

    processResponse(response);

    Iterable i = jsonDecode(response.body);
    return List<LeftColumnStats>.from(
        i.map((e) => LeftColumnStats.fromJson(e)));
  }

  Future<List<LeftColumnStats>> getYearStats() async {
    final response = await http.get(await formatUrl(HISTORY_OVERALL_YEAR),
        headers: await headers);

    processResponse(response);

    Iterable i = jsonDecode(response.body);
    return List<LeftColumnStats>.from(
        i.map((e) => LeftColumnStats.fromJson(e)));
  }

  Future<List<GraphDataPoint>> getMonthlyData(int categoryId, int count) async {
    final response = await http.get(
        await formatUrl(
            HISTORY_MONTHLY, [categoryId.toString(), count.toString()]),
        headers: await headers);

    processResponse(response);
    Iterable i = jsonDecode(response.body);
    return List<GraphDataPoint>.from(i.map((e) => GraphDataPoint.fromJson(e)));
  }

  Future<List<GraphDataPoint>> getYearlyData(int categoryId, int count) async {
    final response = await http.get(
        await formatUrl(
            HISTORY_YEARLY, [categoryId.toString(), count.toString()]),
        headers: await headers);

    processResponse(response);
    Iterable i = jsonDecode(response.body);
    return List<GraphDataPoint>.from(i.map((e) => GraphDataPoint.fromJson(e)));
  }

  Future<bool> saveAllCategories(List<Category> categories) async {
    final response = await http.put(await formatUrl(CATEGORY_UPDATE_ALL),
        headers: await headers, body: jsonEncode(categories));

    processResponse(response);
    return true;
  }

  Future<bool> deleteCategory(int id) async {
    print('id $id');
    final response = await http.delete(
        await formatUrl(CATEGORY_DELETE, [id.toString()]),
        headers: await headers);

    processResponse(response);
    return true;
  }

  Future<User> getCurrentUser() async {
    final response =
        await http.get(await formatUrl(USER_CURRENT), headers: await headers);

    processResponse(response);
    Map<String, dynamic> json = jsonDecode(response.body);
    return User.fromJson(json);
  }

  Future<bool> saveUser(User user) async {
    final response = await http.post(await formatUrl(USER_EDIT_PROFILE),
        body: jsonEncode(user), headers: await headers);

    processResponse(response);

    String newToken = response.body;

    if (await Preferences.get(Preferences.TOKEN_TYPE) ==
        TokenType.usernamePassword.name) {
      setToken(newToken, TokenType.usernamePassword);
    }

    return true;
  }

  Future<PaginatedResults<User>> getUsers(
      String? search, int page, int pageSize) async {
    final response = await http.get(
        await formatUrl(
            USER_GET, [search ?? '', page.toString(), pageSize.toString()]),
        headers: await headers);

    processResponse(response);
    print(response.body);
    Map<String, dynamic> json = jsonDecode(response.body);

    Pagination pagination = Pagination.fromJson(json['pagination']);

    Iterable i = json['data'];
    List<User> users = List<User>.from(i.map((e) => User.fromJson(e)));

    return PaginatedResults<User>(data: users, pagination: pagination);
  }

  Future<User> createUser(User user) async {
    final response = await http.put(await formatUrl(USER_ADD_USER),
        body: jsonEncode(user), headers: await headers);

    processResponse(response);

    return User.fromJson(jsonDecode(response.body));
  }

  Future<bool> deleteUser(String id) async {
    final response = await http.delete(await formatUrl(USER_DELETE_USER, [id]),
        headers: await headers);

    processResponse(response);

    return true;
  }

  Future<bool> setUserAdmin(String id, bool admin) async {
    final response = await http.get(
        await formatUrl(USER_SET_ADMIN, [id, admin.toString()]),
        headers: await headers);

    processResponse(response);
    return true;
  }

  Future<bool> setUserPassword(String id, String password) async {
    final response = await http.post(
        await formatUrl(USER_UPDATE_PASSWORD, [id]),
        body: '"$password"',
        headers: await headers);
    processResponse(response);
    return true;
  }

  Future<int> countCategoryExpenses(int id) async {
    final response = await http.get(
        await formatUrl(CATEGORY_COUNT_EXPENSES, [id.toString()]),
        headers: await headers);
    processResponse(response);

    return int.parse(response.body);
  }

  Future<List<Settings>> getAllSettings() async {
    final response =
        await http.get(await formatUrl(SETTINGS_ALL), headers: await headers);

    processResponse(response);
    Iterable i = jsonDecode(response.body);
    return List<Settings>.from(i.map((e) => Settings.fromJson(e)));
  }

  Future<bool> setSettings(Settings settings) async {
    final response = await http.post(await formatUrl(SETTINGS_UPDATE),
        body: jsonEncode(settings), headers: await headers);

    processResponse(response);

    await getServerConfig(url);

    return true;
  }

  Future<Config> getServerConfig(String url) async {
    if (!url.endsWith('/')) {
      url += '/';
    }

    url += 'config';

    final version = await getVersion();

    final response = await http
        .get(Uri.parse(url), headers: {'x-version': version.toString()});
    processResponse(response);

    var jsonDecode2 = jsonDecode(response.body);
    config = Config.fromJson(jsonDecode2);
    return config!;
  }

  Future<Config> getCurrentServerConfig() async {
    if (url.trim() != "") {
      return getServerConfig(url);
    }

    throw Exception("No server url set");
  }

  Future<bool> signUp(String url, User user) async {
    if (!url.endsWith('/')) {
      url += '/';
    }

    url += 'SignUp';
    int version = await getVersion();
    final response = await http.post(Uri.parse(url),
        body: jsonEncode(user),
        headers: {
          'Content-Type': 'application/json',
          'x-version': version.toString()
        });
    processResponse(response);
    return true;
  }

  Future<bool> resetPassword(String url, String email) async {
    if (!url.endsWith('/')) {
      url += '/';
    }

    url += 'ResetPasswordRequest';

    int version = await getVersion();
    final response = await http.post(Uri.parse(url),
        body: jsonEncode(email),
        headers: {
          'Content-Type': 'application/json',
          'x-version': version.toString()
        });
    processResponse(response);
    return true;
  }

  Future<SearchParameters> getSearchParameters(int? categoryId) async {
    String url =
        '$SEARCH${categoryId != null ? '?category_id=$categoryId' : ''}';
    print(url);
    final response =
        await http.get(await formatUrl(url), headers: await headers);
    processResponse(response);
    Map<String, dynamic> map = jsonDecode(response.body);

    return SearchParameters.fromJson(map);
  }

  Future<Map<String, DayExpense>> search(SearchParameters params) async {
    final response = await http.post(await formatUrl(SEARCH),
        body: jsonEncode(params), headers: await headers);
    processResponse(response);
    Map<String, dynamic> map = jsonDecode(response.body);

    return map.map((key, value) => MapEntry(key, DayExpense.fromJson(value)));
  }

  void processResponse(Response response) {
    if (response.headers.containsKey("x-version")) {
      String version = response.headers['x-version']!;
      try {
        int versionInt = int.parse(version);
        if (versionInt < MIN_BACKEND_VERSION) {
          print(
              'server version: $versionInt, required version: $MIN_BACKEND_VERSION');
          logout();
          throw BackendNeedUpgradeException();
        }
      } catch (e) {
        logout();
        throw BackendNeedUpgradeException();
      }
    } else {
      print('no server version');
    }

    switch (response.statusCode) {
      case 200:
        return;
      case 401:
        logout();
        throw Exception("Couldn't execute request ${response.body}");
      case 426:
        logout();
        throw NeedUpgradeException();
      default:
        throw Exception(
            "Couldn't execute request ${response.statusCode} -> ${response.body}");
    }
  }
}
