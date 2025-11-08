import 'dart:convert';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_device_apps/flutter_device_apps.dart';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/notification_listener/models/parsed_notification.dart';
import 'package:spend_spent_spent/notification_listener/notification_event_listener.dart';
import 'package:spend_spent_spent/settings/views/screens/settings.dart';
import 'package:spend_spent_spent/utils/preferences.dart';

part 'notification_listener_settings.freezed.dart';

class NotificationListenerSettingsCubit
    extends Cubit<NotificationListenerSettingsState> {
  NotificationListenerSettingsCubit(super.initialState) {
    init();
  }

  Future<void> init() async {
    bool watching = await Preferences.getBool(WATCH_NOTIFICATIONS);
    final ignoreList = await getIgnoreList();
    emit(
      state.copyWith(
        enabled: watching,
        history: await getHistory(),
        ignoreList: ignoreList,
      ),
    );
  }

  Future<void> toggleIgnore(String package) async {
    final ignored = List<String>.from(state.ignoreList);

    if (ignored.contains(package)) {
      ignored.remove(package);
    } else {
      ignored.add(package);
    }

    // Write the updated ignore list to the app-ignore-list file,
    // replacing any existing content.
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/app-ignore-list');
    await file.writeAsString(ignored.join('\n'), mode: FileMode.writeOnly);

    emit(state.copyWith(ignoreList: ignored));
  }

  Future<List<String>> getIgnoreList() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/app-ignore-list');
    if (!await file.exists()) return [];
    final contents = await file.readAsString();
    return contents
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();
  }

  Future<List<ParsedNotification>> getHistory() async {
    final dir = await getApplicationDocumentsDirectory();
    final historyDir = Directory('${dir.path}/notificationHistory');
    await historyDir.create(recursive: true);

    // Read all JSON files in the history directory and deserialize them into ParsedNotification objects.
    List<ParsedNotification> history = [];
    try {
      final files = await historyDir
          .list()
          .where((entity) => entity is File)
          .toList();
      for (final fileEntity in files) {
        if (fileEntity is File) {
          final content = await fileEntity.readAsString();
          final jsonMap = jsonDecode(content);
          var parsedNotification = ParsedNotification.fromJson(jsonMap);

          if (parsedNotification.package != null) {
            final app = await FlutterDeviceApps.getApp(
              parsedNotification.package!,
              includeIcon: true,
            );
            parsedNotification = parsedNotification.copyWith(
              appName: app?.appName,
              icon: app?.iconBytes,
            );
          }

          history.add(parsedNotification);
        }
      }
    } catch (e) {
      print('Failed to read history: $e');
    }

    history.sort((a, b) => b.time.compareTo(a.time));

    return history;
  }

  Future<void> enable(bool value) async {
    await Preferences.setBool(WATCH_NOTIFICATIONS, value);

    final listener = getIt<NotificationEventListener>();
    if (value) {
      final result = await listener.init();
      emit(state.copyWith(enabled: result));
    } else {
      listener.stop();
      emit(state.copyWith(enabled: value));
    }
  }
}

@freezed
sealed class NotificationListenerSettingsState
    with _$NotificationListenerSettingsState {
  const factory NotificationListenerSettingsState({
    @Default(false) bool enabled,
    @Default([]) List<ParsedNotification> history,
    @Default([]) List<String> ignoreList,
  }) = _NotificationListenerSettingsState;
}
