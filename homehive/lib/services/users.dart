import 'dart:convert';
import 'package:homehive/config/config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const String baseUrl = Config.baseApiUrl;

  static Map<String, dynamic>? currentUser;
  static String? token;

  // LOGIN
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

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final tokenResponse = data['data']['token'];
      final userResponse = data['data']['user'];

      await guardarToken(tokenResponse);
      currentUser = userResponse;

      return data;
    } else {
      throw Exception(data['message'] ?? "Error en login");
    }
  }

  // GUARDAR TOKEN
  static Future<void> guardarToken(String newToken) async {
    token = newToken;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', newToken);
  }

  // OBTENER TOKEN
  static Future<String> obtenerToken() async {
    if (token != null) return token!;

    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');

    return token ?? '';
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
      } catch (e) {
        print("Logout API error ignorado: $e");
      }
    } finally {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');

      token = null;
      currentUser = null;
    }
  }

  // UPDATE USER
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

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      currentUser = data['user'];
      return data;
    } else {
      throw Exception(data['message'] ?? "Error al actualizar");
    }
  }
}
