import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notification_listener_service/notification_listener_service.dart';
import 'package:spend_spent_spent/add_expense_dialog/views/components/add_expense.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/notification_listener/foreground_task_handler.dart';
import 'package:spend_spent_spent/notification_listener/states/notification_tapped.dart';

@pragma('vm:entry-point')
void startCallback() {
  print('Starting task manager');
  FlutterForegroundTask.setTaskHandler(ForegroundTaskHandler());
}

class NotificationEventListener {
  static FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  NotificationEventListener();

  Future<void> init() async {
    flutterLocalNotificationsPlugin ??= await setupNotifications((details) {
      print('Notification tapped: ${details.payload}');
      final amount = double.tryParse(details.payload ?? '');
      if (amount != null) {
        getIt<NotificationTappedCubit>().setTapped(amount);
      }
    });

    // we ask fr notification permissions before anything else
    /// check if notification permession is enebaled
    bool status = await NotificationListenerService.isPermissionGranted();

    /// request notification permission
    /// it will open the notifications settings page and return `true` once the permission granted.
    if (!status) {
      status = await NotificationListenerService.requestPermission();
    }

    if (status) {
      FlutterForegroundTask.initCommunicationPort();
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        // Request permissions and initialize the service.
        await _requestPermissions();
        _initService();
        await _startService();
      });
    }
  }

  Future<void> stop() async {
    await FlutterForegroundTask.stopService();
  }

  Future<void> _requestPermissions() async {
    // Android 13+, you need to allow notification permission to display foreground service notification.
    //
    // iOS: If you need notification, ask for permission.
    final NotificationPermission notificationPermission =
        await FlutterForegroundTask.checkNotificationPermission();
    if (notificationPermission != NotificationPermission.granted) {
      await FlutterForegroundTask.requestNotificationPermission();
    }

    if (Platform.isAndroid) {
      // Android 12+, there are restrictions on starting a foreground service.
      //
      // To restart the service on device reboot or unexpected problem, you need to allow below permission.
      if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
        // This function requires `android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS` permission.
        await FlutterForegroundTask.requestIgnoreBatteryOptimization();
      }

      // Use this utility only if you provide services that require long-term survival,
      // such as exact alarm service, healthcare service, or Bluetooth communication.
      //
      // This utility requires the "android.permission.SCHEDULE_EXACT_ALARM" permission.
      // Using this permission may make app distribution difficult due to Google policy.
      if (!await FlutterForegroundTask.canScheduleExactAlarms) {
        // When you call this function, will be gone to the settings page.
        // So you need to explain to the user why set it.
        await FlutterForegroundTask.openAlarmsAndRemindersSettings();
      }
    }
  }

  void _initService() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'foreground_service',
        channelName: 'Notification listener foreground server',
        channelDescription:
            'This notification appears when SpendSpentSpent is monitoring your notifications to get new expenses.',
        onlyAlertOnce: true,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: false,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.nothing(),
        autoRunOnBoot: true,
        autoRunOnMyPackageReplaced: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

  static Future<FlutterLocalNotificationsPlugin> setupNotifications(
    Function(NotificationResponse)? onNotificationTap,
  ) async {
    print('Setting up notifications, callback ? ${onNotificationTap != null}');
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onNotificationTap,
    );

    return flutterLocalNotificationsPlugin;
  }

  Future<ServiceRequestResult> _startService() async {
    if (await FlutterForegroundTask.isRunningService) {
      await FlutterForegroundTask.stopService();
    }

    return FlutterForegroundTask.startService(
      // You can manually specify the foregroundServiceType for the service
      // to be started, as shown in the comment below.
      // serviceTypes: [
      //   ForegroundServiceTypes.dataSync,
      //   ForegroundServiceTypes.remoteMessaging,
      // ],
      notificationTitle: 'Monitoring notifications',
      notificationText:
          'SpendSpentSpent will watch for notifications and try to find expenses in it',
      // notificationIcon: NotificationIcon(metaDataName: "ic_launcher_foreground"),
      notificationInitialRoute: '/',
      serviceTypes: [ForegroundServiceTypes.specialUse],
      callback: startCallback,
    );
  }

  /*
  @pragma("vm:entry-point")
  static Future<void> _callback(NotificationEvent evt) async {
    if (evt.packageName == 'com.spendspentspent.app') {
      print('We don t listen to our own notifications, skipping');
      return;
    }

    flutterLocalNotificationsPlugin ??= await setupNotifications();
    print("send evt to ui: $evt");

    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'sss_suggested_expenses',
      'Suggested expenses',
      channelDescription: 'SpendSpentSpent will suggest expenses based on your other app notifications',
      ticker: 'ticker',
      actions: [
        AndroidNotificationAction('add-expense', 'Add expense', showsUserInterface: true),
        AndroidNotificationAction('discard', 'Discard', showsUserInterface: false, cancelNotification: true, semanticAction: SemanticAction.delete),
      ],
    );
    const NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin?.show(DateTime.now().secondsSinceEpoch, 'Add expense ?', 'Expense detected: 10.00', notificationDetails, payload: '10.00');

    final SendPort? send = IsolateNameServer.lookupPortByName("_listener_");
    if (send == null) print("can't find the sender");
    send?.send(evt);
  }
*/
}
