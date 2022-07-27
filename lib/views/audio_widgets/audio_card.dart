import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noticias_sin_filtro/application_wrapper.dart';
import 'package:noticias_sin_filtro/entities/audio.dart';
import 'package:noticias_sin_filtro/views/audio_widgets/audio_controller.dart';

class AudioCard extends StatelessWidget {
  final Audio audio;
  const AudioCard({Key? key, required this.audio}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      
        width: 140.0,
        height: 180.0,
        child: GestureDetector(
          onTap: () {
            context.read(selectedAudioProvider).state = audio;
          },
          child: Column(
            children: [
              Image.network(
                audio.thumbnailUrl.toString(),
                width: 140.0,
                height: 140.0,
              ),
              Text(
                "${audio.title} - ${audio.author}",
                style: Theme.of(context).textTheme.caption,
                softWrap: true,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              )
            ],
          ),
        ));
  }
}

class RowAudioCard extends StatelessWidget {
  final Audio audio;

  const RowAudioCard({Key? key, required this.audio}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, _) {
      return Expanded(
        flex: 1,
        child: GestureDetector(
          onTap: () {
            context.read(selectedAudioProvider).state = audio;
          },
          child: Card(
            color: Color.fromARGB(226, 255, 255, 255),
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 10,
            shadowColor: Colors.black,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: const Color.fromARGB(26, 26, 25, 25),
                borderRadius: BorderRadius.circular(4),
              ),
              clipBehavior: Clip.antiAlias,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      iconSize: 60,
                      icon: Container(
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(144, 0, 0, 0)),
                        child: Center(
                          child: Icon(
                            watch(audioProvider).playerAudioState == "PLAY"
                                ? Icons.pause
                                : Icons.play_arrow,
                            size: 28,
                            color: Color.fromARGB(207, 255, 255, 255),
                          ),
                        ),
                      ),
                      onPressed: () {
                        }),
                  // Text(
                  //   "${audio.title} - ${audio.author}",
                  //   style: Theme.of(context).textTheme.caption,
                  // ),
                  Text('Play the last news capsule'),
                  const SizedBox(
                    width: 20,
                  ),
                  // Text(
                  //   _printDuration(parseDuration(audio.duration)),
                  //   style: Theme.of(context).textTheme.caption,
                  // ),
                  const SizedBox(
                    width: 20,
                  )
                  // const Padding(
                  //   padding: EdgeInsets.fromLTRB(0,0,15,0),
                  //   child: Icon(
                  //     Icons.play_arrow,
                  //     color: Colors.black,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}