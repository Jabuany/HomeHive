import 'package:flutter/material.dart';
import 'package:homehive/main/mainPage.dart';
import 'package:homehive/theme/tema.dart';

class VerSolicitud extends StatelessWidget {
  const VerSolicitud({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MiTema.bggris,
      appBar: AppBar(
        backgroundColor: MiTema.bggris,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          'HomeHive',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: MiTema.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Container(
                  constraints: BoxConstraints(maxWidth: 400),
                  padding: const EdgeInsets.symmetric(
                    vertical: 60,
                    horizontal: 30,
                  ),
                  decoration: BoxDecoration(
                    color: MiTema.cart,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: MiTema.gris, blurRadius: 10)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 30),
                          child: Text(
                            'Pauline Lenoir',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Informacion('Nombre', 'Pauline Lenoir magninton'),
                      Informacion('Número de habitantes', '3'),
                      Informacion('Curp', 'LOCK042301CSSMNA1'),
                      Informacion('Teléfono', '9191784400'),
                      Informacion(
                        'Mensaje',
                        'Buen día, quisiera rentar esta propiedad, me interesaría saber si existe algún contrato, como también el reglamento quedo atenta a su respuesta. Saludos cordiales',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 140,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const MainPage(),
                              ));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 95, 65),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Aprobar',
                    style: TextStyle(color: MiTema.cart, fontSize: 16),
                  ),
                ),
              ),
              SizedBox(
                width: 140,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const MainPage(),
                              ));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MiTema.azulPrincipal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Rechazar',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 45),
        ],
      ),
    );
  }
}

Widget Informacion(String title, String contenido) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 24.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: MiTema.textPrimary,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          contenido,
          style: TextStyle(
            fontSize: 16,
            color: MiTema.textPrimary,
            height: 1.4,
          ),
        ),
      ],
    ),
  );
}
