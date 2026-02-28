import 'dart:convert';
import 'package:http/http.dart' as http;

class PropiedadService {
  static const String baseUrl = "http://10.0.2.2:80/api"; //esto es para acceder al localhost, para que puedan acceder al localhost cambien el localhost por esta ip, esto es para que puedan acceder al backend desde el emulador de android, si están usando un dispositivo físico, cambien el localhost por la ip de sus máquinas en la red local.

  static Future<List<dynamic>> getPropiedades() async {
    final response = await http.get(
      Uri.parse("$baseUrl/propiedades"),
      headers: {"Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body["data"];  
    } else {
      throw Exception("Error ${response.statusCode}: ${response.body}");
    }
  }

}
