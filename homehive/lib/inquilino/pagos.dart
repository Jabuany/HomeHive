import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:homehive/theme/tema.dart';

class PantallaPagoWebView extends StatefulWidget {
  final String url;
  const PantallaPagoWebView({super.key, required this.url});

  @override
  State<PantallaPagoWebView> createState() => _PantallaPagoWebViewState();
}

class _PantallaPagoWebViewState extends State<PantallaPagoWebView> {
  late final WebViewController controller;
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) => setState(() => _cargando = true),
          onPageFinished: (url) => setState(() => _cargando = false),
          onNavigationRequest: (request) {
            // Si la URL contiene "exito", cerramos la vista y volvemos a la lista
            if (request.url.contains('exito')) {
              Navigator.pop(context, true); // Retorna 'true' para refrescar la lista
              return NavigationDecision.prevent;
            }
            if (request.url.contains('cancelado')) {
              Navigator.pop(context, false);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pago Seguro"),
        backgroundColor: MiTema.azulPrincipal,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (_cargando)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}