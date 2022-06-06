import 'dart:ffi';

import 'package:flutter/material.dart';

class AudioPlaylist extends StatefulWidget {
  const AudioPlaylist({Key? key}) : super(key: key);

  @override
  State<AudioPlaylist> createState() => _AudioPlaylistState();
}

class _AudioPlaylistState extends State<AudioPlaylist> {
  final ScrollController _scrollController = ScrollController();
  List<String> items = [];
  bool loading = false, allLoaded = false;

  // THIS SIMULATES THE API
  mockFetch() async {
    if (allLoaded) {
      return;
    }

    setState(() {
      loading = true;
    });

    await Future.delayed(Duration(milliseconds: 500));
    List<String> newData = items.length >= 60
        ? []
        : List.generate(20, (index) => "Audio Track ${index + items.length}");
    if (newData.isNotEmpty) {
      items.addAll(newData);
    }

    setState(() {
      loading = false;
      allLoaded = newData.isEmpty;
    });
  }
  ////////////////////////////////////////////////////

  @override
  void initState() {
    super.initState();
    mockFetch();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !loading) {
        mockFetch();
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
                title: Text(items[index]),
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
            itemCount: items.length + (allLoaded?1:0)),
        if (loading)...[Positioned(
          left: 0,
          bottom: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 80.0,
            child: Center(child: CircularProgressIndicator()),
          ),
        ),]
      ]);
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
