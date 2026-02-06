import 'package:flutter/material.dart';
import 'package:homehive/theme/tema.dart';

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
      ),


      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 35),
              const Text(
                'Favoritos',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: MiTema.textPrimary,
                ),
              ),
              const SizedBox(height: 40),
              _propiedades(),
            ],
          ),
        ),
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
                    Icons.favorite,
                    color: MiTema.rojo,
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
