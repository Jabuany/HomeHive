import 'package:flutter/material.dart';
import 'package:homehive/theme/tema.dart';
import 'package:homehive/main/mainPage.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          clipBehavior: Clip.none,
                          children: [
                            const CircleAvatar(
                              radius: 60,
                              backgroundImage: AssetImage('assets/logosnf.png'),
                            ),
                            Positioned(
                              bottom: 4,
                              right: -10,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                child: const Icon(
                                  Icons.edit_outlined,
                                  size: 25,
                                  color: MiTema.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 40),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Nickname',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              decoration: const InputDecoration(
                                hintText: 'Carol',
                              ),
                            ),
                            const SizedBox(height: 30),
                            Text(
                              'Correo electronico',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              decoration: const InputDecoration(
                                hintText: 'Carohel12@gmail.com',
                              ),
                            ),
                            const SizedBox(height: 30),
                            Text(
                              'Contraseña',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              decoration: const InputDecoration(
                                hintText: '********',
                                suffixIcon: Icon(Icons.visibility_off_outlined),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Text(
                              'Confirmar contraseña',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              decoration: const InputDecoration(
                                hintText: '********',
                                suffixIcon: Icon(Icons.visibility_off_outlined),
                              ),
                            ),
                            const SizedBox(height: 50),
                            Center(
                              child: SizedBox(
                                width: 120,
                                height: 40,
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
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 2,
                                  ),
                                  child: const Text(
                                    'Guardar',
                                    style: TextStyle(color: MiTema.cart),
                                  ),
                                ),
                              ),
                            ),
                          ],
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
