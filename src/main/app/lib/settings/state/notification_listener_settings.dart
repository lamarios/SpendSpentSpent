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

class NotificationListenerSettingsCubit extends Cubit<NotificationListenerSettingsState> {
  final int pageSize = 50;

  NotificationListenerSettingsCubit(super.initialState) {
    init();
  }

  Future<void> init() async {
    bool watching = await Preferences.getBool(WATCH_NOTIFICATIONS);
    final ignoreList = await getIgnoreList();
    var history = await getHistory(state.page);
    emit(
      state.copyWith(enabled: watching, history: history, hasMore: pageSize == history.length, ignoreList: ignoreList),
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
    return contents.split('\n').map((line) => line.trim()).where((line) => line.isNotEmpty).toList();
  }

  Future<List<ParsedNotification>> getHistory(int page) async {
    emit(state.copyWith(loading: true));
    final dir = await getApplicationDocumentsDirectory();
    final historyDir = Directory('${dir.path}/notificationHistory');
    await historyDir.create(recursive: true);

    // Read all JSON files in the history directory and deserialize them into ParsedNotification objects.
    List<ParsedNotification> history = [];
    try {
      var files = await historyDir.list().where((entity) => entity is File).toList();

      files.sort((a, b) => b.path.compareTo(a.path));

      files = files.skip(page * pageSize).take(pageSize).toList();

      for (var fileEntity in files) {
        if (fileEntity is File) {
          final content = await fileEntity.readAsString();
          final jsonMap = jsonDecode(content);
          var parsedNotification = ParsedNotification.fromJson(jsonMap);

          if (parsedNotification.package != null) {
            final app = await FlutterDeviceApps.getApp(parsedNotification.package!, includeIcon: true);
            parsedNotification = parsedNotification.copyWith(appName: app?.appName, icon: app?.iconBytes);
          }

          history.add(parsedNotification);
        }
      }
    } catch (e) {
      print('Failed to read history: $e');
    }

    history.sort((a, b) => b.time.compareTo(a.time));
    emit(state.copyWith(loading: false));
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

  Future<void> loadMore() async {
    final page = state.page + 1;
    final history = await getHistory(page);

    final newHistory = List<ParsedNotification>.from(state.history);
    newHistory.addAll(history);

    emit(state.copyWith(page: page, history: newHistory, hasMore: history.length == pageSize));
  }
}

@freezed
sealed class NotificationListenerSettingsState with _$NotificationListenerSettingsState {
  const factory NotificationListenerSettingsState({
    @Default(false) bool enabled,
    @Default([]) List<ParsedNotification> history,
    @Default([]) List<String> ignoreList,
    @Default(0) int page,
    @Default(false) bool hasMore,
    @Default(true) bool loading,
  }) = _NotificationListenerSettingsState;
}
