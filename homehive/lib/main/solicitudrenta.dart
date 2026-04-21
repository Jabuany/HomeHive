import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:homehive/theme/tema.dart';
import 'package:homehive/config/config.dart';
import 'package:homehive/services/users.dart';

class DetalleSolicitudPage extends StatefulWidget {
  final dynamic solicitud;
  const DetalleSolicitudPage({super.key, required this.solicitud});

  @override
  State<DetalleSolicitudPage> createState() => _DetalleSolicitudPageState();
}

class _DetalleSolicitudPageState extends State<DetalleSolicitudPage> {
  bool _procesando = false;

  // FUNCIÓN CLAVE PARA ACEPTAR/RECHAZAR
  Future<void> _cambiarEstatus(String accion) async {
    setState(() => _procesando = true);
    try {
      final token = await UserService.obtenerToken();
      
      // Construimos la URL limpia
      final String baseUrl = Config.baseUrl.endsWith('/') 
          ? Config.baseUrl.substring(0, Config.baseUrl.length - 1) 
          : Config.baseUrl;
      
      final url = Uri.parse('$baseUrl/api/solicitudes/${widget.solicitud['id']}/$accion');
      
      final res = await http.post(url, headers: {
        'Authorization': 'Bearer $token', 
        'Accept': 'application/json'
      });

      if (res.statusCode == 200) {
        if (!mounted) return;
        
        // MENSAJE DE ÉXITO
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Solicitud ${accion == 'aceptar' ? 'aceptada' : 'rechazada'} con éxito"),
            backgroundColor: accion == 'aceptar' ? Colors.green : Colors.red,
          ),
        );

        // AQUÍ ESTÁ EL REFRESCO: Al cerrar mandamos 'true' a la pantalla anterior
        Navigator.pop(context, true);
      } else {
        final errorData = jsonDecode(res.body);
        _mostrarError(errorData['error'] ?? "Error al procesar la solicitud");
      }
    } catch (e) {
      _mostrarError("Error de conexión con el servidor");
    } finally {
      if (mounted) setState(() => _procesando = false);
    }
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sol = widget.solicitud;
    final bool esPropietario = UserService.currentUser?['role'] == 'propietario';
    final String? avatar = sol['aspirante']?['avatar'];

    // Validamos estatus para ocultar botones si ya no es pendiente
    final bool esPendiente = sol['estatus'].toString().toLowerCase() == 'pendiente';

    return Scaffold(
      backgroundColor: const Color(0xFFC5CAE9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('HomeHive', 
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24)),
        centerTitle: true,
      ),
      body: _procesando 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(35),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Solicitud de renta", 
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFDE68A),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(sol['estatus'] ?? 'Pendiente', 
                            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12)),
                        ),
                      ],
                    ),
                    const Divider(height: 30),

                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: (avatar != null && avatar.isNotEmpty)
                              ? NetworkImage("${Config.baseUrl}/storage/$avatar") 
                              : null,
                          child: (avatar == null || avatar.isEmpty) ? const Icon(Icons.person, size: 35) : null,
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(sol['aspirante']?['name'] ?? 'Usuario', 
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Text(sol['ocupacion'] ?? 'Estudiante universitario', 
                              style: const TextStyle(color: Colors.grey, fontSize: 14)),
                          ],
                        )
                      ],
                    ),

                    const SizedBox(height: 30),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _datoIcono(Icons.cake_outlined, "${sol['edad']} años"),
                        _datoIcono(Icons.calendar_month_outlined, sol['fecha']?.toString() ?? 'N/A'),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _datoIcono(Icons.phone_outlined, sol['telefono'] ?? 'N/A'),
                        _datoIcono(Icons.badge_outlined, sol['curp'] ?? 'N/A'),
                      ],
                    ),

                    const SizedBox(height: 25),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEEEEE),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Mensaje", 
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          const Divider(),
                          Text(sol['mensaje'] ?? 'Sin mensaje adicional.',
                            style: const TextStyle(color: Colors.black87, height: 1.4)),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // BOTONES DE ACCIÓN
                    if (esPropietario && esPendiente)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _botonAccion("Aceptar", const Color(0xFF065F46), () => _cambiarEstatus('aceptar')),
                          _botonAccion("Rechazar", const Color(0xFF991B1B), () => _cambiarEstatus('rechazar')),
                        ],
                      ),
                    
                    if (esPropietario && !esPendiente)
                       const Center(
                         child: Text("Solicitud ya procesada", 
                           style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
                       ),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  Widget _datoIcono(IconData icon, String texto) {
    return SizedBox(
      width: 140,
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.indigo[900]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(texto, 
              style: const TextStyle(fontSize: 13, color: Colors.black87),
              overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  Widget _botonAccion(String texto, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 5,
      ),
      onPressed: onPressed,
      child: Text(texto, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }
}