import 'package:flutter/material.dart';
import 'package:noticias_sin_filtro/database/db_helper.dart';
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
  List<Author> _news_authors = [];
  List<Author> _podcast_authors = [];
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
      _podcast_authors = mainResponse['podcast_authors'];
      _news_authors = mainResponse['news_authors'];
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
          ),

          /* 
            Recently Added Slider. on this container it appears all the newest 
            podcasts and audio files.
          */
          Stack(
            children: [
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

                      (_news_authors.isNotEmpty)
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: SizedBox(
                                height: 40,
                                child: Row(
                                  children: [
                                    // Container's tittle
                                    Text(
                                      'News Providers',
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                    const Spacer(),
                                    (_news_authors.length > 1)
                                        ? const IconButton(
                                            onPressed: null,
                                            icon: Icon(Icons.list))
                                        : const SizedBox(
                                            width: 1,
                                          ),
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox(
                              height: 2,
                            ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_news_authors.isNotEmpty) ...[
                            if (_news_authors.length > 1) ...[
                              AuthorInfoCard(
                                  author: _news_authors[0], port: widget.port),
                              AuthorInfoCard(
                                  author: _news_authors[1], port: widget.port),
                            ] else ...[
                              AuthorInfoCard(
                                  author: _news_authors[0], port: widget.port),
                            ]
                          ] else ...[
                            const SizedBox(
                              height: 2,
                            ),
                          ]
                        ],
                      ),

                      SizedBox(height: 30),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
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
                            // Container's tittle
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(60.0, 0, 0, 0),
                              child: Text(
                                'Listen our last content',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
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

                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                "Podcasts",
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ),
                            // List of top 6 authors, based on number of views
                            Container(
                              height: 265.0,
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Wrap(
                                  children: [
                                    for (var authorObj in _podcast_authors)
                                      Column(children: [
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        Row(
                                          children: [
                                            RowAuthorCard(
                                              author: authorObj,
                                              port: widget.port,
                                            ),
                                          ],
                                        ),
                                      ]),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              ),
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
                              "The most voted",
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
                      const SizedBox(
                        height: 65.0,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 60,
                child: CustomScrollView(
                  slivers: [
                    CustomSliverAppBar(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
