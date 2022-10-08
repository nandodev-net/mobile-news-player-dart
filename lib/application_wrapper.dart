import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:noticias_sin_filtro/entities/audio.dart';
import 'package:noticias_sin_filtro/entities/author.dart';
import 'package:noticias_sin_filtro/views/audio_views/audio_author_screen.dart';
import 'package:noticias_sin_filtro/views/audio_views/audio_main_screen.dart';
import 'package:noticias_sin_filtro/views/audio_views/audio_player_fullscreen.dart';
import 'package:noticias_sin_filtro/views/categories.dart';
import 'package:noticias_sin_filtro/views/news_list.dart';
import 'package:noticias_sin_filtro/views/navigate.dart';
import 'package:noticias_sin_filtro/views/news_sites.dart';
import 'package:noticias_sin_filtro/views/vpn_config.dart';
import 'package:noticias_sin_filtro/views/audio_widgets/audio_controller.dart';

final selectedAudioProvider = StateProvider<Audio?>((ref) => null);
final selectedAuthorProvider = StateProvider<Author?>((ref) => null);
final proxyProvider = StateProvider<String>((ref) => "");

class ApplicationWrapper extends StatefulWidget {
  const ApplicationWrapper({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<ApplicationWrapper> createState() => ApplicationWrapperState();
}

class ApplicationWrapperState extends State<ApplicationWrapper> {
  static const double _playerMinHeight = 60.0;
  bool _connected = false;
  // final _key = UniqueKey();
  var url = "https://whatismyipaddress.com/";
  var _proxyPort = null;
  int _bottomNavIndex = 0;

  @override
  void initState() {
    super.initState();
    _connect();
    //getData();
  }

  ////// Functions to handle Bottom Navigation //////

  void _onBottomNavItemTapped(int index) {
    context.read(selectedAuthorProvider).state = null;
    context.read(selectedAuthorListProvider).state = null;
    setState(() {
      _bottomNavIndex = index;
    });
  }

  void _onBottomPageChanged(int page) {
    setState(() {
      _bottomNavIndex = page;
    });
  }

  /////// Functions to handle VPN //////
  final MethodChannel _VPNconnectionMethodChannel =
      MethodChannel("noticias_sin_filtro/vpn_connection");

  Future<String> connectWithVPN() async {
    final proxyPort = await _VPNconnectionMethodChannel.invokeMethod("connect");
    print("proxyPort from Android $proxyPort");
    return proxyPort;
  }

  void _connect() async {
    var _port = await connectWithVPN();

    setState(() {
      context.read(proxyProvider).state = _port;
      _proxyPort = _port;
    });

    setState(() {
      _connected = true;
    });
  }

  void _disconnect() async {
    String result =
        await _VPNconnectionMethodChannel.invokeMethod("disconnect");

    setState(() {
      context.read(proxyProvider).state = "";
      _proxyPort = null;
    });

    setState(() {
      _connected = false;
    });
  }

  void _redirectToVPNConfig() {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => VpnConfig(
                connect: _connect,
                disconnect: _disconnect,
                port: _proxyPort ?? "",
                status: _connected,
              )),
    );
  }

  // void _navigate() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) =>  WebviewWrapper(
  //         url:"https://whatismyipaddress.com/",
  //         title: "Check your IP",
  //         port:_proxyPort)),
  //     );
  // }

  //final PageStorageBucket bucket = PageStorageBucket();

  // void rebuildAllChildren(BuildContext context) {
  //   void rebuild(Element el) {
  //     el.markNeedsBuild();
  //     el.visitChildren(rebuild);
  //   }
  //   (context as Element).visitChildren(rebuild);
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, _) {
      final selectedAudio = watch(selectedAudioProvider).state;
      final selectedAuthor = watch(selectedAuthorProvider).state;
      return Scaffold(
          appBar: AppBar(
            title: Text(
              widget.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.white,
            foregroundColor: Colors.grey[600],
            actions: <Widget>[
              TextButton(
                  style: TextButton.styleFrom(
                      primary: Theme.of(context).colorScheme.onPrimary),
                  onPressed: _redirectToVPNConfig,
                  child: Text.rich(
                    TextSpan(
                        text: _connected ? 'VPN ON ' : 'VPN OFF ',
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.bold,
                            fontSize: 13),
                        children: <TextSpan>[
                          TextSpan(
                              text: '■',
                              style: TextStyle(
                                  color: _connected
                                      ? Colors.green
                                      : Colors.redAccent,
                                  fontSize: 17,
                                  height: 1)),
                        ]),
                    textAlign: TextAlign.center,
                  ))
            ],
          ),
          body: Stack(
            children: [
              IndexedStack(
                index: _bottomNavIndex,
                children: <Widget>[
                  NewsList(
                    port: _proxyPort ?? "",
                    showNewsAppBar: true,
                  ),
                  NewsSites(port: _proxyPort ?? "", showNewsAppBar: false),
                  Navigate(port: _proxyPort ?? ""),
                  Categories(port: _proxyPort ?? ""),
                  MainScreen(port: _proxyPort ?? ""),
                ],
              ),

              Visibility(
                visible: selectedAuthor != null,
                child: AuthorScreen(
                    port: _proxyPort ?? "",
                    author: selectedAuthor ?? testAuthor),
              ),
              Visibility(
                visible: selectedAudio != null,
                child: Miniplayer(
                  maxHeight: MediaQuery.of(context).size.height,
                  minHeight: _playerMinHeight,
                  builder: (height, percentage) {
                    // if not selected audio, do not show the miniplayer
                    if (selectedAudio == null) return const SizedBox.shrink();
                    // setting the height of the miniplayer, and the full scrren player
                    if (height <= _playerMinHeight + 50.0) {
                      // Audio reproduction init
                      if (watch(audioProvider).playerAudioState != "PAUSE") {
                        watch(audioProvider).initAudio(selectedAudio);
                      }

                      return Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Image.network(
                                  selectedAudio.thumbnailUrl,
                                  height: _playerMinHeight - 4.0,
                                  width: _playerMinHeight - 4.0,
                                  fit: BoxFit.cover,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flexible(
                                            child: Text(
                                          selectedAudio.title,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption!
                                              .copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black),
                                        )),
                                        Flexible(
                                          child: Text(
                                            selectedAudio.author,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption!
                                                .copyWith(
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    watch(audioProvider).playerAudioState ==
                                            "PLAY"
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                  ),
                                  onPressed: () {
                                    watch(audioProvider).playerAudioState ==
                                            "PLAY"
                                        ? watch(audioProvider).pauseAudio()
                                        : watch(audioProvider).playAudio();
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    context.read(selectedAudioProvider).state =
                                        null;
                                    watch(audioProvider).stopAudio();
                                  },
                                ),
                              ],
                            ),
                            LinearProgressIndicator(
                              value: watch(audioProvider).currentSliderPosition,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Color.fromARGB(255, 0, 255, 34)),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return PlayerScreen(audio: selectedAudio);
                    }
                  },
                ),
              )
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.red,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Inicio',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: 'Medios',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.rss_feed),
                label: 'Navega',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.category),
                label: 'Categorías',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.music_note),
                label: 'Audio',
              ),
            ],
            currentIndex: _bottomNavIndex,
            selectedItemColor: Colors.blue[700],
            unselectedItemColor: Colors.grey[600],
            // iconSize: 40,
            //type: BottomNavigationBarType.fixed,
            iconSize: 25,
            onTap: _onBottomNavItemTapped,
          ));
    });
  }
}
