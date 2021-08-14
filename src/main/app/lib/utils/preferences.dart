import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static String SERVER_URL = 'server_url',
      TOKEN = 'token',
      CURRENT_PAGE = 'current_page',
      FROM_CURRENCY = "from_currency",
      TO_CURRENCY = "to_currency";

  static void set(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static Future<String> get(String key, [defaultValue = ""]) async {
    final prefs = await SharedPreferences.getInstance();
    var value = prefs.getString(key);
    return value == null ? defaultValue : value;
  }

  static void setInt(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  static Future<int> getInt(String key, [defaultValue = 0]) async {
    final prefs = await SharedPreferences.getInstance();
    var value = prefs.getInt(key);
    return value == null ? defaultValue : value;
  }
}
