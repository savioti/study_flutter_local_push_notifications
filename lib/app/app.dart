import 'package:flutter/material.dart';
import 'package:study_flutter_local_push_notifications/app/pages/home/home_page.dart';
import 'package:study_flutter_local_push_notifications/app/pages/notification/notification_module.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/notification': (context) => const NotificationModule(),
      },
    );
  }
}
