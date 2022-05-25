import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationsUtils {
  NotificationsUtils._();

  static NotificationsUtils? _instance;
  static NotificationsUtils get instance =>
      _instance ??= NotificationsUtils._();

  static const String notificationKeyValue = 'notification';

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  NotificationAppLaunchDetails? _notificationAppLaunchDetails;

  bool? isInitialized = false;

  Future<void> initialize(
      {Future Function(String?)? selectNotification}) async {
    WidgetsFlutterBinding.ensureInitialized();

    await _initializeTimeZone();

    isInitialized = await flutterLocalNotificationsPlugin.initialize(
      _initializationSettings(),
      onSelectNotification: selectNotification,
    );

    _notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  }

  Future<void> requestIosPermissions() async {
    if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
  }

  Future<void> showNotification({
    required String title,
    required String body,
    required String payload,
    required Future Function(String?) onSelectNotification,
  }) async {
    await initialize(selectNotification: onSelectNotification);
    final platformSpecificDetails = _platformNotificationDetails();

    if (platformSpecificDetails != null) {
      await flutterLocalNotificationsPlugin.show(
        1,
        title,
        body,
        platformSpecificDetails,
        payload: payload,
      );
    }
  }

  Future<void> scheduleNotification({
    required String title,
    required String body,
    required String payload,
    required Future Function(String?) onSelectNotification,
    required DateTime date,
    required TimeOfDay time,
  }) async {
    final platformSpecificDetails = _platformNotificationDetails();

    if (platformSpecificDetails == null) {
      return;
    }

    await initialize(selectNotification: onSelectNotification);

    final dateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    final zonedDate = tz.TZDateTime.from(dateTime, tz.local);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      1,
      title,
      body,
      zonedDate,
      platformSpecificDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }

  String getPendingPayload() {
    if (isInitialized == null ||
        !isInitialized! ||
        _notificationAppLaunchDetails == null ||
        _notificationAppLaunchDetails!.payload == null) {
      return '';
    }

    return _notificationAppLaunchDetails!.payload!;
  }

  InitializationSettings _initializationSettings() {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    const initializationSettingsIos = IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIos,
    );

    return initializationSettings;
  }

  NotificationDetails? _platformNotificationDetails() {
    NotificationDetails? platformSpecificDetails;

    if (Platform.isIOS) {
      platformSpecificDetails = const NotificationDetails(
        iOS: _iOSPlatformChannelSpecifics,
      );
    }

    if (Platform.isAndroid) {
      platformSpecificDetails = const NotificationDetails(
        android: _androidPlatformChannelSpecifics,
      );
    }

    return platformSpecificDetails;
  }

  static const AndroidNotificationDetails _androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    '1', //Required for Android 8.0 or after
    'default', //Required for Android 8.0 or after
    channelDescription: 'default_channel', //Required for Android 8.0 or after
    importance: Importance.defaultImportance,
    priority: Priority.defaultPriority,
  );

  static const IOSNotificationDetails _iOSPlatformChannelSpecifics =
      IOSNotificationDetails(
    presentAlert:
        null, // Present an alert when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
    presentBadge:
        null, // Present the badge number when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
    presentSound:
        true, // Play a sound when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
    //sound: String?,  // Specifics the file path to play (only from iOS 10 onwards)
    //badgeNumber: int?, // The application's icon badge number
    //attachments: List<IOSNotificationAttachment>?, (only from iOS 10 onwards)
    //subtitle: String?, //Secondary description  (only from iOS 10 onwards)
    //threadIdentifier: String? /*(only from iOS 10 onwards)*/,
  );

  Future<void> _initializeTimeZone() async {
    if (isInitialized != null && isInitialized!) {
      return;
    }

    tz.initializeTimeZones();
    final locationName = await FlutterNativeTimezone.getLocalTimezone();
    final location = tz.getLocation(locationName);
    tz.setLocalLocation(location);
  }
}
