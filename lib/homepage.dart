import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noticias_sin_filtro/webview_wrapper.dart';


// TODO: convertir esto en "Connection Handler"
class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  bool _connected = false;
  final _key = UniqueKey();
  var url = "https://google.com/";//TODO: array de URLs
  var _proxyPort = null;

  final MethodChannel _VPNconnectionMethodChannel  = MethodChannel("noticias_sin_filtro/vpn_connection");

  Future <String> connectWithVPN() async {
    final proxyPort = await _VPNconnectionMethodChannel.invokeMethod("connect");
    print("proxyPort from Android $proxyPort");
    return proxyPort;
  }

  @override
  void initState() {
    super.initState();
    _connect();
  }

  void _connect() async {
    var _port = await connectWithVPN();

    setState(() {
      _proxyPort = _port;
    });

    setState(() {
      _connected = true;
    });

  }

   void _disconnect() async{
    String result = await _VPNconnectionMethodChannel.invokeMethod("disconnect");

    setState(() {
      _proxyPort = null;
    });

    setState(() {
      _connected = false;
    });
  }

  void _navigateVPN() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  WebviewWrapper(url:url, port:_proxyPort)),
    );
  }

  void _navigate() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WebviewWrapper(url:url)),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.title)
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
                'Connected: $_connected',
                style: Theme.of(context).textTheme.headline6
            ),
            Text((() {
              if(_proxyPort == null) {
                return "No proxy";
              }
              return 'ProxyPort $_proxyPort';
              })(),
              style: Theme.of(context).textTheme.headline6
            ),
            TextButton(
              onPressed:_connect,
              child: const Text('Connect or Reconnect'),
            ),
            TextButton(
              onPressed:_disconnect,
              child: const Text('Disconnect'),
            ),
            TextButton(
              onPressed:_navigateVPN,
              child: const Text('Open news with vpn'),
            ),
            TextButton(
              onPressed:_navigate,
              child: const Text('Open news without vpn'),
            ),
          ],
        ),
      ),

    );
  }
}
