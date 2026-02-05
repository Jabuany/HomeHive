import 'package:flutter/material.dart';
import 'package:homehive/menu/filtro.dart';
import 'package:homehive/menu/menu.dart';
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
      backgroundColor: MiTema.bggris,
      appBar: AppBar(
        backgroundColor: MiTema.bggris,
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
          SizedBox(width: 12),
        ],
      ),

      drawer: menu(context),
      endDrawer: filtro(context),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _searchBar(),
              const SizedBox(height: 25),
              const Text(
                'Cuartos',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: MiTema.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              _propiedades(),
            ],
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

          // Botón de filtro 
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


  Widget _propiedades() {
    return Card(
      color: MiTema.cart,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen + favorito
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

          // Info del card
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '\$100',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: MiTema.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Titulo',
                  style: TextStyle(fontSize: 16, color: MiTema.textPrimary),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Ubicación',
                  style: TextStyle(fontSize: 14, color: MiTema.textamarillo),
                ),
                const SizedBox(height: 15),

                // Botón
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
                    onPressed: () {},
                    child: const Text('Rentar'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
