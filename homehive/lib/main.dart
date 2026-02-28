import 'package:flutter/material.dart';
import 'package:homehive/inquilino/favoritos.dart';
import 'package:homehive/main/chat.dart';
import 'package:homehive/main/mainPage.dart';
import 'package:homehive/main/vermas.dart';
import 'package:homehive/services/users.dart';
import 'package:homehive/views/notificaciones_solicitudes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme/tema.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: MiTema.temaApp(context),
      title: 'HomeHive',
      home: const Login(),
      routes: {
        '/login': (context) => const Login(),
        '/inicio': (context) => const MainPage(),
        '/favoritos': (context) => const Favorite(),
        '/vermas': (context) => const VerMas(),
        '/chat': (context) => const Chat(),
        '/notificaciones': (context) => const NotificacionesSolicitudes(),
      },
    );
  }
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _ingresar() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _mostrarError('Todos los campos son obligatorios');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await UserService.login(email, password);

      if (response['success'] == true) {
        final token = response['data']['token'];
        final prefs = await SharedPreferences.getInstance();

        //esto guarda el token y el usuario en la clase UserService para que esté disponible globalmente, esto es nos va a servir para el menú en el drawe, en la modificación de datos del usuario y en el chat.
        UserService.token = token;
        UserService.currentUser = response['data']['user'];

        await prefs.setString('token', token);
        final user = response['data']['user'];

        print("TOKEN: $token");
        print("USER: $user");

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Inicio de sesión exitoso'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.of(context).pushReplacementNamed('/inicio');
      } else {
        _mostrarError('Credenciales incorrectas');
      }
    } catch (e) {
      print("ERROR COMPLETO: $e");
      _mostrarError('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _mostrarError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error), backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 90),
          child: _cuerpo(),
        ),
      ),
    );
  }

  Widget _cuerpo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'HomeHive',
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        _columna(),
      ],
    );
  }

  Widget _columna() {
    return Card(
      color: MiTema.cart,
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Text(
              'Inicia Sesión',
              style: TextStyle(
                color: MiTema.textPrimary,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            _buildInputField(
              'Correo o Usuario',
              _emailController,
              false,
              'emailField',
            ),
            const SizedBox(height: 20),
            _buildInputField(
              'Contraseña',
              _passwordController,
              true,
              'passwordField',
            ),
            const SizedBox(height: 30),
            _botoniniciosesion(),
            const SizedBox(height: 30),
            Text(
              '¿No tienes una cuenta?',
              style: TextStyle(color: MiTema.textamarillo, fontSize: 18),
            ),
            Text(
              'Regístrate aquí',
              style: TextStyle(
                color: MiTema.azulPrincipal,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller,
    bool isPassword,
    String keyName,
  ) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.80,
      decoration: BoxDecoration(
        color: MiTema.bggris,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: MiTema.border),
      ),
      child: TextField(
        key: Key(keyName),
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 15,
          ),
          border: InputBorder.none,
          labelStyle: TextStyle(color: MiTema.textamarillo),
        ),
      ),
    );
  }

  Widget _botoniniciosesion() {
    return ElevatedButton(
      key: const Key('loginButton'),
      onPressed: _isLoading ? null : _ingresar,
      style: ElevatedButton.styleFrom(
        backgroundColor: MiTema.azulPrincipal,
        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: _isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : const Text(
              'Iniciar Sesión',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
    );
  }
}
