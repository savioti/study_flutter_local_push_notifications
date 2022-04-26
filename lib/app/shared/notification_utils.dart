import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsUtils {
  NotificationsUtils._();

  static NotificationsUtils? _instance;
  static NotificationsUtils get instance =>
      _instance ??= NotificationsUtils._();

  static const String notificationKeyValue = 'notification';

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
}
