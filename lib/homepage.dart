import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noticias_sin_filtro/webview_wrapper.dart';
import 'package:noticias_sin_filtro/list_item.dart';
import 'package:noticias_sin_filtro/news_mapper.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;



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
  var url = "https://whatismyipaddress.com/";//TODO: array de URLs
  var _proxyPort = null;
  List<News> _newsList = [];

  final MethodChannel _VPNconnectionMethodChannel  = MethodChannel("noticias_sin_filtro/vpn_connection");

  Future <String> connectWithVPN() async {
    final proxyPort = await _VPNconnectionMethodChannel.invokeMethod("connect");
    print("proxyPort from Android $proxyPort");
    return proxyPort;
  }

  @override
  void initState() {
    super.initState();
    //_connect();
    getData();
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

  void _navigate() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  WebviewWrapper(url:url, port:_proxyPort)),
    );
  }

  void getData() async {

   var uri = Uri(
        scheme: 'https',
        host: 'newsdata.io',
        path: 'api/1/news',
        queryParameters: {'apikey':'pub_513800388590479796ae728a8efb8bee1854', 'country':'au,ca'}
   );

   var response = await http.get(uri);

    setState(() {
      _newsList = NewsRequestMapper.fromJson(json.decode(response.body)).results;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.title)
      ),
      body: Container(
            alignment: Alignment.topCenter,
            child: ListView.builder(
              itemCount: _newsList.length,
              itemBuilder: (context, index) => ListItem(_newsList[index]),
            )
      ),

    );
  }
}

