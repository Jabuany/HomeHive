import 'package:flutter/material.dart';
import 'package:homehive/theme/tema.dart';

class FiltroPage extends StatelessWidget {
  final String? min;
  final String? max;

  const FiltroPage({super.key, this.min, this.max});

  @override
  Widget build(BuildContext context) {
    String precioMin = (min == null || min!.isEmpty) ? "0" : min!;
    String precioMax = (max == null || max!.isEmpty) ? "Máx" : max!;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: MiTema.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Resultados',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: MiTema.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  _chipInformativo("Rango: \$$precioMin - \$$precioMax"),
                ],
              ),
            ),
            
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 25),
                    child: _propiedadFicha(context),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chipInformativo(String texto) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: MiTema.verde.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: MiTema.verde),
      ),
      child: Text(
        texto,
        style: const TextStyle(
          color: MiTema.verde,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _propiedadFicha(BuildContext context) {
    return Card(
      color: MiTema.cart,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(25),
                ),
                child: Image.asset(
                  'assets/casa.webp',
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite_border,
                    color: MiTema.azulPrincipal,
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '\$2600',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: MiTema.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Resultado de Filtro',
                  style: TextStyle(fontSize: 16, color: MiTema.textPrimary),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Ubicación Ocosingo',
                  style: TextStyle(fontSize: 14, color: MiTema.textamarillo),
                ),
                const SizedBox(height: 15),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MiTema.azulPrincipal,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/vermas');
                    },
                    child: const Text('Ver más'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}