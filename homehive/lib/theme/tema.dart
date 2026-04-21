import 'package:flutter/material.dart';

class MiTema {
  // --- COLORES EXISTENTES ---
  static const Color azulPrincipal = Color(0xFF1E3A8A);
  static const Color hover = Color(0xFF1E40AF);
  static const Color fondo = Color(0xFFB0B3D3);
  static const Color amarillo = Color(0xFFF5BF46);
  static const Color gris = Color(0xFFD5D5DE);
  static const Color bggris = Color(0xFFF3F4F6);
  static const Color cart = Color(0xFFFFFFFF);
  static const Color verde = Color(0xFF30621C);
  static const Color textPrimary = Color(0xFF111827);
  static const Color textamarillo = Color(0xFF4B5563);
  static const Color border = Color(0xFFD1D5DB);
  static const Color rojo = Color(0xFFFF0303);

  // --- NUEVOS COLORES PARA SOLICITUDES Y BOTONES ---
  static const Color lilaFondo = Color(0xFFC5CAE9);   // El fondo de las capturas
  static const Color badgeAmarillo = Color(0xFFFDE68A); // El fondo del "Pendiente"
  static const Color verdeAceptar = Color(0xFF065F46);  // Botón aceptar (verde oscuro)
  static const Color rojoRechazar = Color(0xFF991B1B);  // Botón rechazar (rojo oscuro)
  static const Color indigoIconos = Color(0xFF1A237E);  // Azul para iconos de datos

  static ThemeData temaApp(BuildContext context) { // Corregido el parámetro
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: lilaFondo, // Usamos el lila de las solicitudes como fondo base

      colorScheme: ColorScheme.light(
        primary: azulPrincipal,
        secondary: amarillo,
        surface: cart,
        background: bggris,
        onBackground: textPrimary,
      ),
      
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
          color: Colors.black, 
          fontWeight: FontWeight.bold, 
          fontSize: 24
        ),
      ),

      drawerTheme: const DrawerThemeData(backgroundColor: cart),
      
      listTileTheme: const ListTileThemeData(
        iconColor: Colors.black87,
        textColor: Colors.black87,
        titleTextStyle: TextStyle(
          fontSize: 18,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),

      // Estilo global para botones elevados
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      ),
    );
  }
}