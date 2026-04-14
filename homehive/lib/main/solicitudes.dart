import 'package:flutter/material.dart';
import 'package:homehive/theme/tema.dart';

class MisSolicitudesPage extends StatefulWidget {
  const MisSolicitudesPage({super.key});

  @override
  State<MisSolicitudesPage> createState() => _MisSolicitudesPageState();
}

class _MisSolicitudesPageState extends State<MisSolicitudesPage> {
  DateTime? desde;
  DateTime? hasta;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MiTema.gris,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'HomeHive',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: MiTema.textPrimary,
          ),
        ),
        leading: const BackButton(color: MiTema.textPrimary),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                "Mis solicitudes",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: MiTema.textPrimary,
                ),
              ),

              const SizedBox(height: 20),

              _filtroFechas(),

              const SizedBox(height: 30),

              _cardSolicitud(),

              const Spacer(),

              const Text(
                "©2026 DevSquad",
                style: TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filtroFechas() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: MiTema.cart,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Row(
        children: [
          Expanded(
            child: _dateField("Desde", desde, (date) {
              setState(() => desde = date);
            }),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: _dateField("Hasta", hasta, (date) {
              setState(() => hasta = date);
            }),
          ),

          const SizedBox(width: 10),

          Container(
            decoration: const BoxDecoration(
              border: Border(left: BorderSide(color: Colors.black26)),
            ),
            child: IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          ),
        ],
      ),
    );
  }

  Widget _dateField(String label, DateTime? date, Function(DateTime) onSelect) {
    return InkWell(
      onTap: () async {
        DateTime now = DateTime.now();

        final picked = await showDatePicker(
          context: context,
          initialDate: date ?? now,
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
        );

        if (picked != null) {
          onSelect(picked);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: MiTema.bggris,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: MiTema.border),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                date != null ? "${date.day}/${date.month}/${date.year}" : label,
                style: const TextStyle(fontSize: 12),
              ),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  Widget _cardSolicitud() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: MiTema.cart,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _info("Propiedad", "Las lomas")),

              Container(height: 60, width: 1, color: Colors.black26),

              Expanded(child: _info("Precio", "\$2500.00")),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: _info("Fecha de solicitud", "2026-02-07 20:04:39"),
              ),

              Container(height: 60, width: 1, color: Colors.black26),

              Expanded(child: _info("Estado", "Aceptado")),
            ],
          ),

          const SizedBox(height: 15),

          SizedBox(
            width: 180,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: MiTema.verde,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {},
              child: const Text(
                "Ver solicitud",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _info(String titulo, String valor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: MiTema.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(valor),
      ],
    );
  }
}
