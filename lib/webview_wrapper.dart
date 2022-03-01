import 'package:flutter/material.dart';
import 'package:noticias_sin_filtro/native_webview.dart';

class WebviewWrapper extends StatelessWidget {
  const WebviewWrapper({Key? key, required this.url, this.port = "" }) : super(key: key);
  final String url;
  final String port;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Webview Interna'),
      ),
      body: NativeWebViewPlatform(url: url, port: port)
    );
  }
}
