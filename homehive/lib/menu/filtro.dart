import 'package:flutter/material.dart';
import 'package:homehive/theme/tema.dart';

Drawer filtro(BuildContext context) {
  return Drawer(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
    ),
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Flecha atrás
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),

            const SizedBox(height: 10),

            //Título
            const Center(
              child: Text(
                'Tipo de inmueble',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: MiTema.textPrimary,
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Botones de tipo
            _botonTipo('Cuarto'),
            const SizedBox(height: 15),
            _botonTipo('Casa'),
            const SizedBox(height: 15),
            _botonTipo('Departamento'),

            const SizedBox(height: 30),

            // Precio
            const Text(
              'Precio',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                _campoPrecio('Desde'),
                const SizedBox(width: 15),
                _campoPrecio('Hasta'),
              ],
            ),

            const Spacer(),

            // Botón filtrar
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0B5D46),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {},
                child: const Text('Filtrar', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    ),
  );
}

Widget _botonTipo(String texto) {
  return SizedBox(
    width: double.infinity,
    height: 45,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0B5D46), 
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
      onPressed: () {},
      child: Text(texto, style: const TextStyle(color: Colors.white)),
    ),
  );
}

Widget _campoPrecio(String hint) {
  return Expanded(
    child: TextField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: hint,
        suffixText: 'MN',
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: MiTema.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: MiTema.border),
        ),
      ),
    ),
  );
}


