import 'package:flutter/material.dart';
import 'package:noticias_sin_filtro/application_wrapper.dart';
import 'package:noticias_sin_filtro/database/db_helper.dart';
import 'package:noticias_sin_filtro/entities/audio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noticias_sin_filtro/entities/author.dart';
import 'package:noticias_sin_filtro/services/requests/patch_audio_votes.dart';
import 'package:noticias_sin_filtro/views/audio_widgets/audio_controller.dart';

final selectedFF = StateProvider<Audio?>((ref) => null);

class PlayerScreen extends StatefulWidget {
  final Audio audio;
  final String port;
  const PlayerScreen({Key? key, required this.port, required this.audio})
      : super(key: key);

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  List<Map<String, dynamic>> _voted = [];

  @override
  void initState() {
    super.initState();
    _refreshVoted();
  }

  void _refreshVoted() async {
    final data = await SQLHelper.getVotedbyId(widget.audio.id);
    setState(() {
      _voted = data;
    });
  }

  Future<void> onLikeButtonTapped() async {
    /// send your request here
    // final bool success= await sendRequest();
    if (_voted.isNotEmpty) {
      await patchAudioVotes(widget.port, widget.audio.id, 0);
      await SQLHelper.deleteVoted(widget.audio.id);
    } else {
      await patchAudioVotes(widget.port, widget.audio.id, 1);
      await SQLHelper.createVoted(widget.audio.id);
    }

    _refreshVoted();

    /// if failed, you can do nothing
    // return success? !isLiked:isLiked;
  }

  Duration parseDuration(String s) {
    int hours = 0;
    int minutes = 0;
    int micros;
    List<String> parts = s.split(':');
    if (parts.length > 2) {
      hours = int.parse(parts[parts.length - 3]);
    }
    if (parts.length > 1) {
      minutes = int.parse(parts[parts.length - 2]);
    }
    micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
    return Duration(hours: hours, minutes: minutes, microseconds: micros);
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    if (twoDigits(duration.inHours) != "00") {
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    }
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  late ScrollController scrollController;
  double imageOpacity = 1;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, _) {
      return Scaffold(
        body: Stack(
          children: [
            // here's we defined the decoration of the main container.
            Container(
              height: 500.0,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.green.withOpacity(1),
                    Colors.white.withOpacity(0.8),
                    Colors.white.withOpacity(0.9),
                  ],
                ),
              ),
              child: Wrap(children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Opacity(
                      opacity: imageOpacity.clamp(0, 1.0),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.5),
                              offset: const Offset(0, 20),
                              blurRadius: 32,
                              spreadRadius: 16,
                            )
                          ],
                        ),
                        child: Image.network(
                          widget.audio.thumbnailUrl,
                          width: 240,
                          height: 240,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              ]),
            ),
            SafeArea(
              // Below comes the bouncing physics of the container.
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withOpacity(0),
                            Colors.white.withOpacity(0),
                            Colors.white.withOpacity(1),
                          ],
                        ),
                      ),
                      // here comes the data of the autor (name, votes, description)
                      child: Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Column(
                          children: [
                            const SizedBox(height: 232.0),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(
                                          children: [
                                            const SizedBox(width: 210),
                                            IconButton(
                                              iconSize: 55,
                                              icon: Container(
                                                decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.green),
                                                child: Center(
                                                  child: Icon(
                                                    (_voted.isNotEmpty)
                                                        ? Icons.favorite
                                                        : Icons
                                                            .favorite_outline,
                                                    size: 30,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              onPressed: onLikeButtonTapped,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 250,
                                          child: Text(
                                            widget.audio.title,
                                            softWrap: true,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 250,
                                          child: Text(
                                            widget.audio.author,
                                            maxLines: 1,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black
                                                    .withOpacity(0.5)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Slider(
                        activeColor: const Color.fromARGB(255, 0, 255, 34),
                        value: watch(audioProvider)
                                .currentAudioPosition
                                ?.inMilliseconds
                                .toDouble() ??
                            0.0,
                        min: 0.0,
                        max: watch(audioProvider)
                                .totalAudioDuration
                                ?.inMilliseconds
                                .toDouble() ??
                            0.0,
                        onChanged: (value) {
                          setState(() {
                            watch(audioProvider).seekAudio(
                                Duration(milliseconds: value.toInt()));
                          });
                          //seekSound();
                        }),
                    const SizedBox(
                      height: 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _printDuration(parseDuration(watch(audioProvider)
                                .currentAudioPosition
                                .toString())),
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.5)),
                          ),
                          Text(
                            _printDuration(parseDuration(watch(audioProvider)
                                .totalAudioDuration
                                .toString())),
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.5)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              //context.read(selectedAuthorProvider).state = widget.audio.author;
                            },
                            child: IconButton(
                              icon: Icon(
                                Icons.menu_book,
                                color: Colors.black.withOpacity(0.8),
                                size: 40,
                              ),
                              onPressed: () {
                                context.read(selectedAuthorProvider).state =
                                    Author(
                                        id: widget.audio.authorId.toInt(),
                                        followers: int.parse(
                                            widget.audio.authorFollowers),
                                        name: widget.audio.author,
                                        thumbnailUrl: widget.audio.thumbnailUrl,
                                        type: widget.audio.authorType,
                                        description:
                                            widget.audio.authorDescription);
                              },
                            ),
                          ),
                          IconButton(
                              iconSize: 65,
                              icon: Container(
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.green),
                                child: Center(
                                  child: Icon(
                                    watch(audioProvider).playerAudioState ==
                                            "PLAY"
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    size: 38,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                watch(audioProvider).playerAudioState == "PLAY"
                                    ? watch(audioProvider).pauseAudio()
                                    : watch(audioProvider).playAudio();
                              }),
                          IconButton(
                              icon: Icon(
                                Icons.skip_next,
                                color: Colors.black.withOpacity(0.8),
                                size: 40,
                              ),
                              onPressed: null),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
