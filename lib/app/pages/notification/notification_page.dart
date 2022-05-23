import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  final String dateText;

  const NotificationPage({
    Key? key,
    required this.dateText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final date = ModalRoute.of(context)?.settings.arguments as DateTime?;
    final dateText =
        date != null ? ' ${date.year}/${date.month}/${date.day}' : '';

    return Scaffold(
      appBar: AppBar(title: Text('Notification$dateText')),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Text(
          'This is the content of a notification sent on $dateText.',
          style: const TextStyle(
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }
}
