import 'package:flutter/material.dart';
import 'package:homehive/theme/tema.dart';
import 'package:homehive/views/solicitudes.dart';

class Solicitudes extends StatefulWidget {
  const Solicitudes({Key? key}) : super(key: key);

  @override
  State<Solicitudes> createState() => _SolicitudesState();
}

class _SolicitudesState extends State<Solicitudes> {
  final List<Map<String, String>> solicitudesList = [
    {
      'nombre': 'Pauline Lenoir',
      'propiedad': 'Corazón Urbano',
      'tipo': 'Propiedad',
      'imagen': 'assets/pauline.jpg',
    },
    {
      'nombre': 'Gomita buena onda',
      'propiedad': 'Corazón Urbano',
      'tipo': 'Propiedad',
      'imagen': 'assets/gomita.jpg',
    },
    {
      'nombre': 'Mayito López',
      'propiedad': 'Corazón Urbano',
      'tipo': 'Propiedad',
      'imagen': 'assets/mayito.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MiTema.bggris,
      appBar: AppBar(
        backgroundColor: MiTema.bggris,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        title: const Text(
          'HomeHive',
          style: TextStyle(
            color: MiTema.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'Solicitudes',
              style: TextStyle(
                color: MiTema.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: solicitudesList.length,
              itemBuilder: (context, index) {
                final solicitud = solicitudesList[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: MiTema.cart,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: MiTema.gris,
                            ),
                            child: const Icon(
                              Icons.person,
                              color: Colors.grey,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  solicitud['nombre']!,
                                  style: TextStyle(
                                    color: MiTema.textPrimary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  solicitud['tipo']!,
                                  style: TextStyle(
                                    color: MiTema.textamarillo,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  solicitud['propiedad']!,
                                  style: TextStyle(
                                    color: MiTema.textPrimary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const VerSolicitud(),
                              ));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: MiTema.azulPrincipal,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Ver',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              '©2026 DevSquad',
              style: TextStyle(color: MiTema.textamarillo, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}