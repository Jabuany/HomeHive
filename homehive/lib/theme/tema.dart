import 'package:flutter/material.dart';

class MiTema {
  //colores para la app, se definiran reglas para poder ser consistenres con el tema y el equipo de desarrollo
  static const Color azulPrincipal = Color.fromARGB(
    255,
    30,
    58,
    138,
  ); // azul oscuro principal
  static const Color hover = Color.fromARGB(
    255,
    30,
    64,
    175,
  ); // azul mas oscuro para hover
  static const Color amarillo = Color.fromARGB(
    255,
    245,
    191,
    70,
  ); //color ambar o amarillo dorado
  static const Color gris = Color.fromARGB(
    255,
    213,
    213,
    222,
  ); // gris para hover

  //colores para fondos

  static const Color bggris = Color.fromARGB(
    255,
    243,
    244,
    246,
  ); //gris muy claro
  static const Color cart = Color.fromARGB(
    255,
    255,
    255,
    255,
  ); //blanco para tarjetas y contenedores
  static const Color verde = Color.fromARGB(255, 48, 98, 28);

  //colores para textos

  static const Color textPrimary = Color.fromARGB(
    255,
    17,
    24,
    39,
  ); //Gris carbono
  static const Color textamarillo = Color.fromARGB(
    255,
    75,
    85,
    99,
  ); // gris medio

  //colores para bordes
  static const Color border = Color.fromARGB(
    255,
    209,
    213,
    219,
  ); //gris claro para bordes

  //color de icono
  static const Color rojo = Color.fromARGB(
    255,
    255,
    3,
    3,
  ); //gris claro para bordes

  static ThemeData temaApp(BuildContext) {
    return ThemeData(
      useMaterial3: true,

      scaffoldBackgroundColor: gris,

      colorScheme: ColorScheme.light(
        primary: azulPrincipal,
        secondary: amarillo,
        surface: gris,
        background: bggris,
        onBackground: textPrimary,
      ),
      drawerTheme: DrawerThemeData(backgroundColor: cart),
      listTileTheme: const ListTileThemeData(
        iconColor: Colors.black87,
        textColor: Colors.black87,
        titleTextStyle: TextStyle(
          fontSize: 18,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
