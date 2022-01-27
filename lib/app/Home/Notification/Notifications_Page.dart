import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

class NotificationPage extends StatelessWidget {
  NotificationPage({Key? key}) : super(key: key);

  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifiaction = BehaviorSubject<String?>();

  static Future _notificationDetails() async {
    return NotificationDetails(
      android: AndroidNotificationDetails('channel id', 'chnnel name',
          importance: Importance.max),
    );
  }

  static Future showNotifications({
    int id = 0,
    String? title="j",
    String? body="k",
    String? payload= "h",
  }) async =>
      _notifications.show(
        id,
        title,
        body,
        await _notificationDetails(),
        payload: payload,
      );

  static Future initState({bool initSchedule = false}) async {
    final android = AndroidInitializationSettings('app_icon');
    final settings = InitializationSettings(android: android);
    await _notifications.initialize(
      settings,
      onSelectNotification: (payload) async {
        onNotifiaction.add(payload);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
