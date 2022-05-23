import 'package:flutter/material.dart';
import 'package:study_flutter_local_push_notifications/app/pages/notification/notification_page.dart';

class NotificationModule extends StatelessWidget {
  const NotificationModule({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final date = ModalRoute.of(context)?.settings.arguments as DateTime?;
    final dateText =
        date != null ? ' ${date.year}/${date.year}/${date.year}' : '';

    return NotificationPage(dateText: dateText);
  }
}
