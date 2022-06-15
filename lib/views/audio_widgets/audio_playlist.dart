import 'package:flutter/material.dart';
import 'package:noticias_sin_filtro/entities/audio.dart';
import 'package:noticias_sin_filtro/entities/author.dart';

import '../../services/requests/get_audio_author.dart';

class AudioPlaylist extends StatefulWidget {
  final Author author;
  final String port;
  const AudioPlaylist({Key? key, required this.author, required this.port})
      : super(key: key);

  @override
  State<AudioPlaylist> createState() => _AudioPlaylistState();
}

class _AudioPlaylistState extends State<AudioPlaylist> {
  final ScrollController _scrollController = ScrollController();
  List<Audio> items = [];
  bool loading = false, allLoaded = false;
  List<String> _nextUrl = [];

  @override
  void initState() {
    super.initState();
    mockFetch(widget.port, widget.author.id, []);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !loading) {
        mockFetch(widget.port, widget.author.id, _nextUrl);
      }
    });
  }

  mockFetch(String port, int authorId, List<String> nextUrl) async {
    if (allLoaded) {
      return;
    }

    setState(() {
      loading = true;
      _nextUrl = [];
    });

    Map authorApiResponse = await getAudioAuthor(port, authorId, nextUrl);

    if (authorApiResponse['audios'].isNotEmpty) {
      items.addAll(authorApiResponse['audios']);
    } else {
      setState(() {
        allLoaded = true;
        loading = false;
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
                  title: Text(items[index].title),
                );
              } else {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50.0,
                  child: Center(child: Text("Nothing more to Load")),
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
              child: Center(child: CircularProgressIndicator()),
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
