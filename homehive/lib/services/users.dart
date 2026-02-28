import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const String baseUrl = "http://10.0.2.2:80/api";
  static Map<String, dynamic>? currentUser; //esto es para almacenar el usuario actual después del login, esto es para poder mostrar el nombre del usuario en el menú y para tener acceso a los datos del usuario en toda la aplicación.
  static String? token; //esto es para almacenar el token después del login, esto es para poder usarlo en las peticiones que requieran autenticación, como la modificación de datos del usuario y el chat.

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

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<void> logout() async{
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.post(
       Uri.parse("$baseUrl/logout"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode ==  200) {
      await prefs.remove('token');
    } else{
      throw Exception('Error al cerrar sesión');
    }
  }


}
