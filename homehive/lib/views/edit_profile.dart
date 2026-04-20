
import 'package:flutter/material.dart';
import 'package:homehive/config/config.dart';
import 'package:homehive/theme/tema.dart';
import 'package:homehive/services/users.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HomeHive',
      theme: MiTema.temaApp(context),
      home: const EditProfile(),
    );
  }
}

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formkey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = UserService.currentUser?['name'] ?? '';
    _emailController.text = UserService.currentUser?['email'] ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 30),
            decoration: BoxDecoration(
              color: MiTema.cart,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: MiTema.gris, blurRadius: 10)],
            ),
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
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
                            ? const Icon(
                                Icons.person,
                                size: 40,
                                color: Colors.grey,
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 4,
                        right: -10,
                        child: const Icon(
                          Icons.edit_outlined,
                          size: 25,
                          color: MiTema.textPrimary,
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
                        controller: _nameController,
                        decoration: const InputDecoration(hintText: 'Nombre'),
                      ),

                      const SizedBox(height: 30),

                      const Text(
                        'Correo electrónico',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),

                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          hintText: 'correo electrónico',
                        ),
                      ),

                      const SizedBox(height: 30),

                      const Text(
                        'Contraseña',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),

                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.visibility_off_outlined),
                        ),
                      ),

                      const SizedBox(height: 30),

                      const Text(
                        'Confirmar contraseña',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),

                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.visibility_off_outlined),
                        ),
                      ),

                      const SizedBox(height: 50),

                      Center(
                        child: SizedBox(
                          width: 120,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : () async {
                                    if (!_formkey.currentState!.validate()) {
                                      return;
                                    }

                                    if (_passwordController.text !=
                                        _confirmPasswordController.text) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Las contraseñas no coinciden',
                                          ),
                                        ),
                                      );
                                      return;
                                    }

                                    setState(() => _isLoading = true);

                                    try {
                                      await UserService.update(
                                        _nameController.text,
                                        _emailController.text,
                                        _passwordController.text.isEmpty ? "" : _passwordController.text);

                                      UserService.currentUser?['name'] = _nameController.text;
                                      UserService.currentUser?['email'] = _emailController.text;

                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Perfil actualizado'),
                                        ),
                                      );

                                      Navigator.pop(context);
                                    } catch (e) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Error: ${e.toString()}',
                                          ),
                                        ),
                                      );
                                    } finally {
                                      setState(() => _isLoading = false);
                                    }
                                  },
                            child: _isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator( 
                                      strokeWidth: 2,
                                    ),
                                )
                                : const Text('Guardar'),
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
    );
  }
}
