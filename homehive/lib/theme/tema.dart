import 'package:flutter/material.dart';

class MiTema {
  static const Color azulPrincipal = Color.fromARGB(
    255,
    30,
    58,
    138,
  );
  static const Color hover = Color.fromARGB(
    255,
    30,
    64,
    175,
  );
  static const Color amarillo = Color.fromARGB(
    255,
    245,
    191,
    70,
  );
  static const Color gris = Color.fromARGB(
    255,
    213,
    213,
    222,
  );


  static const Color bggris = Color.fromARGB(
    255,
    243,
    244,
    246,
  );
  static const Color cart = Color.fromARGB(
    255,
    255,
    255,
    255,
  );
  static const Color verde = Color.fromARGB(255, 48, 98, 28);


  static const Color textPrimary = Color.fromARGB(
    255,
    17,
    24,
    39,
  );
  static const Color textamarillo = Color.fromARGB(
    255,
    75,
    85,
    99,
  );

  static const Color border = Color.fromARGB(
    255,
    209,
    213,
    219,
  );

  static const Color rojo = Color.fromARGB(
    255,
    255,
    3,
    3,
  );

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
