import 'package:flutter/material.dart';
import 'package:noticias_sin_filtro/views/audio_widgets/widgets.dart';

/*
  Main Screen Content
*/
class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime dt = DateTime.now();
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

          /* 
            Album Slider. on this container will appear all the autors
            of the podcasts and audio files.
          */
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
                          // Container's tittle
                          Text(
                            'Most Played Audios',
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
                    // List of the Album cards to show on the slider
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

                    /*
                      Greetings message
                     */
                    SizedBox(
                      height: 32.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Good evening",
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              RowAlbumCard(
                                label: "Top 50 - Global",
                                image: AssetImage("assets/5.jpg"),
                              ),
                              SizedBox(width: 16),
                              RowAlbumCard(
                                label: "Best Mode",
                                image: AssetImage("assets/6.jpg"),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              RowAlbumCard(
                                label: "RapCaviar",
                                image: AssetImage("assets/7.jpg"),
                              ),
                              SizedBox(width: 16),
                              RowAlbumCard(
                                label: "Eminem",
                                image: AssetImage("assets/8.jpg"),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              RowAlbumCard(
                                label: "Top 50 - USA",
                                image: AssetImage("assets/9.jpg"),
                              ),
                              SizedBox(width: 16),
                              RowAlbumCard(
                                label: "Pop Remix",
                                image: AssetImage("assets/10.jpg"),
                              ),
                            ],
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
