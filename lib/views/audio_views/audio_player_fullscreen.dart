import 'package:flutter/material.dart';
import 'package:noticias_sin_filtro/entities/audio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noticias_sin_filtro/views/audio_widgets/audio_controller.dart';

final selectedFF = StateProvider<Audio?>((ref) => null);

class PlayerScreen extends StatefulWidget {
  final Audio audio;
  const PlayerScreen({Key? key, required this.audio}) : super(key: key);

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
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
    if (twoDigits(duration.inHours) != "00")
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  late ScrollController scrollController;
  double imageOpacity = 1;
  double _currentSliderValue = 20;

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
                            const SizedBox(height: 272.0),
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
                                        SizedBox(
                                          height: 30.0,
                                        ),
                                        Text(
                                          widget.audio.title,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Container(
                                          width: 150,
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
                        activeColor: Colors.green,
                        value: watch(audioProvider)
                                .currentAudioPosition
                                ?.inMilliseconds
                                .toDouble() ??
                            0.0,
                        min: 0,
                        max: watch(audioProvider)
                                .totalAudioDuration
                                ?.inMilliseconds
                                .toDouble() ??
                            0.0,
                        onChanged: (value) {
                          setState(() {
                            // _currentSliderValue = value;
                          });
                          //seekSound();
                        }),
                    SizedBox(
                      height: 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            watch(audioProvider).playerAudioState,
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.5)),
                          ),
                          Text(
                            _printDuration(
                                parseDuration(widget.audio.duration)),
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.5)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              icon: Icon(
                                Icons.skip_previous,
                                color: Colors.black.withOpacity(0.8),
                                size: 25,
                              ),
                              onPressed: null),
                          IconButton(
                              iconSize: 50,
                              icon: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.green),
                                child: Center(
                                  child: Icon(
                                    watch(audioProvider).playerAudioState ==
                                            "PLAY"
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    size: 28,
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
                                size: 25,
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
