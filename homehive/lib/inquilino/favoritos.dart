import 'package:flutter/material.dart';
import 'package:homehive/config/config.dart';
import 'package:homehive/menu/filtro.dart';
import 'package:homehive/menu/menu.dart';
import 'package:homehive/services/favorito_service.dart';
import 'package:homehive/theme/tema.dart';
import 'package:homehive/main/vermas.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HomeHive',
      theme: MiTema.temaApp(context),
      home: const Favorite(),
    );
  }
}

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  List<dynamic> propiedades = [];
  bool cargando = true;
  Map<int, bool> favoritosEstado = {};

  @override
  void initState() {
    super.initState();
    cargarFavoritos();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        print(message.notification!.title);
        print(message.notification!.body);
      }
    });
  }

  Future<void> cargarFavoritos() async {
    final data = await FavoritoService.obtenerFavoritos();

    setState(() {
      propiedades = data;
      cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              key: const ValueKey('open_drawer'),
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'HomeHive',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: MiTema.textPrimary,
          ),
        ),
        actions: const [
          Icon(Icons.notifications_none, color: MiTema.textPrimary),
          SizedBox(width: 20),
        ],
      ),
      drawer: Builder(builder: (context) => menu(context)),
      endDrawer: Builder(builder: (context) => filtro(context)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: cargando
              ? const Center(child: CircularProgressIndicator())
              : propiedades.isEmpty
              ? const Center(child: Text('No hay favoritos'))
              : Builder(
                  builder: (context) {
                    final cuartos = propiedades
                        .where((p) => p['tipo'] == 'cuarto')
                        .toList();

                    final casas = propiedades
                        .where((p) => p['tipo'] == 'casa')
                        .toList();

                    final departamentos = propiedades
                        .where((p) => p['tipo'] == 'departamento')
                        .toList();

                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 25),
                          _seccionpropiedades("Cuartos", cuartos),
                          _seccionpropiedades("Casas", casas),
                          _seccionpropiedades("Departamentos", departamentos),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }

  Widget _propiedades(dynamic prop) {
    return Card(
      color: MiTema.cart,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(25),
                ),
                child: prop['imagenes'] != null
                    ? Image.network(
                        "${Config.baseUrl}/storage/${prop['imagenes'][0]['ruta']}",
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/casa.webp',
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      await FavoritoService.eliminarFavorito(prop['id']);

                      setState(() {
                        propiedades.removeWhere((p) => p['id'] == prop['id']);
                      });
                    },
                    child: const Icon(
                      Icons.favorite,
                      color: MiTema.azulPrincipal,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '\$${prop["precio"]}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: MiTema.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  prop["titulo"] ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    color: MiTema.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Barrio: ${prop["barrio"]?["nombre"]}, ${prop["calle"]}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: MiTema.textamarillo,
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MiTema.azulPrincipal,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => VerMas(prop: prop)),
                      );
                    },
                    child: const Text('Ver más'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _seccionpropiedades(String titulo, List lista) {
    if (lista.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: MiTema.textPrimary,
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 360,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: lista.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 15),
                child: SizedBox(width: 250, child: _propiedades(lista[index])),
              );
            },
          ),
        ),
      ],
    );
  }
}
