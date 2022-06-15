import 'package:flutter/material.dart';
import 'package:noticias_sin_filtro/entities/audio.dart';
import 'package:noticias_sin_filtro/entities/author.dart';
import 'package:noticias_sin_filtro/services/requests/get_audio_main.dart';
import 'package:noticias_sin_filtro/views/audio_widgets/widgets.dart';

/*
  Main Screen Content
*/
class MainScreen extends StatefulWidget {
  final String port;
  const MainScreen({Key? key, required this.port}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Audio> _lastCapsule = [];
  List<Audio> _recentlyAdded = [];
  List<Author> _authors = [];
  List<Audio> _basedOnListens = [];
  List<Audio> _mostVoted = [];

  @override
  void initState() {
    super.initState();
    getMainScreenFromApi();
  }

  void getMainScreenFromApi() async {
    Map mainResponse = await getAudioMain(widget.port);
    setState(() {
      _lastCapsule = mainResponse['lastCapsule'];
      _recentlyAdded = mainResponse['recentlyAdded'];
      _authors = mainResponse['authors'];
      _basedOnListens = mainResponse['basedOnListens'];
      _mostVoted = mainResponse['mostVoted'];
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime dt = DateTime.now();
    return Scaffold(
      body: Stack(
        alignment: Alignment.topLeft,
        children: [
          // here's comes the decoration of the container.
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
              physics: const BouncingScrollPhysics(),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 60.0,
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
                                audio: _lastCapsule[0],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
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
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          for (var audioObj in _recentlyAdded)
                            Row(
                              children: [
                                AudioCard(audio: audioObj),
                                const SizedBox(width: 16.0),
                              ],
                            ),
                        ],
                      ),
                    ),

                    /*
                      Greetings message
                     */
                    const SizedBox(
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
                            padding: const EdgeInsets.fromLTRB(60.0, 0, 0, 0),
                            child: Text(
                              "Choose An Author",
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                          const SizedBox(height: 10),
                          // List of top 6 authors, based on number of views
                          for (var authorObj in _authors)
                            Column(
                              children: [
                                Row(
                                  children: [
                                    RowAuthorCard(
                                      author: authorObj,
                                      port: widget.port,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
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
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Row(
                            children: [
                              for (var audioObj in _basedOnListens)
                                Row(
                                  children: [
                                    AudioCard(audio: audioObj),
                                    const SizedBox(width: 16.0),
                                  ],
                                ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
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
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Row(
                            children: [
                              for (var audioObj in _mostVoted)
                                Row(
                                  children: [
                                    AudioCard(audio: audioObj),
                                    const SizedBox(width: 16.0),
                                  ],
                                ),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 65.0,
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
