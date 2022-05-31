import 'package:flutter/material.dart';
import 'package:noticias_sin_filtro/views/audio_widgets/widgets.dart';

/*
  Main Screen Content
*/
class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topLeft,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topLeft,
                radius: 1.0,
                colors: <Color>[
                  Color.fromARGB(255, 59, 59, 59),
                  Color.fromARGB(255, 255, 255, 255),
                ],
              ),
            ),
            // child: Scaffold(
            //   backgroundColor: Colors.transparent,
            //   body: CustomScrollView(
            //     slivers: [CustomSliverAppBar()],
            //   ),
            // ),
          ),
          SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 40.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recently Played',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          Row(
                            children: [
                              Icon(Icons.remove_red_eye),
                            ],
                          )
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.all(20),
                      child: Row(
                        children: [
                          AlbumCard(
                            label: "Album a",
                            image: AssetImage("assets/1.jpg"),
                          ),
                          SizedBox(
                            width: 16.0,
                          ),
                          AlbumCard(
                            label: "Album b",
                            image: AssetImage("assets/2.jpg"),
                          ),
                          SizedBox(
                            width: 16.0,
                          ),
                          AlbumCard(
                            label: "Album c",
                            image: AssetImage("assets/3.jpg"),
                          ),
                          SizedBox(
                            width: 16.0,
                          ),
                          AlbumCard(
                            label: "Album d",
                            image: AssetImage("assets/4.jpg"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
