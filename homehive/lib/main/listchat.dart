import 'dart:async';
import 'package:flutter/material.dart';
import 'package:homehive/main/chat.dart';
import '../services/chat_service.dart';
import '../services/users.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  late Future<List<dynamic>> conversationsFuture;
  int? userId;

  Timer? timer;

  @override
  void initState() {
    super.initState();
    _init();

    timer = Timer.periodic(const Duration(seconds: 3), (t) {
      if (userId != null) {
        _refreshSilent();
      }
    });
  }

  Future<void> _init() async {
    userId = await UserService.obtenerUserId();

    setState(() {
      conversationsFuture = ChatService.getConversations(userId!);
    });
  }

  Future<void> _refresh() async {
    setState(() {
      conversationsFuture = ChatService.getConversations(userId!);
    });
  }

  Future<void> _refreshSilent() async {
    final data = await ChatService.getConversations(userId!);

    setState(() {
      conversationsFuture = Future.value(data);
    });
  }

  @override
  void dispose() {
    timer?.cancel(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mis chats"), centerTitle: true),
      body: userId == null
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<List<dynamic>>(
              future: conversationsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                final chats = snapshot.data ?? [];

                if (chats.isEmpty) {
                  return const Center(child: Text("No tienes conversaciones"));
                }

                return RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView.separated(
                    itemCount: chats.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final chat = chats[index];

                      final name =
                          chat['other_user_name'] ?? chat['name'] ?? "Usuario";

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          child: Text(
                            name[0].toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),

                        title: Text(
                          name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),

                        subtitle: Text(
                          chat['last_message'] ?? "Sin mensajes",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        trailing: Text(
                          chat['updated_at'] != null
                              ? chat['updated_at'].toString().substring(11, 16)
                              : "",
                          style: const TextStyle(fontSize: 12),
                        ),

                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => Chat(
                                conversationId: chat['id'],
                                otherUserName:
                                    chat['other_user_name'] ?? 'Usuario',
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
