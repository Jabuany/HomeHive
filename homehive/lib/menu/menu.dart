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

        _opcion(context, Icons.chat, 'Chat', () {
          Navigator.of(context).pushNamed('/chat');
        }, "menu_chat"),

        if (UserService.currentUser?['role'] == 'inquilino')
          _opcion(context, Icons.help, 'Ayuda', () {
            Navigator.of(context).pushNamed('/');
          }, 'menu_ayuda'),

        if (UserService.currentUser?['role'] == 'inquilino')
          _opcion(context, Icons.favorite, 'Favoritos', () {
            Navigator.of(context).pushNamed('/favoritos');
          }, 'menu_favoritos'),

        if (UserService.currentUser?['role'] == 'propietario')
          _opcion(context, Icons.request_quote, 'Solicitudes', () {
            Navigator.of(context).pushNamed('/solicitudes');
          }, 'menu_solicitudes'),

        if (UserService.currentUser?['role'] == 'propietario')
          _opcion(context, Icons.home, 'Mis propiedades', () {
            Navigator.of(context).pushNamed('/mispropiedades');
          }, 'menu_mis_propiedades'),

        _opcion(context, Icons.exit_to_app, 'Salir', () async {
          final navigator = Navigator.of(context);

          try {
            await UserService.logout();

            navigator.pushNamedAndRemoveUntil('/login', (route) => false);
          } catch (e) {
            print("Error al cerrar sesión: $e");
          }
        }, 'menu_logout'),
      ],
    ),
  );
}

Widget _perfil(BuildContext context) {
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const EditProfile()),
      );
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        children: [
          const Icon(Icons.person_2, size: 90),

          const SizedBox(height: 10),

          Text(
            UserService.currentUser?['name'] ?? 'Usuario',
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
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

Widget _opcion(
  BuildContext context,
  IconData icono,
  String texto,
  Function() accion,
  String keyName,
) {
  return Semantics(
    label: keyName,
    child: ListTile(
      key: Key(keyName),
      leading: Icon(icono),
      title: Text(texto),

      onTap: () {
        Navigator.pop(context);
        accion(); 
      },
    ),
  );
}
