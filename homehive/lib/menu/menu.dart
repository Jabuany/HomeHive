import 'package:flutter/material.dart';
import 'package:homehive/config/config.dart';
import 'package:homehive/services/users.dart';

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
        
        _opcion(context, Icons.home, 'Inicio', () {
          Navigator.of(context).pushNamed('/inicio');
        }, "menu_inicio"),

        _opcion(context, Icons.chat, 'Chat', () {
          Navigator.of(context).pushNamed('/listerchat');
        }, "menu_chat"),

        if (UserService.currentUser?['role'] == 'inquilino')
          _opcion(context, Icons.help, 'Ayuda', () {
            Navigator.of(context).pushNamed('/');
          }, 'menu_ayuda'),

        if (UserService.currentUser?['role'] == 'inquilino')
          _opcion(context, Icons.favorite, 'Favoritos', () {
            Navigator.of(context).pushNamed('/favoritos');
          }, 'menu_favoritos'),

        if (UserService.currentUser?['role'] == 'inquilino')
          _opcion(context, Icons.home, 'Mis solicitudes', () {
            Navigator.of(context).pushNamed('/solicitudes');
          }, 'Mis_Solicitudes'),
        
        if (UserService.currentUser?['role'] == 'inquilino')
          _opcion(context, Icons.payment, 'Mis pagos', () {
            Navigator.of(context).pushNamed('/mis-pagos');
          }, 'menu_mis_pagos'),

        if (UserService.currentUser?['role'] == 'propietario')
          _opcion(context, Icons.request_quote, 'Solicitudes', () {
            Navigator.of(context).pushNamed('/solicitudes');
          }, 'menu_solicitudes'),

        if (UserService.currentUser?['role'] == 'propietario')
          _opcion(context, Icons.payment, 'Mis pagos', () {
            Navigator.of(context).pushNamed('/mis-pagos');
          }, 'menu_mis_pagos'),

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
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/perfil',
        (route) => false,
      );
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey[200],
            backgroundImage: (UserService.currentUser?['avatar'] != null &&
                    UserService.currentUser!['avatar'].toString().isNotEmpty)
                ? NetworkImage("${Config.baseUrl}/storage/${UserService.currentUser!['avatar']}")
                : null,
            child: (UserService.currentUser?['avatar'] == null ||
                    UserService.currentUser!['avatar'].toString().isEmpty)
                ? const Icon(Icons.person, size: 40, color: Colors.grey)
                : null,
          ),

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
