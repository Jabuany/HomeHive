import 'dart:convert';
import 'package:homehive/config/config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class UserService {
  static const String baseUrl = Config.baseApiUrl;

  static Map<String, dynamic>? currentUser;
  static String? token;

  //  FCM TOKEN
  static Future<String?> obtenerFCMToken() async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    print("FCM TOKEN: $fcmToken");
    return fcmToken;
  }

  static Future<void> enviarTokenFCM(String fcmToken) async {
    String tokenActual = await obtenerToken();

    final url = Uri.parse("$baseUrl/fcm-token");

    final response = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $tokenActual",
      },
      body: jsonEncode({"fcm_token": fcmToken}),
    );

    print("FCM STATUS: ${response.statusCode}");
    print("FCM BODY: ${response.body}");
  }

  //  LOGIN
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final url = Uri.parse("$baseUrl/login");

    final response = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "email": email,
        "password": password,
        "device_name": "flutter_app",
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final tokenResponse = data['data']['token'];
      final userResponse = data['data']['user'];

      await guardarToken(tokenResponse);
      await guardarUsuario(userResponse);

      token = tokenResponse;
      currentUser = userResponse;

      try {
        String? fcmToken = await obtenerFCMToken();

        if (fcmToken != null) {
          await enviarTokenFCM(fcmToken);
        }
      } catch (e) {
        print("Error con FCM: $e");
      }

      return data;
    } else {
      throw Exception(data['message'] ?? "Error en login");
    }
  }

  //  TOKEN
  static Future<void> guardarToken(String newToken) async {
    token = newToken;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', newToken);
  }

  static Future<String> obtenerToken() async {
    if (token != null) return token!;

    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');

    return token ?? '';
  }

  //  USER LOCAL STORAGE
  static Future<void> guardarUsuario(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(user));
  }

  static Future<Map<String, dynamic>?> obtenerUsuarioLocal() async {
    if (currentUser != null) return currentUser;

    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('user');

    if (userString == null) return null;

    final user = jsonDecode(userString);
    currentUser = user;

    return user;
  }

  static Future<int?> obtenerUserId() async {
    final user = await obtenerUsuarioLocal();
    return user != null ? user['id'] : null;
  }

  // LOGOUT
  static Future<void> logout() async {
    try {
      String tokenActual = await obtenerToken();

      try {
        await http.post(
          Uri.parse("$baseUrl/logout"),
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $tokenActual",
          },
        );
      } catch (_) {}
    } finally {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.remove('user');

      token = null;
      currentUser = null;
    }
  }

  //  UPDATE USER
  static Future<Map<String, dynamic>> update(
    String name,
    String email,
    String password,
  ) async {
    final url = Uri.parse("$baseUrl/user/update");
    String tokenActual = await obtenerToken();

    Map<String, dynamic> body = {"name": name, "email": email};

    if (password.isNotEmpty) {
      body["password"] = password;
      body["password_confirmation"] = password;
    }

    final response = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $tokenActual",
      },
      body: jsonEncode(body),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      currentUser = data['user'];
      await guardarUsuario(currentUser!);
      return data;
    } else {
      throw Exception(data['message'] ?? "Error al actualizar");
    }
  }

  static Future<Map<String, dynamic>?> getUser() async {
    final token = await obtenerToken();

    final response = await http.get(
      Uri.parse('$baseUrl/user'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return null;
  }

}
