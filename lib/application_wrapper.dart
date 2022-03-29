import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noticias_sin_filtro/views/home.dart';
import 'package:noticias_sin_filtro/views/native_webview/webview_wrapper.dart';


class ApplicationWrapper extends StatefulWidget {
  const ApplicationWrapper({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<ApplicationWrapper> createState() => ApplicationWrapperState();
}

class ApplicationWrapperState extends State<ApplicationWrapper> {
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
          title: "Check your IP",
          port:_proxyPort)),
      );
  }

  //final PageStorageBucket bucket = PageStorageBucket();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: Text(widget.title),
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey[600],
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(primary: Theme.of(context).colorScheme.onPrimary),
            onPressed: () {},
            child: Text.rich(
              TextSpan(
                text: _connected?'VPN ON':'VPN OFF',
                style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                    fontSize: 13
                ),
                children: <TextSpan> [
                  TextSpan(
                      text: '•',
                      style: TextStyle(
                          color:_connected?Colors.green:Colors.redAccent,
                          fontSize: 35,
                          height: 1
                      )
                  ),
                ]
              ),
              textAlign: TextAlign.center,
            )
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
        backgroundColor: Colors.red,
        items: const <BottomNavigationBarItem> [

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Medios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.rss_feed),
            label: 'Navega',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categorías',
          ),
        ],
        currentIndex: _bottomNavIndex,
        selectedItemColor: Colors.blue[700],
        unselectedItemColor: Colors.grey[600],
        // iconSize: 40,
        //type: BottomNavigationBarType.fixed,
        iconSize: 25,
        onTap: _onBottomNavItemTapped,
      ),

    );
  }
}

