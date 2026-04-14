import 'package:flutter/material.dart';
import 'package:homehive/theme/tema.dart';

class DetalleSolicitudPage extends StatelessWidget {
  final dynamic solicitud;

  const DetalleSolicitudPage({super.key, required this.solicitud});

  @override
  Widget build(BuildContext context) {
    final estado = solicitud['estado'] ?? 'Pendiente';

    return Scaffold(
      backgroundColor: MiTema.gris,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            children: [
              const Text(
                'HomeHive',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              _card(context, estado),
            ],
          ),
        ),
      ),
    );
  }

  Widget _card(BuildContext context, String estado) {
    return Card(
      color: MiTema.cart,
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Solicitud de renta",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: estado == 'Aceptado' ? Colors.green : Colors.amber,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    estado,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            const Divider(),

            Row(
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage('assets/user.png'),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      solicitud['usuario_nombre'] ?? 'Usuario',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      solicitud['usuario_tipo'] ?? '',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            _fila(Icons.bed, solicitud['personas']?.toString() ?? '0'),
            _fila(Icons.calendar_today, solicitud['fecha'] ?? ''),
            _fila(Icons.phone, solicitud['telefono'] ?? ''),
            _fila(Icons.credit_card, solicitud['ine'] ?? ''),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: MiTema.bggris,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Mensaje",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  Text(
                    solicitud['mensaje'] ?? 'Sin mensaje',
                    style: const TextStyle(color: Colors.black87),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _fila(IconData icon, String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 10),
          Text(texto),
        ],
      ),
    );
  }
}
