import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noticias_sin_filtro/application_wrapper.dart';
import 'package:noticias_sin_filtro/database/db_helper.dart';
import 'package:noticias_sin_filtro/entities/audio.dart';
import 'package:noticias_sin_filtro/entities/author.dart';
import 'package:noticias_sin_filtro/services/requests/get_audio_main.dart';
import 'package:noticias_sin_filtro/views/audio_views/audio_author_list_screen.dart';
import 'package:noticias_sin_filtro/views/audio_widgets/audio_alertDialog.dart';
import 'package:noticias_sin_filtro/views/audio_widgets/widgets.dart';

final selectedAuthorListProvider = StateProvider<List<Author>?>((ref) => null);

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
  List<Author> _newsAuthors = [];
  List<Author> _podcastAuthors = [];
  List<Audio> _basedOnListens = [];
  List<Audio> _mostVoted = [];

  List<Preference> _favoritesList = [];

  Future<bool?> showWarning(BuildContext context) async => showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Do you want to exit Noticias Sin FIltro?'),
          actions: [
            ElevatedButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('No')),
            ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Yes')),
          ],
        ),
      );

  @override
  void initState() {
    super.initState();
    _refreshFavorites();
    getMainScreenFromApi();
  }

  void _refreshFavorites() async {
    final data = await SQLHelper.getFavorites();
    setState(() {
      _favoritesList = data;
    });
  }

  void getMainScreenFromApi() async {
    Map mainResponse = await getAudioMain(widget.port);
    setState(() {
      _lastCapsule = mainResponse['lastCapsule'];
      _recentlyAdded = mainResponse['recentlyAdded'];
      _podcastAuthors = mainResponse['podcast_authors'];
      _newsAuthors = mainResponse['news_authors'];
      _basedOnListens = mainResponse['basedOnListens'];
      _mostVoted = mainResponse['mostVoted'];
    });
  }

  void ShowAuthorList(List<Author> authors) {
    context.read(selectedAuthorListProvider).state = authors;
  }

  @override
  Widget build(BuildContext context) {
    DateTime dt = DateTime.now();
    return Consumer(builder: (context, watch, _) {
      final selectedAuthorList = watch(selectedAuthorListProvider).state;
      return Scaffold(
        body: WillPopScope(
          onWillPop: () async {
            if (context.read(selectedAuthorListProvider).state == null &&
                context.read(selectedAuthorProvider).state == null) {
              final shouldPop = await showWarning(context);
              return shouldPop ?? false;
            } else {
              return true;
            }
          },
          child: Stack(
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
                          if (_lastCapsule.isNotEmpty) ...[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Column(
                                children: [
                                  // Container's tittle
                                  Row(
                                    children: [
                                      Text(
                                        'New capsule',
                                        style:
                                            Theme.of(context).textTheme.caption,
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
                          ],
                          const SizedBox(
                            height: 40.0,
                          ),

                          (_newsAuthors.isNotEmpty)
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: SizedBox(
                                    height: 40,
                                    child: Row(
                                      children: [
                                        // Container's tittle
                                        Text(
                                          'News Providers',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6,
                                        ),
                                        const Spacer(),
                                        (_newsAuthors.length > 2)
                                            ? IconButton(
                                                onPressed: (() {
                                                  context
                                                      .read(
                                                          selectedAuthorListProvider)
                                                      .state = _newsAuthors;
                                                }),
                                                icon: const Icon(Icons.list))
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
                              if (_newsAuthors.isNotEmpty) ...[
                                if (_newsAuthors.length > 1) ...[
                                  AuthorInfoCard(
                                      author: _newsAuthors[0],
                                      authors: _favoritesList,
                                      notifyParentRefresh: _refreshFavorites,
                                      port: widget.port),
                                  AuthorInfoCard(
                                      author: _newsAuthors[1],
                                      authors: _favoritesList,
                                      notifyParentRefresh: _refreshFavorites,
                                      port: widget.port),
                                ] else ...[
                                  AuthorInfoCard(
                                      author: _newsAuthors[0],
                                      authors: _favoritesList,
                                      notifyParentRefresh: _refreshFavorites,
                                      port: widget.port),
                                ]
                              ] else ...[
                                const SizedBox(
                                  height: 2,
                                ),
                              ]
                            ],
                          ),

                          const SizedBox(height: 30),

                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              children: [
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(60.0, 0, 0, 0),
                                  child: Text(
                                    'Listen our last content',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
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

                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                (_podcastAuthors.isNotEmpty)
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        child: SizedBox(
                                          height: 40,
                                          child: Row(
                                            children: [
                                              // Container's tittle
                                              Text(
                                                'Podcasts',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6,
                                              ),
                                              const Spacer(),
                                              (_podcastAuthors.length > 3)
                                                  ? IconButton(
                                                      onPressed: (() {
                                                        context
                                                                .read(
                                                                    selectedAuthorListProvider)
                                                                .state =
                                                            _podcastAuthors;
                                                      }),
                                                      icon: const Icon(
                                                          Icons.list))
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
                                SizedBox(
                                  child: Column(
                                    children: [
                                      if (_podcastAuthors.isNotEmpty) ...[
                                        if (_podcastAuthors.length > 2) ...[
                                          for (var i = 0; i < 3; i++) ...[
                                            Column(children: [
                                              const SizedBox(
                                                height: 10.0,
                                              ),
                                              Row(
                                                children: [
                                                  RowAuthorCard(
                                                    author: _podcastAuthors[i],
                                                    authors: _favoritesList,
                                                    notifyParentRefresh:
                                                        _refreshFavorites,
                                                    port: widget.port,
                                                  ),
                                                ],
                                              ),
                                            ]),
                                          ]
                                        ] else if (_podcastAuthors.length ==
                                            2) ...[
                                          for (var i = 0; i < 2; i++) ...[
                                            Column(children: [
                                              const SizedBox(
                                                height: 10.0,
                                              ),
                                              Row(
                                                children: [
                                                  RowAuthorCard(
                                                    author: _podcastAuthors[i],
                                                    authors: _favoritesList,
                                                    notifyParentRefresh:
                                                        _refreshFavorites,
                                                    port: widget.port,
                                                  ),
                                                ],
                                              ),
                                            ]),
                                          ]
                                        ] else if (_podcastAuthors.length ==
                                            1) ...[
                                          Column(children: [
                                            const SizedBox(
                                              height: 10.0,
                                            ),
                                            Row(
                                              children: [
                                                RowAuthorCard(
                                                  author: _podcastAuthors[0],
                                                  authors: _favoritesList,
                                                  notifyParentRefresh:
                                                      _refreshFavorites,
                                                  port: widget.port,
                                                ),
                                              ],
                                            ),
                                          ]),
                                        ]
                                      ] else ...[
                                        const SizedBox(
                                          height: 2,
                                        ),
                                      ],
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          /*
                          Slider of most listened audios
                        */
                          const SizedBox(
                            height: 20.0,
                          ),
                          if (_podcastAuthors.isNotEmpty) ...[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    "Based on number of listens",
                                    style:
                                        Theme.of(context).textTheme.headline6,
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
                          ],

                          /*
                          Slider of most voted
                        */
                          if (_podcastAuthors.isNotEmpty) ...[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    "The most voted",
                                    style:
                                        Theme.of(context).textTheme.headline6,
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
                          ]
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: selectedAuthorList != null,
                    child: AuthorListScreen(
                      port: widget.port,
                      authors: selectedAuthorList ?? [testAuthor],
                      favorites: _favoritesList,
                      notifyParentRefresh: _refreshFavorites,
                    ),
                  ),
                  (selectedAuthorList == null)
                      ? const SizedBox(
                          height: 60,
                          child: CustomScrollView(
                            slivers: [
                              CustomSliverAppBar(),
                            ],
                          ),
                        )
                      : const SizedBox(
                          width: 1.0,
                        ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
