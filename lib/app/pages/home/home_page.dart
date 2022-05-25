import 'package:flutter/material.dart';
import 'package:study_flutter_local_push_notifications/app/shared/notification_utils.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future _onSelectNotification(String? payload) async {
      if (payload == null) {
        return;
      }

      final splitArguments = payload.split('?');

      if (splitArguments.length != 2) {
        return;
      }

      final isoFormatDate = splitArguments.last;
      final date = DateTime.tryParse(isoFormatDate);

      if (date == null) {
        return;
      }

      await Navigator.of(context).pushNamed(
        '/notification',
        arguments: date,
      );
    }

    void _showNotificationInTime(int seconds) async {
      await Future.delayed(Duration(seconds: seconds));
      final isoDate = DateTime.now().toIso8601String();

      NotificationsUtils.instance.showNotification(
        title: 'A local push notification',
        body: 'This is a local push notification example.',
        payload: '/notification?$isoDate',
        onSelectNotification: _onSelectNotification,
      );
    }

    void _scheduleNotification(DateTime date, TimeOfDay time) {
      final isoDate = DateTime.now().toIso8601String();

      NotificationsUtils.instance.scheduleNotification(
        title: 'A local push notification',
        body: 'This is a local push notification example.',
        payload: '/notification?$isoDate',
        onSelectNotification: _onSelectNotification,
        date: date,
        time: time,
      );
    }

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
                child: const Text('Show'),
              ),
              const SizedBox(height: 64.0),
              const Text('Show a notification in 5 seconds'),
              const SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: () => _showNotificationInTime(5),
                child: const Text('Schedule'),
              ),
              const SizedBox(height: 64.0),
              const Text('Schedule a notification'),
              const SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );

                  final selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );

                  if (selectedDate != null && selectedTime != null) {
                    _scheduleNotification(selectedDate, selectedTime);
                  }
                },
                child: const Text('Schedule'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
