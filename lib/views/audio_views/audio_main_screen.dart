import 'package:flutter/material.dart';
import 'package:noticias_sin_filtro/views/audio_widgets/widgets.dart';

/*
  Main Screen Content
*/
class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color.fromARGB(255, 136, 213, 248), Colors.white])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: CustomScrollView(
          slivers: [CustomSliverAppBar()],
        ),
      ),
    );
  }
}
