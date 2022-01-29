
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
class AwesomeNotificationService extends StatefulWidget {
  const AwesomeNotificationService({Key? key}) : super(key: key);

  static Future<void> createEducationFoodNotification(BuildContext context) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 5,
        channelKey: 'basic_channel',
        title:
        '${Emojis.building_school+ Emojis.office_pencil+Emojis.paper_books} '
            'New Universities added!!!',
        body: 'Don\'t miss your chance to find your dream university.',
        bigPicture: 'asset://assets/appicon.png',
        notificationLayout: NotificationLayout.BigPicture,
      ),
    );
  }

  @override
  _AwesomeNotificationServiceState createState() => _AwesomeNotificationServiceState();
}

class _AwesomeNotificationServiceState extends State<AwesomeNotificationService> {


  init(){
    AwesomeNotifications().initialize(
      'resource://drawable/appicon',
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic Notifications',
          defaultColor: Colors.teal,
          importance: NotificationImportance.High,
          channelShowBadge: true, channelDescription: '',
        ),
      ],
    );

  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
