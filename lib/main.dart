import 'package:flutter/material.dart';
import 'package:noticias_sin_filtro/application_wrapper.dart';

void main() async {
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
      home: ApplicationWrapper(title: 'Noticias Sin Filtro'),
    );
  }
}



