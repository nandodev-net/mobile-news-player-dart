import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:dio/dio.dart';
import 'package:dio/adapter.dart';
// uninstall import 'package:http_proxy/http_proxy.dart';


void main() async {
  String proxy = '192.168.1.4:8888';
  Dio dio = Dio();

  (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
    // Hook into the findProxy callback to set the client's proxy.
    client.findProxy = (url) {
      return 'PROXY $proxy';
    };

    // This is a workaround to allow Charles to receive
    // SSL payloads when your app is running on Android.
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
  };


  // WidgetsFlutterBinding.ensureInitialized();
  // HttpProxy httpProxy = await HttpProxy.createHttpProxy();
  // httpProxy.host = "192.168.1.4";// replace with your server ip
  // httpProxy.port = "8888";// replace with your server port
  // HttpOverrides.global=httpProxy;

  //HttpOverrides.global = MyProxyHttpOverride();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Noticias Sin Filtro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Noticias Sin Filtro'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  void _connect() async {
    _proxyPort = await connectWithVPN();
    print("_proxyPort $_proxyPort");
    setState(() {
      _connected = true ;
    });
  }

  void _disconnect() async{
    setState(() {
      _connected = false ;
    });
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
            Expanded(
                child: WebView(
                    key: _key,
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: _url))
          ],
        ),
      ),

    );
  }
}

// class CustomHttpProxyOverride extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..findProxy = (uri) {
//         return "PROXY 192.168.1.4:8888;";
//       }
//       ..badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
//   }
// }

// class MyProxyHttpOverride extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..findProxy = (uri) {
//         return "PROXY 192.168.1.4:8888;";
//       }
//       ..badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
//   }
// }