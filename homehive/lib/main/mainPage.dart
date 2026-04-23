import 'package:flutter/material.dart';
import 'package:homehive/config/config.dart';
import 'package:homehive/main.dart';
import 'package:homehive/menu/filtro.dart';
import 'package:homehive/menu/menu.dart';
import 'package:homehive/services/favorito_service.dart';
import 'package:homehive/services/propserv.dart';
import 'package:homehive/services/users.dart';
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
      home: FutureBuilder<bool>(
        future: haySesion(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.data == true) {
            return const MainPage();
          } else {
            return const Login();
          }
        },
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late Future<List<dynamic>> _futurePropiedades;
  Map<String, dynamic>? user;
  List<dynamic> propiedades = [];
  Map<int, bool> favoritosEstado = {};
  @override
  void initState() {
    super.initState();
     _futurePropiedades = PropiedadService.getPropiedades();
    cargarDatos();
    cargarUsuario();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Notificación en foreground");

      if (message.notification != null) {
        print("Título: ${message.notification!.title}");
        print("Body: ${message.notification!.body}");
      }
    });
  }

  Future<void> cargarDatos() async {
    final props = await PropiedadService.getPropiedades();
    final favs = await FavoritoService.obtenerFavoritos();

    Map<int, bool> favMap = {};

    for (var f in favs) {
      favMap[f['id']] = true;
    }

    setState(() {
      propiedades = props;
      favoritosEstado = favMap;
    });
  }

  Future<void> cargarUsuario() async {
    final data = await UserService.obtenerUsuarioLocal();

    if (!mounted) return;

    setState(() {
      user = data;
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
              tooltip: 'open_drawer',
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: FutureBuilder<List<dynamic>>(
              future: _futurePropiedades,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      snapshot.error.toString(),
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(child: Text('No hay datos'));
                }

                final propiedades = snapshot.data!;

                final cuartos = propiedades
                    .where((p) => p['tipo'] == 'cuarto')
                    .toList();

                final casas = propiedades
                    .where((p) => p['tipo'] == 'casa')
                    .toList();

                final departamentos = propiedades
                    .where((p) => p['tipo'] == 'departamento')
                    .toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _searchBar(),
                    const SizedBox(height: 25),
                    _seccionpropiedades("Cuartos", cuartos),
                    _seccionpropiedades("Casas", casas),
                    _seccionpropiedades("Departamentos", departamentos),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _searchBar() {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: MiTema.cart,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: MiTema.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: MiTema.textamarillo),
          const SizedBox(width: 10),
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: MiTema.textamarillo),
            onPressed: () {
              filtro(context);
            },
          ),
        ],
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
                      bool esFav = favoritosEstado[prop['id']] == true;

                      if (esFav) {
                        await FavoritoService.eliminarFavorito(prop['id']);
                      } else {
                        await FavoritoService.agregarFavorito(prop['id']);
                      }

                      setState(() {
                        favoritosEstado[prop['id']] = !esFav;
                      });
                    },
                    child: Icon(
                      (favoritosEstado[prop['id']] ?? false)
                          ? Icons.favorite
                          : Icons.favorite_border,
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

  void configurarNotificaciones() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Mensaje recibido en foreground");

      if (message.notification != null) {
        print("Título: ${message.notification!.title}");
        print("Body: ${message.notification!.body}");
      }
    });
  }
}
