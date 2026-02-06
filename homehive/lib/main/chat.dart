import 'package:flutter/material.dart';
import 'package:homehive/theme/tema.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: MiTema.temaApp(context),
      title: 'HomeHive',
      home: Chat(),
    );
  }
}

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MiTema.bggris,

      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            Icon(Icons.person_2),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Pablito mendez',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Activo(a) hace 9 horas',
                  style: TextStyle(fontSize: 12, color: MiTema.textamarillo),
                ),
              ],
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _mensajeRecibido('Puede realizar el pago\na través de la QR'),
                _mensajeEnviado(
                  'Claro que sí, en un momento\nle envío el comprobante',
                ),
                _mensajeRecibido('Muy bien'),
                _tarjetaTransferencia(),
                _mensajeRecibido(
                  'Con esto concluimos, puede\nvenir en cualquier momento',
                ),
              ],
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
        child: Text(texto, style: const TextStyle(fontSize: 14)),
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
        child: Text(
          texto,
          style: const TextStyle(fontSize: 14, color: Colors.white),
        ),
      ),
    );
  }

  Widget _tarjetaTransferencia() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        width: 230,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: MiTema.verde,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Transferencia exitosa',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '\$20,000.00',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text('Estado: Completado', style: TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }

  Widget _inputMensaje() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: MiTema.gris,
      child: Row(
        children: [
          IconButton(icon: const Icon(Icons.camera_alt), onPressed: () {}),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Mensaje',
                filled: true,
                fillColor: MiTema.bggris,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          IconButton(icon: const Icon(Icons.send), onPressed: () {}),
        ],
      ),
    );
  }
}
