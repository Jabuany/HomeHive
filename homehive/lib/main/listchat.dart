import 'dart:async';
import 'package:flutter/material.dart';
import 'package:homehive/main/chat.dart';
import 'package:homehive/services/chat_service.dart';
import 'package:homehive/services/users.dart';
import 'package:homehive/theme/tema.dart';

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
      backgroundColor: MiTema.lilaFondo,

      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/logosnf.png', height: 50),
            const SizedBox(width: 8),
            const Text(
              "HomeHive",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
         centerTitle: true),

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

                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: MiTema.cart,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 10),
                        ],
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 15),

                          const Text(
                            "chat",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Expanded(
                            child: chats.isEmpty
                                ? const Center(
                                    child: Text("No tienes conversaciones"),
                                  )
                                : RefreshIndicator(
                                    onRefresh: _refresh,
                                    child: ListView.builder(
                                      itemCount: chats.length,
                                      itemBuilder: (context, index) {
                                        final chat = chats[index];

                                        final name =
                                            chat['other_user_name'] ??
                                            chat['name'] ??
                                            "Usuario";

                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                          child: Row(
                                            children: [
                                              // Avatar
                                              CircleAvatar(
                                                radius: 24,
                                                backgroundColor: MiTema.gris,
                                                child: Text(
                                                  name[0].toUpperCase(),
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),

                                              const SizedBox(width: 12),

                                              // Nombre
                                              Expanded(
                                                child: Text(
                                                  name,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),

                                              // Botón chat
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.chat_bubble_outline,
                                                ),
                                                color: MiTema.indigoIconos,
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) => Chat(
                                                        conversationId:
                                                            chat['id'],
                                                        otherUserName: name,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                          ),

                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
