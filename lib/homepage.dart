import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:noticias_sin_filtro/native_webview.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  bool _connected = false;
  final _key = UniqueKey();
  var _url = "https://whatismyipaddress.com/";
  var _proxyPort;

  final MethodChannel _VPNconnectionMethodChannel  = MethodChannel("noticias_sin_filtro/vpn_connection");

  Future <String> connectWithVPN() async {
    final proxyPort = await _VPNconnectionMethodChannel.invokeMethod("connect");
    print("proxyPort from Android $proxyPort");
    return proxyPort;
  }

  /* final Completer<WebViewController> _controller =
  Completer<WebViewController>();*/

  @override
  void initState() {
    super.initState();
    // if (Platform.isAndroid) {
    //   WebView.platform = SurfaceAndroidWebView();
    // }
  }

  void _connect() async {
    _proxyPort = await connectWithVPN();
    print("_proxyPort $_proxyPort");
    setState(() {
      _connected = true ;
    });
  }

  void _disconnect() async{
    // setState(() {
    //   _connected = false ;
    // });
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
            TextButton(
              onPressed:_connect,
              child: const Text('Connect'),
            ),
            TextButton(
              onPressed:_disconnect,
              child: const Text('Disconnect (not working)'),
            ),
            TextButton(
              onPressed:_disconnect,
              child: const Text('Open news with vpn'),
            ),
            TextButton(
              onPressed:_disconnect,
              child: const Text('Open news without vpn'),
            ),
            // Expanded(
            //   child: NativeWebViewPlatform(),
            // )

          ],
        ),
      ),

    );
  }
}
