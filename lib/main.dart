import 'package:flutter/material.dart';
import 'package:study_flutter_local_push_notifications/app/app.dart';
import 'package:study_flutter_local_push_notifications/app/shared/notification_utils.dart';

void main() async {
  await NotificationsUtils.instance.initialize();
  await NotificationsUtils.instance.requestIosPermissions();
  runApp(const App());
}
