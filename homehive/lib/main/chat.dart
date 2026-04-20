import 'package:flutter/material.dart';
import 'package:homehive/services/chat_service.dart';
import 'package:homehive/services/users.dart';
import 'package:homehive/theme/tema.dart';

class Chat extends StatefulWidget {
  final int conversationId;
  final String otherUserName;

  const Chat({
    super.key,
    required this.conversationId,
    required this.otherUserName,
  });

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  List<dynamic> messages = [];
  final TextEditingController controller = TextEditingController();
  int? userId;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    initChat();
  }

  Future<void> initChat() async {
    final user = await UserService.obtenerUsuarioLocal();
    userId = user?['id'];

    await loadMessages();
  }

  Future<void> loadMessages() async {
    final data = await ChatService.getMessages(widget.conversationId);

    setState(() {
      messages = data;
      loading = false;
    });
  }

  Future<void> sendMessage() async {
    if (controller.text.trim().isEmpty) return;

    final text = controller.text;
    controller.clear();

    await ChatService.sendMessage(
      conversationId: widget.conversationId,
      senderId: userId!,
      message: text,
    );

    await loadMessages();

    setState(() {}); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MiTema.bggris,

      appBar: AppBar(
        elevation: 0,
        title: Text(widget.otherUserName),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final isMe = msg['sender_id'] == userId;

                      return isMe
                          ? _mensajeEnviado(msg['message'])
                          : _mensajeRecibido(msg['message']);
                    },
                  ),
          ),

          _inputMensaje(),
        ],
      ),
    );
  }

  Widget _mensajeRecibido(String texto) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(texto),
      ),
    );
  }

  Widget _mensajeEnviado(String texto) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: MiTema.verde,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(texto, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _inputMensaje() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: MiTema.gris,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Mensaje",
                filled: true,
                fillColor: MiTema.bggris,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          IconButton(icon: const Icon(Icons.send), onPressed: sendMessage),
        ],
      ),
    );
  }
}
