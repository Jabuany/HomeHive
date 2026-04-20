import 'package:flutter/material.dart';
import 'package:homehive/config/config.dart';
import 'package:homehive/theme/tema.dart';
import 'package:homehive/services/users.dart';
import 'edit_profile.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HomeHive',
      theme: MiTema.temaApp(context),
      home: const ProfileView(),
    );
  }
}

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() {
    _nameController.text = UserService.currentUser?['name'] ?? '';
    _emailController.text = UserService.currentUser?['email'] ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _goToEdit() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EditProfile()),
    );

    setState(() {
      _loadUser(); // recarga datos actualizados
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pushReplacementNamed(context, '/inicio');
          }
        ),
        title: Text(
          'HomeHive',
          style: TextStyle(
            color: MiTema.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 25),
          constraints: const BoxConstraints(maxWidth: 380),
          decoration: BoxDecoration(
            color: MiTema.cart,
            borderRadius: BorderRadius.circular(25),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[200],
                    backgroundImage:
                        (UserService.currentUser?['avatar'] != null &&
                            UserService.currentUser!['avatar']
                                .toString()
                                .isNotEmpty)
                        ? NetworkImage(
                            "${Config.baseUrl}/storage/${UserService.currentUser!['avatar']}",
                          )
                        : null,
                    child:
                        (UserService.currentUser?['avatar'] == null ||
                            UserService.currentUser!['avatar']
                                .toString()
                                .isEmpty)
                        ? const Icon(Icons.person, size: 40, color: Colors.grey)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.edit, size: 18),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Nickname',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 5),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(bottom: 5),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey)),
                ),
                child: Text(
                  _nameController.text,
                  style: const TextStyle(fontSize: 16),
                ),
              ),

              const SizedBox(height: 25),

              /// EMAIL
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Correo Electrónico',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 5),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(bottom: 5),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey)),
                ),
                child: Text(
                  _emailController.text,
                  style: const TextStyle(fontSize: 16),
                ),
              ),

              const SizedBox(height: 40),

              /// BOTÓN EDITAR
              SizedBox(
                width: 120,
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _goToEdit,
                  child: const Text(
                    'Editar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                '©2026 DevSquad',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
