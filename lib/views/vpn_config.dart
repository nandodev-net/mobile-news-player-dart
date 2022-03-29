import 'dart:ui';
import 'package:flutter/material.dart';

class VpnConfig extends StatefulWidget {
  const VpnConfig({Key? key, required this.connect, required this.disconnect, required this.port, required this.status}) : super(key: key);
  final VoidCallback connect;
  final VoidCallback disconnect;
  final String port;
  final bool status;

  @override
  _VpnConfigState createState() => _VpnConfigState();
}

class _VpnConfigState extends State<VpnConfig> {

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
               widget.status?'Conectado':'Desconectado',
                style: Theme.of(context).textTheme.headline6
            ),
            Text((() {
              if(widget.port == null) {
                return "Sin proxy";
              }
              return 'Puerto Proxy ${widget.port}';
            })(),
                style: Theme.of(context).textTheme.headline6
            ),
            ElevatedButton(
              onPressed:widget.connect,
              child: const Text('Reconectarse'),
              style: raisedButtonStyle,
            ),
            ElevatedButton(
              onPressed:widget.disconnect,
              child: const Text('Desconectarse'),
              style: raisedButtonStyle,
            ),

          ],
        )
      )
    );
  }
}
