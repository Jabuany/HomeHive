import 'package:flutter/material.dart';
import 'package:homehive/main/mainPage.dart';
import 'package:homehive/theme/tema.dart';

class Rentar extends StatelessWidget {
  const Rentar({super.key});

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
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment
                          .start, 
                      children: [
                        const SizedBox(height: 20),

                        const Text(
                          'Nombre',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Divider(
                          thickness: 1,
                          color: Colors.black54,
                        ), 
                        const SizedBox(height: 20),

                        const Text(
                          'Numero de habitantes',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Divider(thickness: 1, color: Colors.black54),
                        const SizedBox(height: 20),

                        const Text(
                          'Curp',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Divider(thickness: 1, color: Colors.black54),
                        const SizedBox(height: 20),

                        const Text(
                          'Telefono',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Divider(thickness: 1, color: Colors.black54),
                        const SizedBox(height: 20),

                        const Text(
                          'Mensaje',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          maxLines:
                              4, 
                          decoration: InputDecoration(
                            hintText: 'Escriba un mensaje',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        Center(
                          child: SizedBox(
                            width: 150,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const MainPage(),
                                    ),
                                  );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: MiTema.azulPrincipal,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              child: const Text(
                                'Enviar',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
