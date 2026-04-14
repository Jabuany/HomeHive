import 'dart:convert';
import 'package:homehive/config/config.dart';
import 'package:http/http.dart' as http;

class PropiedadService {
  static const String baseUrl = Config
      .baseApiUrl; //esto es para acceder al localhost, para que puedan acceder al localhost cambien el localhost por esta ip, esto es para que puedan acceder al backend desde el emulador de android, si están usando un dispositivo físico, cambien el localhost por la ip de sus máquinas en la red local.

  static Future<List<dynamic>> getPropiedades() async {
    final response = await http.get(
      Uri.parse("$baseUrl/propiedades"),
      headers: {"Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      print("BODY: ${response.body}");

      final body = jsonDecode(response.body);
      return body["propiedades"];
    } else {
      throw Exception("Error ${response.statusCode}: ${response.body}");
    }
  }

  static Future<dynamic> getPropiedad(int id) async {
    final response = await http.get(
      Uri.parse("$baseUrl/vermas/$id"),
      headers: {"Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body["data"];
    } else {
      throw Exception("Error al obtener propiedad");
    }
  }

  static Future<List<dynamic>> getMisPropiedades(String token) async {
    final response = await http.get(
      Uri.parse("$baseUrl/propiedades/user"),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      print("MIS PROPIEDADES: ${response.body}");

      final body = jsonDecode(response.body);

      return body["data"];
    } else if (response.statusCode == 401) {
      throw Exception("No autenticado");
    } else {
      throw Exception("Error ${response.statusCode}: ${response.body}");
    }
  }

  static Future<bool> updatePropiedad(
    int id,
    String titulo,
    String precio,
    String tipo,
    String reglas,
    String descripcion,
    String token,
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
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print(response.body);
      return false;
    }
  }
}
