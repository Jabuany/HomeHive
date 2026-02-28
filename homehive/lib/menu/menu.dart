import 'package:flutter/material.dart';
import 'package:homehive/services/users.dart';
import 'package:homehive/views/edit_profile.dart';

Drawer menu(BuildContext context) {
  return Drawer(
    child: Column(
      children: [
        const SizedBox(height: 50),
        const Text(
          'HomeHive',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        _perfil(context), 
        const SizedBox(height: 20),
        _opcion(Icons.chat, 'Chat', () {
          Navigator.of(context).pushNamed('/chat');
        }),
        // _opcion(Icons.report, 'Reportar', () {
        //   Navigator.of(context).pushNamed('/reportar');
        // }),
        _opcion(Icons.help, 'Ayuda', () {
          Navigator.of(context).pushNamed('/');
        }),
        _opcion(Icons.favorite, 'Favoritos', () {
          Navigator.of(context).pushNamed('/favoritos');
        }),
        _opcion(Icons.exit_to_app, 'Salir', () async {
          try {
            await UserService.logout();
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil('/login', (route) => false);
          } catch (e) {
            print("Error al cerrar sesión: $e");
          }
        }),
      ],
    ),
  );
}

Widget _perfil(BuildContext context) {
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const EditProfile()),
      );
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        children: [
          const Icon(Icons.person_2, size: 90),
          const SizedBox(height: 10),
          Text(
            UserService.currentUser?['name'] ??
                'Usuario', //se agrego esto, para poder mostrar el nombre del usuario en el menú
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          const Text(
            'Ver perfil',
            style: TextStyle(color: Colors.blue, fontSize: 14),
          ),
        ],
      ),
    ),
  );
}

Widget _opcion(IconData icono, String texto, Function() accion) {
  return ListTile(
    leading: Icon(icono),
    title: Text(texto),
    onTap: accion,
  );
}