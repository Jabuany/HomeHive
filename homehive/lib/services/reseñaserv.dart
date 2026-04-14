import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:homehive/config/config.dart';

class ResenaService {
  static const String baseUrl = Config.baseApiUrl;

  static Future<List<dynamic>> getResenas(int propiedadId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/reseñas/$propiedadId'),
      headers: {"Accept": "application/json"},
    );

    final body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return body['data'] ?? [];
    } else {
      throw Exception(body['message'] ?? 'Error al obtener reseñas');
    }
  }

  static Future<void> crearResena({
    required int propiedadId,
    required int userId,
    required int rating,
    required String comentario,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reseñas'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "propiedad_id": propiedadId,
        "user_id": userId,
        "rating": rating,
        "comentario": comentario,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Error al crear reseña");
    }
  }

  static Future<void> eliminarResena(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/reseñas/$id'),
      headers: {"Accept": "application/json"},
    );

    if (response.statusCode != 200) {
      throw Exception("Error al eliminar reseña");
    }
  }
}
