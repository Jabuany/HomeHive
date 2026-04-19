import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:homehive/services/propserv.dart';
import 'package:homehive/services/users.dart';
import 'package:homehive/theme/tema.dart';

class EditarPropiedadPage extends StatefulWidget {
  final dynamic prop;

  const EditarPropiedadPage({super.key, required this.prop});

  @override
  State<EditarPropiedadPage> createState() => _EditarPropiedadPageState();
}

class _EditarPropiedadPageState extends State<EditarPropiedadPage> {
  final TextEditingController nombreCtrl = TextEditingController();
  final TextEditingController precioCtrl = TextEditingController();
  final TextEditingController reglasCtrl = TextEditingController();
  final TextEditingController descripcionCtrl = TextEditingController();
  final TextEditingController cercaniasCtrl = TextEditingController();

  String tipoSeleccionado = "cuarto";
  String formaPago = "transferencia";
  List<String> servicios = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    cargarPropiedad();
  }

  void cargarPropiedad() {
    final data = widget.prop;

    nombreCtrl.text = data['titulo'] ?? '';
    precioCtrl.text = data['precio']?.toString() ?? '';
    reglasCtrl.text = data['reglas'] ?? '';
    descripcionCtrl.text = data['descripcion'] ?? '';
    cercaniasCtrl.text = data['cercanias'] ?? '';

    tipoSeleccionado = data['tipo'] ?? "cuarto";

    formaPago =
        (data['forma_pago'] != null && data['forma_pago'].toString().isNotEmpty)
        ? data['forma_pago']
        : "transferencia";

    if (data['servicio'] != null && data['servicio'] is String) {
      servicios = List<String>.from(jsonDecode(data['servicio']));
    } else if (data['servicio'] is List) {
      servicios = List<String>.from(data['servicio']);
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: MiTema.bggris,
      appBar: AppBar(title: const Text("Editar Propiedad")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _input("Nombre", nombreCtrl, "input_nombre"),
            _input("Precio", precioCtrl, "input_precio", isNumber: true),
            _input("Reglas", reglasCtrl, "input_reglas"),
            _input("Descripción", descripcionCtrl, "input_descripcion"),
            _input("Cercanías", cercaniasCtrl, "input_cercanias"),

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              value: tipoSeleccionado,
              decoration: _decoration("Tipo"),
              items: const [
                DropdownMenuItem(value: "cuarto", child: Text("cuarto")),
                DropdownMenuItem(value: "casa", child: Text("casa")),
                DropdownMenuItem(
                  value: "departamento",
                  child: Text("departamento"),
                ),
              ],
              onChanged: (v) => setState(() => tipoSeleccionado = v!),
            ),

            const SizedBox(height: 25),

            Semantics(
              label: "btn_guardar",
              child: ElevatedButton(
                onPressed: () async {
                  String token = await UserService.obtenerToken();

                  final result = await PropiedadService.updatePropiedad(
                    widget.prop['id'],
                    nombreCtrl.text,
                    precioCtrl.text,
                    tipoSeleccionado,
                    reglasCtrl.text,
                    descripcionCtrl.text,
                    token,
                    formaPago,
                    servicios,
                    cercaniasCtrl.text,
                  );

                  if (result["ok"]) {
                    Navigator.pop(context, true);
                  }
                },
                child: const Text("Guardar cambios"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _input(
    String label,
    TextEditingController ctrl,
    String id, {
    bool isNumber = false,
  }) {
    return Semantics(
      label: id,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextField(
          controller: ctrl,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(labelText: label),
        ),
      ),
    );
  }

  InputDecoration _decoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: MiTema.bggris,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
    );
  }
}
