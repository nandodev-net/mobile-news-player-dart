import 'package:flutter/material.dart';
import 'package:noticias_sin_filtro/data.dart';
import 'package:noticias_sin_filtro/views/audio_widgets/widgets.dart';

/*
  Main Screen Content
*/
class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);
  // here's comes the decoration of the container.
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
                center: Alignment.topCenter,
                radius: 1.2,
                colors: <Color>[
                  Color.fromARGB(255, 88, 202, 255),
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
            Recently Added Slider. on this container it appears all the newest 
            podcasts and audio files.
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
                      child: Column(
                        children: [
                          // Container's tittle
                          Row(
                            children: [
                              Text(
                                'New capsule',
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              RowAudioCard(
                                audio: audios[5],)
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        children: [
                          // Container's tittle
                          Text(
                            'Recently Added',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ],
                      ),
                    ),
                    // List of newests Audio cards to show on the slider
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.all(20),
                      child: Row(
                        children: [
                          for (var audio in audios)
                            Row(
                              children: [
                                AudioCard(audio: audio),
                                SizedBox(width: 16.0),
                              ],
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
                            (() {
                              if (dt.hour > 5 && dt.hour < 12) {
                                return "Good morning...";
                              }
                              if (dt.hour >= 12 && dt.hour < 19) {
                                return "Good evening...";
                              }
                              return "Good night...";
                            })(),
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(60.0, 0, 0, 0),
                            child: Text(
                              "Choose An Author",
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                          SizedBox(height: 10),
                          // List of top 6 authors, based on number of views
                          for (var author in authors)
                            Column(
                              children: [
                                Row(
                                  children: [
                                    RowAuthorCard(
                                      author: author,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                        ],
                      ),
                    ),
                    /*
                      Slider of most listened audios
                    */
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Based on number of listens",
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Row(
                            children: [
                              for (var audio in audios)
                                Row(
                                  children: [
                                    AudioCard(audio: audio),
                                    SizedBox(width: 16.0),
                                  ],
                                ),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 16.0,
                    ),

                    /*
                      Slider of most voted
                    */
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "The Most voted",
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Row(
                            children: [
                              for (var audio in audios)
                                Row(
                                  children: [
                                    AudioCard(audio: audio),
                                    SizedBox(width: 16.0),
                                  ],
                                ),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
