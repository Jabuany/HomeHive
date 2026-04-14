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
  late TextEditingController nombreCtrl;
  late TextEditingController precioCtrl;
  late TextEditingController reglasCtrl;
  late TextEditingController descripcionCtrl;

  String tipoSeleccionado = "cuarto";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    nombreCtrl = TextEditingController();
    precioCtrl = TextEditingController();
    reglasCtrl = TextEditingController();
    descripcionCtrl = TextEditingController();

    cargarPropiedad();
  }

  Future<void> cargarPropiedad() async {
    try {
      print("PROP RECIBIDA:");
      print(widget.prop);

      final int? id = widget.prop['id'] is int
          ? widget.prop['id']
          : int.tryParse(widget.prop['id']?.toString() ?? '');

      if (id == null) {
        throw Exception("ID inválido o null");
      }

      final data = await PropiedadService.getPropiedad(id);

      setState(() {
        nombreCtrl.text = data['titulo'] ?? '';
        precioCtrl.text = data['precio']?.toString() ?? '';
        reglasCtrl.text = data['reglas'] ?? '';
        descripcionCtrl.text = data['descripcion'] ?? '';

        String servicio = data['servicio']?.toString().toLowerCase() ?? '';

        if (servicio.contains("cuarto")) {
          tipoSeleccionado = "cuarto";
        } else if (servicio.contains("casa")) {
          tipoSeleccionado = "casa";
        } else if (servicio.contains("departamento")) {
          tipoSeleccionado = "departamento";
        } else {
          tipoSeleccionado = "cuarto";
        }

        isLoading = false;
      });
    } catch (e) {
      print("ERROR: $e");
    }
  }

  @override
  void dispose() {
    nombreCtrl.dispose();
    precioCtrl.dispose();
    reglasCtrl.dispose();
    descripcionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: MiTema.bggris,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'HomeHive',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: MiTema.textPrimary,
          ),
        ),
        leading: const BackButton(color: MiTema.textPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: MiTema.cart,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Modificación de propiedades",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              _input("Nombre", nombreCtrl),
              _input("Precio", precioCtrl, isNumber: true),

              const SizedBox(height: 10),

              DropdownButtonFormField<String>(
                value: tipoSeleccionado,
                decoration: _inputDecoration(),
                items: ["cuarto", "casa", "departamento"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    tipoSeleccionado = value!;
                  });
                },
              ),

              const SizedBox(height: 10),

              _input("Reglas", reglasCtrl),
              _input("Descripción", descripcionCtrl),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MiTema.azulPrincipal,
                  ),
                  onPressed: () async {
                    try {
                      String token = await UserService.obtenerToken();

                      bool ok = await PropiedadService.updatePropiedad(
                        widget.prop['id'],
                        nombreCtrl.text,
                        precioCtrl.text,
                        tipoSeleccionado,
                        reglasCtrl.text,
                        descripcionCtrl.text,
                        token,
                      );

                      if (ok) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Actualizado correctamente"),
                          ),
                        );
                        Navigator.pop(context);
                      } else {
                        throw Exception("Error update");
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("Error: $e")));
                    }
                  },
                  child: const Text("Guardar cambios"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _input(
    String label,
    TextEditingController controller, {
    bool isNumber = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: _inputDecoration(),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: MiTema.bggris,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
    );
  }
}
