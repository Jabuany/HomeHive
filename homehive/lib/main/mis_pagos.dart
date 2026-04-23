// import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

// Tus imports de configuración y tema
import 'package:homehive/theme/tema.dart';
import 'package:homehive/config/config.dart';
import 'package:homehive/services/users.dart';
import 'package:homehive/menu/menu.dart';

class MisPagosPage extends StatefulWidget {
  const MisPagosPage({super.key});

  @override
  State<MisPagosPage> createState() => _MisPagosPageState();
}

class _MisPagosPageState extends State<MisPagosPage> {
  List<dynamic> pagos = [];
  bool _cargando = true;

  // Fechas para el filtro (Mes actual por defecto)
  DateTime fechaDesde = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime fechaHasta = DateTime.now();

  @override
  void initState() {
    super.initState();
    _obtenerPagos();
  }

  // --- FUNCIONES DE APOYO ---

  void _notificar(String msg, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? MiTema.rojo : Colors.green,
      ),
    );
  }

  Future<void> _abrirCalendario(BuildContext context, bool esDesde) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: esDesde ? fechaDesde : fechaHasta,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      helpText: esDesde ? 'PAGOS DESDE' : 'PAGOS HASTA',
    );

    if (picked != null) {
      setState(() {
        if (esDesde) {
          fechaDesde = picked;
        } else {
          fechaHasta = picked;
        }
      });
      _obtenerPagos();
    }
  }

  // --- PETICIONES API ---

  Future<void> _obtenerPagos() async {
    setState(() => _cargando = true);
    try {
      final token = await UserService.obtenerToken();
      String desdeStr = "${fechaDesde.year}-${fechaDesde.month.toString().padLeft(2, '0')}-${fechaDesde.day.toString().padLeft(2, '0')}";
      String hastaStr = "${fechaHasta.year}-${fechaHasta.month.toString().padLeft(2, '0')}-${fechaHasta.day.toString().padLeft(2, '0')}";

      final response = await http.get(
        Uri.parse('${Config.baseUrl}/api/mis-pagos?desde=$desdeStr&hasta=$hastaStr'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          pagos = json.decode(response.body);
          _cargando = false;
        });
      } else {
        setState(() => _cargando = false);
      }
    } catch (e) {
      setState(() => _cargando = false);
      _notificar("Error al conectar con el servidor", isError: true);
    }
  }

  // --- DESCARGA DE DOCUMENTOS ---

  Future<void> _descargarDocumento(int pagoId, String tipo) async {
    setState(() => _cargando = true);
    try {
      final token = await UserService.obtenerToken();
      // 'tipo' puede ser 'recibo' o 'contrato' según la ruta en Laravel
      final String urlPdf = "${Config.baseUrl}/api/pagos/$tipo/$pagoId";
      
      final dir = await getApplicationDocumentsDirectory();
      final String nombreArchivo = "${dir.path}/${tipo}_homehive_$pagoId.pdf";

      await Dio().download(
        urlPdf, 
        nombreArchivo,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/pdf',
          },
          followRedirects: true,
        ),
      );

      final result = await OpenFilex.open(nombreArchivo);
      
      if (result.type != ResultType.done) {
        _notificar("No se encontró una app para abrir el PDF", isError: true);
      }
    } catch (e) {
      print("Error en $tipo: $e");
      _notificar("Error al descargar el $tipo", isError: true);
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  // --- DISEÑO ---

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
          const SizedBox(height: 15),
          const Text("Mis Pagos Realizados", 
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: MiTema.textPrimary)),
          const SizedBox(height: 15),
          
          _buildBarraFiltros(),

          Expanded(
            child: _cargando 
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: _obtenerPagos,
                  child: pagos.isEmpty 
                    ? const Center(child: Text("No se encontraron pagos registrados"))
                    : ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: pagos.length,
                        itemBuilder: (context, i) => _cardPago(pagos[i]),
                      ),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarraFiltros() {
    return Container(
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
          IconButton(
            icon: const Icon(Icons.search, color: MiTema.azulPrincipal),
            onPressed: _obtenerPagos,
          ),
        ],
      ),
    );
  }

  Widget _buildInputFecha(String label, DateTime fecha, bool esDesde) {
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
                  Text("${fecha.day}/${fecha.month}/${fecha.year}", style: const TextStyle(fontSize: 11)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardPago(dynamic pago) {
    String titulo = pago['propiedad']?['titulo'] ?? 'Pago de Renta';
    String monto = "\$${pago['monto']}";
    String fecha = pago['fecha_pago'] ?? pago['created_at'].toString().split('T')[0];

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: MiTema.cart,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
              Text(monto, style: const TextStyle(color: MiTema.azulPrincipal, fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const Icon(Icons.access_time, size: 14, color: Colors.grey),
              const SizedBox(width: 5),
              Text(fecha, style: const TextStyle(color: Colors.grey, fontSize: 13)),
            ],
          ),
          const Divider(height: 25),
          Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Estatus: Pagado", 
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: MiTema.indigoIconos),
                      onPressed: () => _descargarDocumento(pago['id'], 'recibo'),
                      icon: const Icon(Icons.receipt_long, size: 18, color: Colors.white),
                      label: const Text("Recibo", style: TextStyle(color: Colors.white, fontSize: 11)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: MiTema.azulPrincipal),
                      onPressed: () => _descargarDocumento(pago['id'], 'contrato'),
                      icon: const Icon(Icons.description, size: 18, color: Colors.white),
                      label: const Text("Contrato", style: TextStyle(color: Colors.white, fontSize: 11)),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}