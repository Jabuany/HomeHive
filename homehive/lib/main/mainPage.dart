import 'package:flutter/material.dart';
import 'package:homehive/menu/filtro.dart';
import 'package:homehive/menu/menu.dart';
import 'package:homehive/services/propserv.dart';
import 'package:homehive/theme/tema.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HomeHive',
      theme: MiTema.temaApp(context),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          // Quitamos el IconButton y la navegación, dejamos solo el Icon
          Icon(Icons.notifications_none, color: MiTema.textPrimary),
          SizedBox(
            width: 20,
          ), // Ajustado para que el icono no quede pegado al borde
        ],
      ),

      drawer: menu(context),
      endDrawer: filtro(context),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: FutureBuilder<List<dynamic>>(
              future: PropiedadService.getPropiedades(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  print(" ERROR REAL: ${snapshot.error}");
                  return Center(
                    child: Text(
                      'Error al cargar propiedades\n${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(child: Text('No hay datos'));
                }

                final propiedades = snapshot.data!;

                if (propiedades.isEmpty) {
                  return const Center(
                    child: Text('No hay propiedades disponibles'),
                  );
                }

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
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.filter_list, color: MiTema.textamarillo),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
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
                child: Image.asset(
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
                  child: const Icon(
                    Icons.favorite_border,
                    color: MiTema.azulPrincipal,
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
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: MiTema.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  prop["titulo"] ?? '',
                  style: TextStyle(fontSize: 16, color: MiTema.textPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  '${prop["barrio"]}, ${prop["calle"]}',
                  style: TextStyle(fontSize: 14, color: MiTema.textamarillo),
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
                      Navigator.of(context).pushNamed('/vermas');
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
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: MiTema.textPrimary),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 340,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: lista.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 15),
                child: SizedBox(
                  width: 250,
                  child: _propiedades(lista[index]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
