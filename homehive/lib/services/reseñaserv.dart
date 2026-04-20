import 'dart:convert';
import 'package:homehive/services/users.dart';
import 'package:http/http.dart' as http;
import 'package:homehive/config/config.dart';

class ReviewService {
  static const String baseUrl = Config.baseApiUrl;

  static Future<List<dynamic>> getReviews(int propiedadId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/reseñas/$propiedadId'),
      headers: {"Accept": "application/json"},
    );

    final body = jsonDecode(response.body);
    print(body);

    if (response.statusCode == 200) {
      return body['data'] ?? [];
    } else {
      throw Exception(body['message'] ?? 'Error al obtener reseñas');
    }
  }

  static Future<void> crearReview({
    required int propiedadId,
    required int userId,
    required int rating,
    required String comentario,
  }) async {
    final token = await UserService.obtenerToken();

    final response = await http.post(
      Uri.parse('$baseUrl/reseñas'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "propiedad_id": propiedadId,
        "user_id": userId,
        "rating": rating,
        "comentario": comentario,
      }),
    );

    final body = jsonDecode(response.body);

    print("Token: $token");
    print("STATUS: ${response.statusCode}");
    print("BODY: $body");

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(body['message'] ?? 'Error al crear reseña');
    }
  }

  static Future<void> eliminarReview(int id) async {
    final token = await UserService.obtenerToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/reseñas/$id'),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Error al eliminar reseña");
    }
  }

  static Future<void> actualizarReview({
    required int id,
    required int rating,
    required String comentario,
  }) async {
    final token = await UserService.obtenerToken();

    final response = await http.put(
      Uri.parse('$baseUrl/reseñas/$id'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"rating": rating, "comentario": comentario}),
      
    );

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception(response.body); 
    }
  }
}
