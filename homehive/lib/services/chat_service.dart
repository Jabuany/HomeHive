import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:homehive/config/config.dart';
import 'package:homehive/services/users.dart';

class ChatService {
  static const String baseUrl = Config.baseApiUrl;

  static Future<List<dynamic>> getConversations(int userId) async {
    String token = await UserService.obtenerToken();

    final url = Uri.parse("$baseUrl/conversations/$userId");

    final response = await http.get(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    final data = jsonDecode(response.body);
    print(response);

    if (response.statusCode == 200) {
      return data;
    } else {
      throw Exception(data['message'] ?? "Error al obtener conversaciones");
    }
  }

  static Future<List<dynamic>> getMessages(int conversationId) async {
    String token = await UserService.obtenerToken();

    final url = Uri.parse("$baseUrl/messages/$conversationId");

    final response = await http.get(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    } else {
      throw Exception("Error al obtener mensajes");
    }
  }

  static Future<Map<String, dynamic>> sendMessage({
    required int conversationId,
    required int senderId,
    required String message,
  }) async {
    String token = await UserService.obtenerToken();

    final url = Uri.parse("$baseUrl/messages");

    final response = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "conversation_id": conversationId,
        "sender_id": senderId,
        "message": message,
      }),
    );

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    } else {
      throw Exception("Error backend: ${response.body}");
    }
  }

  static Future<Map<String, dynamic>> createOrGetConversation({
    required int userOneId,
    required int userTwoId,
    int? propertyId,
  }) async {
    String token = await UserService.obtenerToken();

    final url = Uri.parse("$baseUrl/conversations");

    final response = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "user_one_id": userOneId,
        "user_two_id": userTwoId,
        "property_id": propertyId,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    } else {
      throw Exception("Error al crear conversación");
    }
  }
}
