import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:homehive/config/config.dart';
import 'package:homehive/main/chat.dart';
import 'package:homehive/services/maps.dart';
import 'package:homehive/services/users.dart';
import 'package:homehive/theme/tema.dart';
import 'package:homehive/views/rentar.dart';
import 'package:homehive/services/reseñaserv.dart';
import 'package:homehive/services/chat_service.dart';

class VerMas extends StatefulWidget {
  final dynamic prop;

  const VerMas({super.key, required this.prop});

  @override
  State<VerMas> createState() => _VerMasState();
}

class _VerMasState extends State<VerMas> {
  late Future<List<dynamic>> reviews;

  final TextEditingController _controller = TextEditingController();

  int _rating = 0;
  int? _editingId;

  @override
  void initState() {
    super.initState();
    cargarReviews();
  }

  void cargarReviews() {
    reviews = ReviewService.getReviews(widget.prop['id']);
  }

  void enviarComentario() async {
    if (_controller.text.isEmpty || _rating == 0) return;

    if (_editingId != null) {
      await ReviewService.actualizarReview(
        id: _editingId!,
        rating: _rating,
        comentario: _controller.text,
      );
    } else {
      await ReviewService.crearReview(
        propiedadId: widget.prop['id'],
        userId: UserService.currentUser?['id'],
        rating: _rating,
        comentario: _controller.text,
      );
    }

    _controller.clear();
    _rating = 0;
    _editingId = null;

    setState(() {
      cargarReviews();
    });
  }

  void eliminar(int id) async {
    await ReviewService.eliminarReview(id);

    setState(() {
      cargarReviews();
    });
  }

  void editar(dynamic r) {
    setState(() {
      _controller.text = r['comentario'];
      _rating = r['rating'];
      _editingId = r['id'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final prop = widget.prop;
    bool esPropietario = UserService.currentUser?['role'] == 'propietario';

    return Scaffold(
      bottomNavigationBar: (!esPropietario)
          ? SafeArea(
              child: Container(
                padding: const EdgeInsets.all(12),
                child: SizedBox(
                  height: 55,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MiTema.azulPrincipal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => Rentar(prop: prop)),
                      );
                    },
                    icon: const Icon(Icons.home, color: Colors.white),
                    label: const Text(
                      'Solicitar renta',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            )
          : null,

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
          bottom: 75,
        ), 
        child: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () async {
            final user = await UserService.obtenerUsuarioLocal();

            final conversation = await ChatService.createOrGetConversation(
              userOneId: user!['id'],
              userTwoId: widget.prop['user_id'],
              propertyId: widget.prop['id'],
            );

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => Chat(
                  conversationId: conversation['id'],
                  otherUserName:
                      widget.prop['usuario']?['name'] ?? 'Propietario',
                ),
              ),
            );
          },
          child: const Icon(Icons.chat, color: Colors.white),
        ),
      ),
          

      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/logosnf.png', height: 50),
            const SizedBox(width: 8),
            const Text(
              "HomeHive",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ), 
        centerTitle: true),
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
              // titulo
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  prop['titulo'] ?? '',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const Divider(),

              // imagen
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
                    // precio
                    Text(
                      '\$${prop['precio']}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    const SizedBox(height: 10),

                    

                    // secciones
                    _seccion('Descripción', prop['descripcion'] ?? ''),
                    _seccion(
                      'Servicios',
                      _formatearServicios(prop['servicio']),
                    ),
                    _seccion('Cercanías', prop['cercanias'] ?? ''),
                    _seccion(
                      'Ubicación',
                      'Barrio: ${prop['barrio']['nombre']}, ${prop['calle']}',
                    ),

                    const SizedBox(height: 20),

                    // mapa
                    if (prop['latitud'] != null && prop['longitud'] != null)
                      MapaWidget(
                        lat: double.parse(prop['latitud'].toString()),
                        lng: double.parse(prop['longitud'].toString()),
                      ),

                    // comentarios
                    FutureBuilder<List<dynamic>>(
                      future: reviews,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final data = snapshot.data!;

                        double promedio = 0;
                        if (data.isNotEmpty) {
                          promedio =
                              data
                                  .map((e) => e['rating'])
                                  .reduce((a, b) => a + b) /
                              data.length;
                        }
                        const SizedBox(height: 20);

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Comentarios',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('Promedio: ${promedio.toStringAsFixed(1)}'),

                            const SizedBox(height: 10),

                            if (data.isEmpty)
                              const Text('No hay comentarios')
                            else
                              Column(
                                children: data
                                    .map((r) => _comentarioUI(r))
                                    .toList(),
                              ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 10),

                    if (!esPropietario) _inputComentario(),

                    const SizedBox(height: 20),
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

  // solucion robusta para servicios
  String _formatearServicios(dynamic servicios) {
    if (servicios == null) return '';

    // si ya es lista
    if (servicios is List) {
      return servicios.join(', ');
    }

    // si es string JSON
    if (servicios is String) {
      try {
        final decoded = jsonDecode(servicios);
        if (decoded is List) {
          return decoded.join(', ');
        }
      } catch (e) {
        // fallback si no es JSON válido
        return servicios
            .replaceAll('[', '')
            .replaceAll(']', '')
            .replaceAll('"', '')
            .split(',')
            .map((e) => e.trim())
            .join(', ');
      }
    }

    return servicios.toString();
  }

Widget _comentarioUI(dynamic r) {
    final currentUserId = UserService.currentUser?['id'];
    final reviewUserId = r['user_id'];

    bool esMia = currentUserId == reviewUserId;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey[200],
            backgroundImage:
                (r["usuario"]?["avatar"] != null &&
                    r["usuario"]["avatar"].toString().isNotEmpty)
                ? NetworkImage(
                    "${Config.baseUrl}/storage/${r["usuario"]["avatar"]}",
                  )
                : null,
            child:
                (r["usuario"]?["avatar"] == null ||
                    r["usuario"]["avatar"].toString().isEmpty)
                ? const Icon(Icons.person, size: 20, color: Colors.grey)
                : null,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: List.generate(
                    5,
                    (index) => Icon(
                      Icons.star,
                      size: 16,
                      color: index < (r['rating'] ?? 0)
                          ? Colors.amber
                          : Colors.grey[300],
                    ),
                  ),
                ),
                const SizedBox(height: 5),

                Text(
                  r["usuario"]?["name"] ?? 'Usuario',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                Text(r['comentario'] ?? ''),
              ],
            ),
          ),

          if (esMia)
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, size: 18),
                  onPressed: () => editar(r),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                  onPressed: () => eliminar(r['id']),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _inputComentario() {
    return Column(
      children: [
        _ratingStars(),
        const SizedBox(height: 5),
        Container(
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
                  decoration: InputDecoration(
                    hintText: _editingId != null
                        ? 'Editar comentario...'
                        : 'Comentar...',
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(_editingId != null ? Icons.edit : Icons.send),
                onPressed: enviarComentario,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _ratingStars() {
    return Row(
      children: List.generate(5, (index) {
        return IconButton(
          onPressed: () {
            setState(() {
              _rating = index + 1;
            });
          },
          icon: Icon(
            Icons.star,
            color: index < _rating ? Colors.amber : Colors.grey,
          ),
        );
      }),
    );
  }
}
