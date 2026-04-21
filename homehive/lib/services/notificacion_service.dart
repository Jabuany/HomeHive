import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:homehive/config/config.dart';
import 'package:homehive/services/users.dart';
import 'package:homehive/services/local_notifications.dart';

class NotificationService {
  static Future<void> initFCM() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    await messaging.requestPermission(alert: true, badge: true, sound: true);

    String? token = await messaging.getToken();
    print("FCM TOKEN: $token");

    // AQUÍ ES LO IMPORTANTE
    if (token != null) {
      await sendTokenToBackend(token);
    }

    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;

      if (notification != null) {
        LocalNotifications.show(
          notification.title ?? '',
          notification.body ?? '',
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("Abrió notificación");
    });
  }

  static Future<void> sendTokenToBackend(String token) async {
    final url = Uri.parse("${Config.baseApiUrl}/fcm-token");

    await http.post(
      url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer ${await UserService.obtenerToken()}",
      },
      body: jsonEncode({"fcm_token": token}),
    );
  }
}
