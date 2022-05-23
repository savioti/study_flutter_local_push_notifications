import 'package:flutter/material.dart';

class ReminderPage extends StatelessWidget {
  const ReminderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notification')),
      body: SizedBox(
        child: Text('You selected a notification sent on DATE'),
      ),
    );
  }
}
