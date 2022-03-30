import 'package:flutter/material.dart';
import 'package:noticias_sin_filtro/views/native_webview/native_webview.dart';

class WebviewWrapper extends StatelessWidget {
  const WebviewWrapper({
    Key? key,
    required this.title,
    required this.url,
    this.port = "",
    required this.showAppBar
  }) : super(key: key);

  final String url;
  final String port;
  final String title;
  final bool showAppBar;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            title,
            style: TextStyle(fontSize: 15),
        ),
        backgroundColor: Colors.grey[700],
        foregroundColor: Colors.grey[100],
      ),
      body: NativeWebView(url: url, port: port)
    );
  }
}
