import 'package:flutter/material.dart';
import 'package:homehive/inquilino/favoritos.dart';
import 'package:homehive/main/chat.dart';
import 'package:homehive/main/mainPage.dart';
import 'package:homehive/main/vermas.dart';
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
      home: Login(),
      routes: {
        '/inicio': (context) => const MainPage(),
        '/favoritos': (context) => const Favorite(),
        '/vermas': (context) => const VerMas(),
        '/chat': (context) => const Chat(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 90),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'HomeHive',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              _columna(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _columna() {
    return Card(
      color: MiTema.cart,
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween),
          const SizedBox(height: 60),
          Text(
            'Inicia Sesión',
            style: TextStyle(
              color: MiTema.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildInputField('Correo Electrónico', _emailController, false),
          const SizedBox(height: 20),
          _buildInputField('Contraseña', _passwordController, true),
          const SizedBox(height: 10),
          Text(
            '¿Olvidaste tu contraseña?',
            style: TextStyle(color: MiTema.azulPrincipal, fontSize: 14),
          ),
          const SizedBox(height: 30),
          _botoniniciosesion(),
          const SizedBox(height: 30),
          Text(
            '¿No tienes una cuenta?',
            style: TextStyle(color: MiTema.textamarillo, fontSize: 22),
          ),
          Text(
            'Regístrate aquí',
            style: TextStyle(color: MiTema.azulPrincipal, fontSize: 22),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller,
    bool isPassword,
  ) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.80,
      decoration: BoxDecoration(
        color: MiTema.bggris,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: MiTema.border),
      ),
      child: TextField(
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
      onPressed: () {
        _ingresar();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: MiTema.azulPrincipal,
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: const Text(
        'Iniciar Sesión',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: MiTema.bggris,
        ),
      ),
    );
  }
  void _ingresar() {
    String txt = 'Usuario y/o contraseña incorrectos';
    if (_emailController.text == "admin" &&
        _passwordController.text == "admin123") {
      txt = 'Bienvenido';
      Navigator.of(context).pushNamed('/inicio');
    }
    SnackBar msj = SnackBar(content: Text(txt));
    ScaffoldMessenger.of(context).showSnackBar(msj);
  }
}
