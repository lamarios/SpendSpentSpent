import 'dart:convert';
import 'dart:io';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logging/logging.dart';
import 'package:notification_listener_service/notification_event.dart';
import 'package:notification_listener_service/notification_listener_service.dart';
import 'package:oidc/oidc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/notification_listener/models/parsed_notification.dart';
import 'package:spend_spent_spent/notification_listener/notification_event_listener.dart';

class ForegroundTaskHandler extends TaskHandler {
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  ForegroundTaskHandler() {}

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    print('Task handler destroyed');
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    // TODO: implement onRepeatEvent
    print('Event repeated');
  }

  // Find a numeric amount in the notification title and content.
  double? findAmountInNotification(ServiceNotificationEvent event) {
    final text = '${event.title ?? ''} ${event.content ?? ''}'.trim();
    print('finding amount in:\n$text');

    final regex = RegExp(r'\d+([,.]?\d{3})*[,.]\d{2}');
    final match = regex.firstMatch(text);
    if (match != null) {
      var amountStr = match.group(0);
      // Normalize decimal separator to dot
      amountStr = amountStr?.replaceAll(',', '.');
      return double.tryParse(amountStr ?? '');
    }
    return null;
  }

  Future<bool> isAppIgnored(String package) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/app-ignore-list');
    if (!await file.exists()) return false;
    final contents = await file.readAsString();
    return contents
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .where((element) => element == package)
        .isNotEmpty;
  }

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    print('Task handler started');

    /// stream the incoming notification events
    NotificationListenerService.notificationsStream.listen((event) async {
      flutterLocalNotificationsPlugin ??=
          await NotificationEventListener.setupNotifications(null);
      if (event.hasRemoved ?? false) {
        print('notification removed');
        return;
      }

      if (flutterLocalNotificationsPlugin != null) {
        if (event.packageName == 'com.spendspentspent.app') {
          print('We don t listen to our own notifications, skipping');
          return;
        }

        final amount = findAmountInNotification(event);

        final appIgnored = await isAppIgnored(event.packageName ?? '');

        if (appIgnored) {
          print('Package: ${event.packageName} is ignored, skipping');
        }

        if (amount != null && !appIgnored) {
          print('Found amount $amount, sending notification');
          const AndroidNotificationDetails
          androidNotificationDetails = AndroidNotificationDetails(
            'sss_suggested_expenses',
            'Suggested expenses',
            channelDescription:
                'SpendSpentSpent will suggest expenses based on your other app notifications',
            ticker: 'ticker',
            icon: "@mipmap/ic_launcher_foreground",
          );

          final parsed = ParsedNotification(
            package: event.packageName,
            amountFound: amount,
            title: event.title,
            content: event.content,
            time: DateTime.now().millisecondsSinceEpoch,
          );

          // Write parsed notification to a JSON file in the documents directory
          try {
            final jsonString = jsonEncode(parsed.toJson());
            final dir = await getApplicationDocumentsDirectory();
            final historyDir = Directory('${dir.path}/notificationHistory');
            await historyDir.create(recursive: true);
            final filePath =
                '${historyDir.path}/${DateTime.now().millisecondsSinceEpoch}.json';
            final file = File(filePath);
            await file.writeAsString(jsonString, mode: FileMode.writeOnly);
            print('saved file ${file.absolute.path}');
          } catch (e) {
            print('Failed to write parsed notification: $e');
          }

          const NotificationDetails notificationDetails = NotificationDetails(
            android: androidNotificationDetails,
          );
          await flutterLocalNotificationsPlugin?.show(
            DateTime.now().secondsSinceEpoch,
            'Add expense ?',
            'Expense detected: ${formatCurrency(amount)}, tap to add',
            notificationDetails,
            payload: '$amount',
          );
        } else {
          print('No amount found, skipping');
        }
      }
    });
  }
}
