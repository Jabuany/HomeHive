import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotifications {
  static final FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(android: android);

    await plugin.initialize(settings);
  }

  static Future<void> show(String title, String body) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'chat_channel',
        'Chat Notifications',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );

    await plugin.show(0, title, body, details);
  }
}
