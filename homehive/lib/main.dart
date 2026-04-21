import 'package:flutter/material.dart';
import 'package:homehive/config/config.dart';
import 'package:homehive/inquilino/favoritos.dart';
import 'package:homehive/main/listchat.dart';
import 'package:homehive/main/mainPage.dart';
import 'package:homehive/main/solicitudes.dart';
import 'package:homehive/propietario/mispropiedades.dart';
import 'package:homehive/services/users.dart';
import 'package:homehive/views/notificaciones_solicitudes.dart';
import 'package:app_links/app_links.dart';
import 'package:homehive/views/perfil.dart';
import 'theme/tema.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  print("📩 Mensaje en background: ${message.notification?.title}");
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

late AndroidNotificationChannel channel;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await FirebaseMessaging.instance.requestPermission();

  channel = const AndroidNotificationChannel(
    'channel_id',
    'channel_name',
    description: 'Canal de notificaciones de HomeHive',
    importance: Importance.max,
  );

  final androidPlugin = flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();

  await androidPlugin?.createNotificationChannel(channel);

  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

  await flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    ),
  );

FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    final data = message.data;

    final title = (data['title'] ?? '').toString().isNotEmpty
        ? data['title'].toString()
        : message.notification?.title ?? 'Sin título';

    final body = (data['body'] ?? '').toString().isNotEmpty
        ? data['body'].toString()
        : message.notification?.body ?? '';

    flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'channel_id',
          'channel_name',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  });

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
        '/notificaciones': (context) => const NotificacionesSolicitudes(),
        '/mispropiedades': (context) => const MisPropiedades(),
        '/solicitudes': (context) => const MisSolicitudesPage(),
        '/perfil': (context) => const ProfileView(),
        '/listerchat': (context) => const ChatListScreen(),
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
  final appLinks = AppLinks();

  @override
  void initState() {
    super.initState();
    initDeepLinks();
  }

  void initDeepLinks() {
    appLinks.uriLinkStream.listen((uri) async {
      if (uri.host == 'auth') {
        final token = uri.queryParameters['token'];

        if (token != null) {
          print("Token recibido: $token");

          await UserService.guardarToken(token);

          Navigator.of(context).pushReplacementNamed('/inicio');
        }
      }
    });
  }

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
      await UserService.login(email, password);

      final userActualizado = await UserService.obtenerUsuarioLocal();

      print("USER ACTUALIZADO: $userActualizado");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Inicio de sesión exitoso'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).pushReplacementNamed('/inicio');
    } catch (e) {
      print("ERROR: $e");
      _mostrarError('Credenciales incorrectas o error de conexión');
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
              'login_email',
            ),
            const SizedBox(height: 20),
            _buildInputField(
              'Contraseña',
              _passwordController,
              true,
              'login_password',
            ),
            const SizedBox(height: 30),
            _botoniniciosesion(),
            const SizedBox(height: 30),
            Text(
              '¿No tienes una cuenta?',
              style: TextStyle(color: MiTema.textamarillo, fontSize: 18),
            ),
            GestureDetector(
              onTap: () async {
                final url = Uri.parse('${Config.baseUrl}/register?from=app');
                await launchUrl(url, mode: LaunchMode.externalApplication);
              },
              child: Text(
                'Regístrate aquí',
                style: TextStyle(
                  color: MiTema.azulPrincipal,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
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
      key: const Key('login_button'),
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
