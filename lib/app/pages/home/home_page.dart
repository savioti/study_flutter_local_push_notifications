import 'package:flutter/material.dart';
import 'package:study_flutter_local_push_notifications/app/shared/notification_utils.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  void _showNotificationInTime(int seconds) async {
    await Future.delayed(Duration(seconds: seconds));
    NotificationsUtils.instance.showNotification(
      title: 'A local push notification',
      body: 'This notification was pushed 5 seconds after requested',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Container(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Show a notification now'),
              const SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: () => _showNotificationInTime(0),
                child: const Text('Schedule'),
              ),
              const SizedBox(height: 64.0),
              const Text('Show a notification in 5 seconds'),
              const SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: () => _showNotificationInTime(5),
                child: const Text('Schedule'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
