import 'package:flutter/material.dart';
import 'package:noticias_sin_filtro/data.dart';

/*
  Upper bar with search icon Widget
*/
class CustomSliverAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Adding properties and search button
    return SliverAppBar(
      floating: true,
      backgroundColor: Color.fromARGB(185, 0, 0, 0),
      leadingWidth: 100.0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        //child: Image.asset('assets/yt_logo_dark.png'),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.grey,),
          onPressed: () {},
        ),
      ],
    );
  }
}