import 'package:flutter/material.dart';
import 'package:noticias_sin_filtro/views/native_webview/native_webview.dart';

class WebviewWrapper extends StatelessWidget {
  const WebviewWrapper({Key? key, required this.title, required this.url, this.port = "" }) : super(key: key);
  final String url;
  final String port;
  final String title;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: NativeWebViewPlatform(url: url, port: port)
    );
  }
}
