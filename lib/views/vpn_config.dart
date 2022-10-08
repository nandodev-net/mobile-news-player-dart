import 'dart:ui';
import 'package:flutter/material.dart';

class VpnConfig extends StatefulWidget {
  VpnConfig({Key? key, required this.connect, required this.disconnect, required this.port, required this.status}) : super(key: key);
  VoidCallback connect;
  VoidCallback disconnect;
  String port;
  bool status;

  @override
  _VpnConfigState createState() => _VpnConfigState(this.connect, this.disconnect, this.port, this.status);
}

class _VpnConfigState extends State<VpnConfig> {
   VoidCallback connect;
   VoidCallback disconnect;
  String port;
  bool status;

  _VpnConfigState(this.connect,this.disconnect, this.port, this.status);



  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    onPrimary: Colors.black87,
    primary: Colors.grey[300],
    minimumSize: Size(100, 36),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
            "Configuración de VPN",
            style: TextStyle(fontSize: 15),
          ),
          backgroundColor: Colors.grey[700],
          foregroundColor: Colors.grey[100],
        ),
        body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
               status?'Conectado':'Desconectado',
                style: Theme.of(context).textTheme.headline6
            ),
            Text((() {
              if(port == null) {
                return "Sin proxy";
              }
              return 'Puerto Proxy ${port}';
            })(),
                style: Theme.of(context).textTheme.headline6
            ),
            ElevatedButton(
              onPressed:connect,
              child: const Text('Reconectarse'),
              style: raisedButtonStyle,
            ),
            ElevatedButton(
              onPressed:disconnect,
              child: const Text('Desconectarse'),
              style: raisedButtonStyle,
            ),

          ],
        )
      )
    );
  }
}
