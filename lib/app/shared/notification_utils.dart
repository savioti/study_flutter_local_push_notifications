import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsUtils {
  NotificationsUtils._();

  static NotificationsUtils? _instance;
  static NotificationsUtils get instance =>
      _instance ??= NotificationsUtils._();

  static const String notificationKeyValue = 'notification';

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    '1', //Required for Android 8.0 or after
    'default', //Required for Android 8.0 or after
    channelDescription: 'default_channel', //Required for Android 8.0 or after
    importance: Importance.defaultImportance,
    priority: Priority.defaultPriority,
  );

  static const IOSNotificationDetails iOSPlatformChannelSpecifics =
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

  Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    NotificationDetails? platformSpecificDetails;

    if (Platform.isIOS) {
      platformSpecificDetails = const NotificationDetails(
        iOS: iOSPlatformChannelSpecifics,
      );
    }

    if (Platform.isAndroid) {
      platformSpecificDetails = const NotificationDetails(
        android: androidPlatformChannelSpecifics,
      );
    }

    if (platformSpecificDetails != null) {
      await flutterLocalNotificationsPlugin.show(
        1,
        title,
        body,
        platformSpecificDetails,
        payload: 'data',
      );
    }
  }

  Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    const initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    const initializationSettingsIos = IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    const initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIos);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: selectNotification,
    );
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

  Future selectNotification(String? payload) async {
    // Handle notification tapped logic here
  }
}
