
import 'package:flutter/material.dart';



Drawer menu(BuildContext context) {
  return Drawer(
    child: Column(
      children: [
        const SizedBox(height: 50),
        Text('HomeHive', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        _perfil(),
        const SizedBox(height: 20),
        _opcion(Icons.chat, 'Chat', () {
          Navigator.of(context).pushNamed('/chat');
        }),
        _opcion(Icons.report, 'Reportar', () {
          Navigator.of(context).pushNamed('/reportar');
        }),
        _opcion(Icons.help, 'Ayuda', () {
          Navigator.of(context).pushNamed('/');
        }),
        _opcion(Icons.favorite, 'Favoritos', () {
          Navigator.of(context).pushNamed('/favoritos');
        }),
        _opcion(Icons.exit_to_app, 'Salir', () {
          Navigator.of(context).pushNamed('/login');
        }),
      ],
    ),
  );
}


Widget _perfil() {
  return Column(
    children: [
      Icon(Icons.person_2, size: 90),
      const SizedBox(height: 10),
      const Text(
        'Pauline Lenoir',
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 5),
    ],
  );
}



Widget _opcion(IconData icono, String texto, Function() accion) {
  return ListTile(
    leading: Icon(icono),
    title: Text(texto),
    onTap: accion,
  );
}