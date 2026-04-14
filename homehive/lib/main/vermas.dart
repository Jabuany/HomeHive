import 'package:flutter/material.dart';
import 'package:homehive/config/config.dart';
import 'package:homehive/services/users.dart';
import 'package:homehive/theme/tema.dart';
import 'package:homehive/views/rentar.dart';
import 'package:homehive/services/reseñaserv.dart';

class VerMas extends StatefulWidget {
  final dynamic prop;

  const VerMas({super.key, required this.prop});

  @override
  State<VerMas> createState() => _VerMasState();
  
}

class _VerMasState extends State<VerMas> {
  late Future<List<dynamic>> reviews;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    cargarReviews();
  }

  void cargarReviews() {
    reviews = ResenaService.getResenas(widget.prop['id']);
  }

  void enviarComentario() async {
    if (_controller.text.isEmpty) return;

    await ResenaService.crearResena(
      propiedadId: widget.prop['id'],
      userId: 1,
      rating: 5,
      comentario: _controller.text,
    );

    _controller.clear();

    setState(() {
      cargarReviews();
    });
  }

  void eliminar(int id) async {
    await ResenaService.eliminarResena(id);

    setState(() {
      cargarReviews();
    });
  }

  @override
  Widget build(BuildContext context) {
    final prop = widget.prop;
    bool esPropietario = UserService.currentUser?['role'] == 'propietario';


    return Scaffold(
      appBar: AppBar(title: const Text('HomeHive'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Card(
          color: MiTema.cart,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Text(
                      prop['titulo'] ?? '',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(),

              Padding(
                padding: const EdgeInsets.all(12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
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
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\$${prop['precio']}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    _seccion('Descripción', prop['descripcion'] ?? ''),
                    _seccion('Servicios', prop['servicio'] ?? ''),
                    _seccion('Cercanías', prop['cercanias'] ?? ''),
                    _seccion(
                      'Ubicación',
                      'Barrio: ${prop['barrio']['nombre']}, ${prop['calle']}',
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'Comentarios',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 10),
                    FutureBuilder<List<dynamic>>(
                      future: reviews,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          return Text(snapshot.error.toString());
                        }

                        final data = snapshot.data ?? [];

                        if (data.isEmpty) {
                          return const Text('No hay comentarios');
                        }
                        return Column(
                          children: data.map((r) {
                            return _comentarioUI(r);
                          }).toList(),
                        );
                      },
                    ),

                    const SizedBox(height: 10),
                    if (!esPropietario) _inputComentario(),

                    const SizedBox(height: 20),  

                    if (!esPropietario)
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MiTema.azulPrincipal,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const Rentar()),
                            );
                          },
                          child: const Text(
                            'Rentar',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _seccion(String titulo, String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(texto),
        ],
      ),
    );
  }

  Widget _comentarioUI(dynamic r) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          const CircleAvatar(child: Icon(Icons.person)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: List.generate(
                    r['rating'] ?? 5,
                    (index) =>
                        const Icon(Icons.star, size: 14, color: Colors.amber),
                  ),
                ),
Text(
                  r['user']?['name'] ?? 'Usuario',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(r['comentario'] ?? ''),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => eliminar(r['id']),
          ),
        ],
      ),
    );
  }

  Widget _inputComentario() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Comentar',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(icon: const Icon(Icons.send), onPressed: enviarComentario),
        ],
      ),
    );
  }
}
