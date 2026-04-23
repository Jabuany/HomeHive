import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:homehive/theme/tema.dart';
import 'package:homehive/config/config.dart';
import 'package:homehive/services/users.dart';
import 'package:homehive/main/solicitudrenta.dart'; 
import 'package:homehive/menu/menu.dart'; 
// import 'package:url_launcher/url_launcher.dart';
// 1. IMPORTA TU NUEVA VISTA DE PAGO (Asegúrate de que la ruta sea correcta)
import 'package:homehive/inquilino/pagos.dart'; 

class MisSolicitudesPage extends StatefulWidget {
  const MisSolicitudesPage({super.key});

  @override
  State<MisSolicitudesPage> createState() => _MisSolicitudesPageState();
}

class _MisSolicitudesPageState extends State<MisSolicitudesPage> {
  List<dynamic> solicitudes = [];
  bool _cargando = true;

  // Fechas dinámicas: desde el día 1 del mes actual hasta hoy
  DateTime fechaDesde = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime fechaHasta = DateTime.now();

  @override
  void initState() {
    super.initState();
    _inicializar();
  }

  Future<void> _inicializar() async {
    await UserService.obtenerUsuarioLocal(); 
    await _obtenerSolicitudesReales();
  }

  // Abre el selector de fecha nativo
  Future<void> _abrirCalendario(BuildContext context, bool esDesde) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: esDesde ? fechaDesde : fechaHasta,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      helpText: esDesde ? 'SOLICITUDES DESDE' : 'SOLICITUDES HASTA',
    );
    
    if (picked != null) {
      setState(() {
        if (esDesde) {
          fechaDesde = picked;
        } else {
          fechaHasta = picked;
        }
      });
      _obtenerSolicitudesReales();
    }
  }

  // Obtiene las solicitudes filtradas por fecha
  Future<void> _obtenerSolicitudesReales() async {
    setState(() => _cargando = true);
    try {
      final token = await UserService.obtenerToken();
      
      String desdeStr = "${fechaDesde.year}-${fechaDesde.month.toString().padLeft(2, '0')}-${fechaDesde.day.toString().padLeft(2, '0')}";
      String hastaStr = "${fechaHasta.year}-${fechaHasta.month.toString().padLeft(2, '0')}-${fechaHasta.day.toString().padLeft(2, '0')}";

      final response = await http.get(
        Uri.parse('${Config.baseUrl}/api/mis-solicitudes?desde=$desdeStr&hasta=$hastaStr'),
        headers: {
          'Authorization': 'Bearer $token', 
          'Accept': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          solicitudes = json.decode(response.body);
          _cargando = false;
        });
      } else {
        setState(() => _cargando = false);
      }
    } catch (e) {
      setState(() => _cargando = false);
    }
  }

  // 2. LÓGICA DE PAGO ACTUALIZADA PARA USAR EL WEBVIEW INTERNO
  Future<void> _procesarPago(int solicitudId) async {
    setState(() => _cargando = true);
    try {
      final token = await UserService.obtenerToken();
      final urlApi = Uri.parse('${Config.baseUrl}/api/pagos/checkout/$solicitudId');
      
      print("Enviando solicitud de pago para ID: $solicitudId");

      final res = await http.post(
        urlApi, 
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final String stripeUrl = data['url'];

        // 3. EN LUGAR DE ABRIR NAVEGADOR EXTERNO, ABRIMOS NUESTRO WEBVIEW
        final bool? pagado = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PantallaPagoWebView(url: stripeUrl),
          ),
        );

        // 4. SI REGRESÓ CON 'TRUE' (Detectado por el interceptor de URL), REFRESCAMOS
        if (pagado == true) {
          _notificar("¡Pago realizado con éxito!");
          _obtenerSolicitudesReales(); 
        }
      } else {
        print("Error del servidor: ${res.body}"); 
        _notificar("Error: No se pudo generar la sesión de pago", isError: true);
      }
    } catch (e) {
      print("Error de red o configuración: $e");
      _notificar("Error de conexión al intentar pagar", isError: true);
    } finally {
      setState(() => _cargando = false);
    }
  }

  void _notificar(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: isError ? MiTema.rojo : Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MiTema.lilaFondo, 
      drawer: menu(context), 
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
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          const Text("Solicitudes", 
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400, color: MiTema.textPrimary)),
          const SizedBox(height: 15),
          
          // Barra de Filtros
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: MiTema.cart,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
            ),
            child: Row(
              children: [
                _buildInputFecha("Desde", fechaDesde, true),
                const SizedBox(width: 10),
                _buildInputFecha("Hasta", fechaHasta, false),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.search, size: 30, color: MiTema.azulPrincipal),
                  onPressed: _obtenerSolicitudesReales,
                ),
              ],
            ),
          ),

          Expanded(
            child: _cargando
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _obtenerSolicitudesReales,
                    child: solicitudes.isEmpty
                        ? const Center(child: Text("Sin solicitudes en este rango"))
                        : ListView.builder(
                            padding: const EdgeInsets.all(20),
                            itemCount: solicitudes.length,
                            itemBuilder: (context, i) => _card(solicitudes[i]),
                          ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputFecha(String label, DateTime fechaActual, bool esDesde) {
    return Expanded(
      child: InkWell(
        onTap: () => _abrirCalendario(context, esDesde),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: MiTema.textPrimary)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: MiTema.border),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_month, size: 16, color: MiTema.indigoIconos),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      "${fechaActual.day.toString().padLeft(2, '0')}/${fechaActual.month.toString().padLeft(2, '0')}/${fechaActual.year}", 
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down, size: 18, color: MiTema.indigoIconos),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card(dynamic sol) {
    final bool esPropietario = UserService.currentUser?['role'] == 'propietario';
    return esPropietario ? _cardArrendador(sol) : _cardInquilino(sol);
  }

  Widget _cardArrendador(dynamic sol) {
    final aspirante = sol['aspirante'] ?? {};
    final propiedad = sol['propiedad'] ?? {};
    String nombreAspirante = aspirante['name'] ?? 'Usuario';
    String nombrePropiedad = (propiedad is Map) ? (propiedad['titulo'] ?? 'Sin título') : propiedad.toString();
    String? avatar = aspirante['avatar'];

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: MiTema.cart,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: MiTema.gris,
            backgroundImage: (avatar != null && avatar.isNotEmpty)
                ? NetworkImage("${Config.baseUrl}/storage/$avatar") 
                : null,
            child: (avatar == null || avatar.isEmpty) ? const Icon(Icons.person, size: 40) : null,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nombreAspirante, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Text("Propiedad:", style: TextStyle(fontSize: 10, color: MiTema.textamarillo)),
                Text(nombrePropiedad, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: MiTema.azulPrincipal)),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: MiTema.azulPrincipal),
            onPressed: () async {
              final res = await Navigator.push(context, MaterialPageRoute(
                builder: (_) => DetalleSolicitudPage(solicitud: sol)));
              if (res == true) _obtenerSolicitudesReales();
            },
            child: const Text("Ver", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _cardInquilino(dynamic sol) {
    String nombreProp = sol['propiedad'] is Map ? (sol['propiedad']['titulo'] ?? 'Sin título') : sol['propiedad'].toString();
    String fecha = sol['created_at']?.toString().split('T')[0] ?? 'N/A';
    bool esAceptada = sol['estatus'].toString().toLowerCase() == 'aceptado';

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: MiTema.cart, 
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        children: [
          Row(children: [
            Expanded(child: _info("Propiedad", nombreProp)),
            Container(height: 60, width: 1, color: MiTema.border),
            Expanded(child: _info("Precio", "\$${sol['precio']}")),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: _info("Fecha Solicitud", fecha)),
            Container(height: 60, width: 1, color: MiTema.border),
            Expanded(child: _info("Estado", sol['estatus'] ?? 'Pendiente')),
          ]),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: MiTema.verde),
                onPressed: () async {
                  final res = await Navigator.push(context, MaterialPageRoute(
                    builder: (_) => DetalleSolicitudPage(solicitud: sol)));
                  if (res == true) _obtenerSolicitudesReales();
                },
                child: const Text("Ver solicitud", style: TextStyle(color: Colors.white)),
              ),
              if (esAceptada)
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: MiTema.indigoIconos),
                  icon: const Icon(Icons.payment, color: Colors.white, size: 18),
                  label: const Text("Pagar", style: TextStyle(color: Colors.white)),
                  onPressed: () => _procesarPago(sol['id']), 
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _info(String t, String v) => Column(children: [
    Text(t, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: MiTema.textPrimary)),
    const SizedBox(height: 4),
    Text(v, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, style: const TextStyle(color: MiTema.textPrimary)),
  ]);
}