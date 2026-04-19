import 'dart:convert';
import 'package:homehive/config/config.dart';
import 'package:http/http.dart' as http;

class PropiedadService {
  static const String baseUrl = Config.baseApiUrl;

  static Future<List<dynamic>> getPropiedades() async {
    final response = await http.get(
      Uri.parse("$baseUrl/propiedades"),
      headers: {"Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body["propiedades"];
    } else {
      throw Exception("Error ${response.statusCode}");
    }
  }

  static Future<List<dynamic>> getMisPropiedades(String token) async {
    final response = await http.get(
      Uri.parse("$baseUrl/propiedades/user"),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body["data"];
    } else {
      throw Exception("Error");
    }
  }

  static Future<Map<String, dynamic>> updatePropiedad(
    int id,
    String titulo,
    String precio,
    String tipo,
    String reglas,
    String descripcion,
    String token,
    String formaPago,
    List<String> servicios,
    String cercanias,
  ) async {
    final response = await http.put(
      Uri.parse("$baseUrl/propiedades/$id"),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
      body: {
        "titulo": titulo,
        "precio": precio,
        "tipo": tipo,
        "reglas": reglas,
        "descripcion": descripcion,
        "forma_pago": formaPago,
        "servicio": jsonEncode(servicios),
        "cercanias": cercanias,
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {"ok": true, "data": data};
    } else {
      return {"ok": false, "data": data};
    }
  }
}
