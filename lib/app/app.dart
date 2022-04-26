import 'package:flutter/material.dart';
import 'package:study_flutter_local_push_notifications/app/pages/home/home_page.dart';
import 'package:study_flutter_local_push_notifications/app/pages/reminder/reminder_page.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.purple,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/reminder': (context) => const ReminderPage(),
      },
    );
  }
}
