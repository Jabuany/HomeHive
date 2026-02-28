import 'package:flutter/material.dart';
import 'package:homehive/theme/tema.dart';
import 'package:homehive/menu/menu.dart';
import 'package:homehive/views/rentar.dart'; 

class VerMas extends StatefulWidget {
  const VerMas({super.key});

  @override
  State<VerMas> createState() => _VerMasState();
}

class _VerMasState extends State<VerMas> {
  bool _estaEditando = false;
  int? _indexEditando;
  final TextEditingController _controllerEditar = TextEditingController();

  final List<Map<String, dynamic>> _comentarios = [
    {'nombre': 'Paola Lorenzo', 'comentario': 'Buen servicio', 'fecha': '19 de octubre de 2023', 'esPropio': true},
    {'nombre': 'Sarah Lenoir', 'comentario': 'Excelente', 'fecha': '12 de septiembre de 2023', 'esPropio': true}, 
  ];

  void _borrarComentario(int index) {
    setState(() {
      _comentarios.removeAt(index);
    });
  }

  void _abrirEdicion(int index) {
    setState(() {
      _estaEditando = true;
      _indexEditando = index;
      _controllerEditar.text = _comentarios[index]['comentario'];
    });
  }

  void _guardarEdicion() {
    if (_indexEditando != null) {
      setState(() {
        _comentarios[_indexEditando!]['comentario'] = _controllerEditar.text;
        _estaEditando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: menu(context),
      appBar: AppBar(
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          'HomeHive',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: _detalleCard(context),
          ),
          if (_estaEditando) _panelEditarComentario(),
        ],
      ),
    );
  }

  Widget _panelEditarComentario() {
    return Container(
      color: Colors.black54,
      alignment: Alignment.center,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Editar Comentario', 
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.cancel_outlined, color: Colors.black),
                  onPressed: () => setState(() => _estaEditando = false),
                ),
              ],
            ),
            const Divider(),
            TextField(
              controller: _controllerEditar,
              decoration: InputDecoration(
                hintText: 'Escribe tu comentario...',
                border: const UnderlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _guardarEdicion,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: MiTema.bggris,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Asigne una calificación', style: TextStyle(color: Colors.black54)),
                  Icon(Icons.keyboard_arrow_down),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Column(
              children: List.generate(5, (index) {
                int estrellas = 5 - index;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      ...List.generate(estrellas, (_) => const Icon(Icons.star, size: 16)),
                      const SizedBox(width: 5),
                      Text('($estrellas)'),
                    ],
                  ),
                );
              }),
            )
          ],
        ),
      ),
    );
  }

  Widget _detalleCard(BuildContext context) {
    return Card(
      color: MiTema.cart,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Corazón Urbano',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: MiTema.textPrimary),
                ),
                const Icon(Icons.favorite_border, color: MiTema.textPrimary),
              ],
            ),
          ),
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset(
                  'assets/casa.webp',
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(height: 220, color: Colors.grey),
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: _iconoCircular(Icons.arrow_back, () => Navigator.pop(context)),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _seccion('Descripción', 'Casa moderna con excelente iluminación, ideal para estancias cortas.'),
                _seccion('Servicios', 'WiFi • Aire acondicionado • Cocina equipada'),
                _seccion('Ubicación', 'A 5 minutos del centro histórico'),
                const Divider(height: 30),
                _seccionMapa(),
                const SizedBox(height: 20),
                _seccionComentarios(),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // 2. IMPLEMENTACIÓN DE LA NAVEGACIÓN
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Rentar()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MiTema.azulPrincipal,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      'Rentar',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _seccion(String titulo, String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: MiTema.textPrimary)),
          const SizedBox(height: 4),
          Text(texto, style: const TextStyle(fontSize: 14, color: MiTema.textPrimary)),
        ],
      ),
    );
  }

  Widget _seccionMapa() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Mapa', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: MiTema.textPrimary)),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.asset(
            'assets/Mapa.png',
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 180,
              color: MiTema.bggris,
              child: const Center(child: Icon(Icons.map_outlined, size: 50)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _seccionComentarios() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Comentarios', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: MiTema.textPrimary)),
        const SizedBox(height: 15),
        ..._comentarios.asMap().entries.map((entry) {
          int idx = entry.key;
          var datos = entry.value;
          return _comentarioItem(
            datos['nombre'], 
            datos['comentario'], 
            datos['fecha'], 
            datos['esPropio'],
            () => _borrarComentario(idx),
            () => _abrirEdicion(idx),
          );
        }).toList(),
        const SizedBox(height: 15),
        _inputComentario(),
      ],
    );
  }

  Widget _comentarioItem(String nombre, String comentario, String fecha, bool esPropio, VoidCallback onBorrar, VoidCallback onEditar) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: MiTema.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(backgroundColor: MiTema.azulPrincipal, child: Icon(Icons.person, color: Colors.white)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: List.generate(5, (index) => const Icon(Icons.star, size: 14, color: Colors.amber))),
                Text(nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(comentario, style: const TextStyle(color: Colors.black54)),
                Text(fecha, style: const TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
          if (esPropio) 
            Row(
              children: [
                GestureDetector(
                  onTap: onEditar,
                  child: const Icon(Icons.edit, size: 18, color: Colors.black54),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: onBorrar,
                  child: const Icon(Icons.delete_outline, size: 18, color: Colors.redAccent),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _inputComentario() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: MiTema.gris.withOpacity(0.3),
        borderRadius: BorderRadius.circular(30),
      ),
      child: const Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(hintText: 'Comentar', border: InputBorder.none),
            ),
          ),
          Icon(Icons.send_outlined),
        ],
      ),
    );
  }

  Widget _iconoCircular(IconData icono, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: Icon(icono, color: MiTema.textPrimary),
      ),
    );
  }
}