import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_notification_listener/flutter_notification_listener.dart';

@pragma(
  'vm:entry-point',
) // prevent dart from stripping out this function on release build in Flutter 3.x
class NotificationEventListener {
  ReceivePort port = ReceivePort();

  Future<void> init() async {
    await initPlatformState();
    startListening();
  }

  // define the handler for ui
  void onData(NotificationEvent event) {
    print(event.toString());
  }

  void startListening() async {
    print("start listening");
    /*
    setState(() {
      _loading = true;
    });
*/
    var hasPermission = (await NotificationsListener.hasPermission) ?? false;
    if (!hasPermission) {
      print("no permission, so open settings");
      NotificationsListener.openPermissionSettings();
      return;
    }

    var isRunning = (await NotificationsListener.isRunning) ?? false;

    if (isRunning) {
      await stopListening();
      isRunning = false;
    }

    if (!isRunning) {
      await NotificationsListener.startService(
        foreground: true,
        title: "Listener Running",
        description: "Welcome to having me",
      );
    }

    /*
    setState(() {
      started = true;
      _loading = false;
    });
*/
  }

  Future<void> stopListening() async {
    print("stop listening");

    /*
      setState(() {
        _loading = true;
      });
*/

    await NotificationsListener.stopService();

    /*
      setState(() {
        started = false;
        _loading = false;
      });
*/
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    NotificationsListener.initialize(callbackHandle: _callback);

    // this can fix restart<debug> can't handle error
    IsolateNameServer.removePortNameMapping("_listener_");
    IsolateNameServer.registerPortWithName(port.sendPort, "_listener_");
    port.listen((message) => onData(message));

    // don't use the default receivePort
    // NotificationsListener.receivePort.listen((evt) => onData(evt));

    var isRunning = (await NotificationsListener.isRunning) ?? false;
    print("""Service is ${!isRunning ? "not " : ""}already running""");

    /*
    setState(() {
      started = isRunning;
    });
*/
  }

  // we must use static method, to handle in background
  @pragma(
    'vm:entry-point',
  ) // prevent dart from stripping out this function on release build in Flutter 3.x
  static void _callback(NotificationEvent evt) {
    print("send evt to ui: $evt");
    final SendPort? send = IsolateNameServer.lookupPortByName("_listener_");
    if (send == null) print("can't find the sender");
    send?.send(evt);
  }
}
