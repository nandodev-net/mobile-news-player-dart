import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noticias_sin_filtro/application_wrapper.dart';
import 'package:noticias_sin_filtro/entities/author.dart';
import 'package:noticias_sin_filtro/views/audio_widgets/widgets.dart';

class AuthorScreen extends StatefulWidget {
  final Author author;
  final String port;

  const AuthorScreen({Key? key, required this.author, required this.port})
      : super(key: key);
  @override
  _AuthorScreenState createState() => _AuthorScreenState();
}

/*
  Author screen, here we'll list every audio of one selected
  author.
*/
class _AuthorScreenState extends State<AuthorScreen> {
  late ScrollController scrollController;
  double imageSize = 0;
  double initialSize = 240;
  double containerHeight = 500;
  double containerinitalHeight = 500;
  double imageOpacity = 1;
  bool showTopBar = false;

  @override
  void initState() {
    imageSize = initialSize;
    // this is the main image resize controller.
    scrollController = ScrollController()
      ..addListener(() {
        imageSize = initialSize - scrollController.offset;
        if (imageSize < 0) {
          imageSize = 0;
        }
        containerHeight = containerinitalHeight - scrollController.offset;
        if (containerHeight < 0) {
          containerHeight = 0;
        }
        imageOpacity = imageSize / initialSize;
        if (scrollController.offset > 224) {
          showTopBar = true;
        } else {
          showTopBar = false;
        }
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // here's we defined the decoration of the main container.
          Container(
            height: containerHeight,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            color: Colors.pink,
            child: Column(
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
                      widget.author.thumbnailUrl,
                      width: imageSize,
                      height: imageSize,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
          SafeArea(
            // Below comes the bouncing physics of the container.
            child: SingleChildScrollView(
              controller: scrollController,
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
                          const SizedBox(height: 250.0),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.author.name,
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Voted 1,878,555 times",
                                      style:
                                          Theme.of(context).textTheme.caption,
                                    ),
                                    const SizedBox(width: 80),
                                    const Image(
                                      image:
                                          AssetImage('assets/logo-light.png'),
                                      width: 48,
                                      height: 48,
                                    ),
                                    const Text("NoticiasSinFiltro"),
                                  ],
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  // In this container goes the playlist #TODO
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.author.description),
                        const SizedBox(height: 32),
                        Text(
                          "Audio Track History",
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        SizedBox(
                          height: 500,
                          child: AudioPlaylist(
                              author: widget.author, port: widget.port),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          // Upper app bar with return buttom
          Positioned(
              child: Container(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              color: showTopBar
                  ? const Color(0xFFC61855).withOpacity(1)
                  : const Color(0xFFC61855).withOpacity(0),
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: SafeArea(
                child: Container(
                  height: 40.0,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        left: 0,
                        child: GestureDetector(
                          onTap: () {
                            context.read(selectedAuthorProvider).state = null;
                          },
                          child: const Icon(
                            Icons.keyboard_arrow_left,
                            size: 38,
                          ),
                        ),
                      ),
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 250),
                        opacity: showTopBar ? 1 : 0,
                        child: Text(
                          widget.author.name,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ))
        ],
      ),
    );
  }
}
