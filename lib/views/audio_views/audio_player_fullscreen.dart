import 'package:flutter/material.dart';

class PlayerScreen extends StatefulWidget {
  final String thumbnailUrl;
  const PlayerScreen({ Key? key, required this.thumbnailUrl }) : super(key: key);

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late ScrollController scrollController;
  double imageOpacity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // here's we defined the decoration of the main container.
          Container(
            height: 500.0,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            color: Color.fromARGB(255, 30, 233, 206),
            child: Wrap(
              children: [Column(
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
                        widget.thumbnailUrl,
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
              ),]
            ),
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                Center(
                                  child: Text(
                                    widget.thumbnailUrl,
                                    style: Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 17.0),
                                    ),
                                ),
                                const SizedBox(height: 120),

                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}