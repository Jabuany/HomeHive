import 'package:flutter/material.dart';
import 'package:homehive/propietario/editarpropiedades.dart';
import 'package:homehive/services/propserv.dart';
import 'package:homehive/theme/tema.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:homehive/main/vermas.dart';

class MisPropiedades extends StatefulWidget {
  const MisPropiedades({super.key});

  @override
  State<MisPropiedades> createState() => _MisPropiedadesState();
}

class _MisPropiedadesState extends State<MisPropiedades> {
  late Future<List<dynamic>> futurePropiedades;

  @override
  void initState() {
    super.initState();
    futurePropiedades = _cargar();
  }

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  Future<List<dynamic>> _cargar() async {
    final token = await _getToken();
    return PropiedadService.getMisPropiedades(token);
  }

  void _recargar() {
    setState(() {
      futurePropiedades = _cargar();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis propiedades'), centerTitle: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: FutureBuilder<List<dynamic>>(
            future: futurePropiedades,
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

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    'No tienes propiedades. Para publicar una, visita nuestra página web',
                  ),
                );
              }

              final propiedades = snapshot.data!;

              return ListView.builder(
                itemCount: propiedades.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: _propiedadCard(propiedades[index]),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _propiedadCard(dynamic prop) {
    return Card(
      color: MiTema.cart,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
            child: prop['imagen'] != null
                ? Image.network(
                    prop['imagen'],
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
                  'Barrio: ${prop["barrio"]?["nombre"] ?? ''}, ${prop["calle"] ?? ''}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: MiTema.textamarillo,
                  ),
                ),

                const SizedBox(height: 15),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        key: ValueKey('btn_editar_${prop["id"]}'),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditarPropiedadPage(prop: prop),
                            ),
                          );

                          _recargar();
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Editar'),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                        },
                        icon: const Icon(Icons.comment),
                        label: const Text('Comentarios'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    key: Key('btn_ver_mas_${prop["id"]}'),
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
}
