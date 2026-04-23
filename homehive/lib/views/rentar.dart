import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:homehive/theme/tema.dart';
import 'package:homehive/config/config.dart';
import 'package:homehive/services/users.dart';
import 'package:homehive/main/solicitudes.dart';

class Rentar extends StatefulWidget {
  final dynamic prop; 
  const Rentar({super.key, required this.prop});

  @override
  State<Rentar> createState() => _RentarState();
}

class _RentarState extends State<Rentar> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _curpController = TextEditingController();
  final TextEditingController _edadController = TextEditingController();
  final TextEditingController _ocupacionController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _mensajeController = TextEditingController();

  bool _enviando = false;

  Future<void> _seleccionarFecha(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        _fechaController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _enviarSolicitud() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _enviando = true);

    try {
      final url = Uri.parse('${Config.baseUrl}/api/solicitudes/${widget.prop['id']}');
      final token = await UserService.obtenerToken();
      
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
        body: {
          'curp': _curpController.text,
          'edad': _edadController.text,
          'ocupacion': _ocupacionController.text,
          'fecha': _fechaController.text,
          'telefono': _telefonoController.text,
          'mensaje': _mensajeController.text,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(backgroundColor: Colors.green, content: Text("¡Solicitud enviada!")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MisSolicitudesPage()),
        );
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al conectar con el servidor")),
      );
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MiTema.bggris,
      appBar: AppBar(title: const Text('Rentar Propiedad'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _campoTexto("Curp", _curpController),
              _campoTexto("Edad", _edadController, keyboardType: TextInputType.number),
              _campoTexto("Ocupación", _ocupacionController),
              
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: TextFormField(
                  controller: _fechaController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: "Fecha (AAAA-MM-DD)",
                    hintText: "2026-05-15",
                    border: OutlineInputBorder(),
                  ),
                  onTap: () => _seleccionarFecha(context),
                  validator: (value) => value!.isEmpty ? "Este campo es obligatorio" : null,
                ),
              ),

              _campoTexto("Teléfono", _telefonoController, keyboardType: TextInputType.phone),
              _campoTexto("Mensaje", _mensajeController, maxLines: 3),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _enviando ? null : _enviarSolicitud,
                  style: ElevatedButton.styleFrom(backgroundColor: MiTema.azulPrincipal),
                  child: _enviando 
                    ? const CircularProgressIndicator(color: Colors.white) 
                    : const Text('Enviar Solicitud', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _campoTexto(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text, String? hint, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
        validator: (value) => value!.isEmpty ? "Este campo es obligatorio" : null,
      ),
    );
  }
}