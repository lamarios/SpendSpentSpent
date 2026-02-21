import 'dart:convert';
import 'dart:io';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker_platform_interface/src/platform_interface/image_picker_platform.dart';
import 'package:logging/logging.dart';
import 'package:nock/nock.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spend_spent_spent/categories/models/category.dart';
import 'package:spend_spent_spent/categories/state/categories.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/households/states/household.dart';
import 'package:spend_spent_spent/identity/states/username_password.dart';
import 'package:spend_spent_spent/notification_listener/notification_event_listener.dart';
import 'package:spend_spent_spent/notification_listener/states/notification_tapped.dart';
import 'package:spend_spent_spent/settings/models/user.dart';

import 'image_picker_mock.dart';
import 'mock_socket_username_password_cubit.dart';
import 'path_provider.dart';

final String validServerUrl = 'http://localhost:123';

final imagePickerMock = ImagePickerMock();

const testUser = User(
  id: 'cd2e4fe4-cd5f-476d-ac42-d031f6d813ea',
  email: 'test@test.com',
  firstName: 'test',
  lastName: 'test',
  isAdmin: true,
);


Future<void> setupTests({bool withConfig = true, bool loggedIn = false, List<Category>? categories}) async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });


  PathProviderPlatform.instance = FakePathProviderPlatform();

  ImagePickerPlatform.instance = imagePickerMock;
  await getIt.reset(dispose: true);

  PackageInfo.setMockInitialValues(
    appName: 'SpendSpentSpent',
    packageName: 'com.github.lamarios.spendspentspent',
    version: '0.0.0',
    buildNumber: '0',
    buildSignature: 'aaa',
  );

  _setupTimeZonePlugin();
  SharedPreferences.setMockInitialValues({});
  TestWidgetsFlutterBinding.ensureInitialized();
  var usernamePasswordCubit = MockSocketUsernamePasswordCubit(UsernamePasswordState());
  var householdCubit = HouseholdCubit(HouseholdState());

  getIt.registerSingleton<UsernamePasswordCubit>(usernamePasswordCubit);
  getIt.registerSingleton<BaseCacheManager>(CacheManager.custom(.new('cacheKey', stalePeriod: Duration(days: 50))));

  if (loggedIn) {
    // nock(validServerUrl).get('/Api/User/current').reply(200, jsonEncode(testUser.toJson()));
    final token = generateTestUserToken();

    await usernamePasswordCubit.setToken(validServerUrl, token);

    // nock.cleanAll();
  }

  nock(validServerUrl).get('/API/Category')
    ..reply(200, jsonEncode(categories ?? []))
    ..persist(true);

  nock(validServerUrl).get('/API/Expense/suggest')
    ..reply(200, '[]')
    ..query(catchAllQuery)
    ..persist(true);

  var categoriesCubit = CategoriesCubit(const CategoriesState());

  if (categories != null) {
    await categoriesCubit.getCategories(false);
  }

  getIt.registerSingleton<CategoriesCubit>(categoriesCubit);
  getIt.registerSingleton<HouseholdCubit>(householdCubit);

  getIt.registerSingleton<NotificationTappedCubit>(NotificationTappedCubit(null));
  var notificationEventListener = NotificationEventListener();
  getIt.registerSingleton<NotificationEventListener>(notificationEventListener);

  /*
  if (withConfig) {
    final config = Config.fromJson(jsonDecode(loadFixture('valid_server_config.json')));
  }
*/

}

String loadFixture(String name) {
  final file = File('test/fixtures/$name');
  return file.readAsStringSync();
}

String generateTestUserToken() {
  final jwt = JWT(
    // Payload
    {'user': testUser.toJson()},
    subject: 'test',
    issuer: 'newsku',
  );

  // Sign it (default with HS256 algorithm)
  return jwt.sign(SecretKey('secret passphrase'), expiresIn: Duration(days: 1));
}

extension SlideTo on WidgetTester {
  Future<void> slideToValue(Finder slider, double value, {double paddingOffset = 24.0}) async {
    final zeroPoint = this.getTopLeft(slider) + Offset(paddingOffset, this.getSize(slider).height / 2);
    final totalWidth = this.getSize(slider).width - (2 * paddingOffset);
    final calculatdOffset = value * (totalWidth / 100);
    await this.dragFrom(zeroPoint, Offset(calculatdOffset, 0));
  }
}

void _setupTimeZonePlugin() {
  const MethodChannel channel = MethodChannel('flutter_timezone');
  // Intercept the 'getLocalTimezone' call
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
    MethodCall methodCall,
  ) async {
    if (methodCall.method == 'getLocalTimezone') {
      return 'UTC'; // Return any valid timezone string for your test
    }
    return null;
  });
}

void setupImagePickerPlugin() {
  // Intercept the 'getLocalTimezone' call
}

bool catchAllQuery(Map<String, String> query) => true;
