import 'package:flutter/material.dart';
import 'package:noticias_sin_filtro/native_webview.dart';

class WebviewWrapper extends StatelessWidget {
  const WebviewWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Webview Interna'),
      ),
      body: NativeWebViewPlatform()
    );
  }
}
