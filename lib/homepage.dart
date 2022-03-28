import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noticias_sin_filtro/home.dart';
import 'package:noticias_sin_filtro/webview_wrapper.dart';


// TODO: convertir esto en "Connection Handler o ApplicationEntrypoint"
class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  bool _connected = false;
  // final _key = UniqueKey();
  var url = "https://whatismyipaddress.com/";
  var _proxyPort = null;
  int _bottomNavIndex = 0;
  PageController pageController = PageController();

  // Functions to handle Bottom Navigation

  void _onBottomNavItemTapped(int index) {
    setState(() {
      _bottomNavIndex = index;
    });
    pageController.jumpToPage(index);
  }

  void _onBottomPageChanged(int page) {
    setState(() {
      _bottomNavIndex =page;
    });
  }


  // Functions to handle VPN
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
    //getData();
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
      MaterialPageRoute(builder: (context) =>  WebviewWrapper(
          url:"https://whatismyipaddress.com/",
          port:_proxyPort)),
      );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(primary: Theme.of(context).colorScheme.onPrimary),
            onPressed: () {},
            child: Text(_connected?'VPN ON':'VPN OFF'),
          )
          ],
      ),
      body: PageView(
        controller: pageController,
        children: [
          Home(port:_proxyPort??""),
          Container(color: Colors.blue),
          Container(color: Colors.red),
          Container(color: Colors.yellow),
      ],
        onPageChanged: _onBottomPageChanged,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem> [

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Medios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categorías',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configuración',
          ),
        ],
        currentIndex: _bottomNavIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onBottomNavItemTapped,
      ),

    );
  }
}

