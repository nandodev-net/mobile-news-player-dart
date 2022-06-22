import 'package:flutter/material.dart';
import 'package:noticias_sin_filtro/application_wrapper.dart';
import 'package:noticias_sin_filtro/entities/audio.dart';
import 'package:noticias_sin_filtro/entities/author.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noticias_sin_filtro/services/requests/get_search_results.dart';


class AudioSearchResponse extends StatefulWidget {
  final String keyword;
  final String port;
  const AudioSearchResponse({ Key? key, required this.keyword, required this.port }) : super(key: key);

  @override
  State<AudioSearchResponse> createState() => _AudioSearchResponseState();
}

class _AudioSearchResponseState extends State<AudioSearchResponse> {
  final ScrollController _scrollController = ScrollController();
  List<Audio> items = [];
  bool loading = false, allLoaded = false;
  List<String> _nextUrl = [];

  @override
  void initState() {
    super.initState();
    mockFetch(widget.port, widget.keyword, []);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !loading) {
        mockFetch(widget.port, widget.keyword, _nextUrl);
      }
    });
  }

  mockFetch(String port, String keyword, List<String> nextUrl) async {
    if (allLoaded) {
      return;
    }

    setState(() {
      loading = true;
      _nextUrl = [];
    });

    Map authorApiResponse = await getSearchResults(port, keyword, nextUrl);

    if (authorApiResponse['audios'].isNotEmpty) {
      items.addAll(authorApiResponse['audios']);
    } else {
      setState(() {
        allLoaded = true;
      }); //#TODO revisar caso artista sin audios
    }

    setState(() {
      loading = false;
      if (authorApiResponse['nextUrl'] == null) {
        allLoaded = true;
      } else {
        _nextUrl.add(authorApiResponse['nextUrl']);
        allLoaded = false;
      }
    });
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

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }



  @override
  Widget build(BuildContext context) {
    if (items.isNotEmpty) {
      return Stack(children: [
        ListView.separated(
            controller: _scrollController,
            itemBuilder: (context, index) {
              if (index < items.length) {
                return ListTile(
                  leading: Image.network(items[index].thumbnailUrl),
                  title: Text("${items[index].title} - ${items[index].author}"),
                  subtitle: Text(
                    _printDuration(parseDuration(items[index].duration)),
                    style: Theme.of(context).textTheme.caption,
                  ),
                  onTap: () {
                    context.read(selectedAudioProvider).state = items[index];
                  },
                );
              } else {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50.0,
                  child: const Center(child: Text("Nothing more to Load")),
                );
              }
            },
            separatorBuilder: (context, index) {
              return const Divider(
                height: 1.0,
                color: Colors.black,
              );
            },
            itemCount: items.length + (allLoaded ? 1 : 0)),
        if (loading) ...[
          Positioned(
            left: 0,
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 80.0,
              child: const Center(child: CircularProgressIndicator()),
            ),
          ),
        ]
      ]);
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}