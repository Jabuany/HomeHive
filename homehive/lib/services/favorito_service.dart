import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:homehive/config/config.dart';

class FavoritoService {
  static const String baseUrl = Config.baseApiUrl;

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<bool> agregarFavorito(int propiedadId) async {
    final token = await _getToken();

    print( "token: $token" );

    final response = await http.post(
      Uri.parse('$baseUrl/favoritos'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'propiedad_id': propiedadId}),
    );

    print(response.statusCode);
    print(response.body);

    return response.statusCode == 201;
  }

  static Future<bool> eliminarFavorito(int propiedadId) async {
    final token = await _getToken();

    final response = await http.delete(
      Uri.parse('$baseUrl/favoritos/$propiedadId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    print(response.statusCode);
    print(response.body);

    return response.statusCode == 200;
  }

  static Future<List<dynamic>> obtenerFavoritos() async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/favoritos'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    }

    return [];
  }

  static Future<bool> esFavorito(int propiedadId) async {
    final favoritos = await obtenerFavoritos();

    return favoritos.any((f) => f['id'] == propiedadId);
  }
}
