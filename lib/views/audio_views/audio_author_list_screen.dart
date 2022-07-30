import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noticias_sin_filtro/application_wrapper.dart';
import 'package:noticias_sin_filtro/database/db_helper.dart';
import 'package:noticias_sin_filtro/entities/author.dart';
import 'package:noticias_sin_filtro/views/audio_views/audio_main_screen.dart';
import 'package:noticias_sin_filtro/views/audio_widgets/audio_alertDialog.dart';
import 'package:noticias_sin_filtro/views/audio_widgets/widgets.dart';

class AuthorListScreen extends StatefulWidget {
  final List<Author> authors;
  final String port;
  final Function() notifyParent;

  const AuthorListScreen({Key? key, required this.authors, required this.port, required this.notifyParent})
      : super(key: key);
  @override
  _AuthorListScreenState createState() => _AuthorListScreenState();
}

/*
  Author screen, here we'll list every audio of one selected
  author.
*/
class _AuthorListScreenState extends State<AuthorListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: () {
                    widget.notifyParent();
                    context.read(selectedAuthorListProvider).state = null;
                  },
                  child: const Icon(
                    Icons.keyboard_arrow_left,
                    size: 38,
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 500,
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: [
                for (var author in widget.authors) ...[
                  AuthorListTile(author: author, port: widget.port),

                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AuthorListTile extends StatefulWidget {
  final Author author;
  final String port;

  const AuthorListTile({Key? key, required this.author, required this.port})
      : super(key: key);

  @override
  State<AuthorListTile> createState() => _AuthorListTileState();
}

class _AuthorListTileState extends State<AuthorListTile> {
  List<Map<String, dynamic>> _favorites = [];

  @override
  void initState() {
    super.initState();
    _refreshFavorites();
  }

  void _refreshFavorites() async {
    final data = await SQLHelper.getFavoritebyId(widget.author.id);
    setState(() {
      _favorites = data;
    });
  }

  _showDialog(BuildContext context) {
    VoidCallback continueCallBack = () async => {
          Navigator.of(context).pop(),
          // code on continue comes here
          await SQLHelper.deleteFavorite(widget.author.id),
          _refreshFavorites()
        };
    BlurryDialog alert = BlurryDialog(
        "Unfollow",
        "Are you sure you want to unfollow ${widget.author.name}?",
        continueCallBack);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> onLikeButtonTapped() async {
    /// send your request here
    // final bool success= await sendRequest();
    _favorites.isNotEmpty
        ? _showDialog(context)
        : await SQLHelper.createFavorite(widget.author.id);

    _refreshFavorites();

    /// if failed, you can do nothing
    // return success? !isLiked:isLiked;
  }


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: CircleAvatar(
            backgroundColor: (_favorites.isNotEmpty)
                ? Colors.green
                : const Color.fromARGB(158, 0, 0, 0),
            radius: 25,
            child: CircleAvatar(
              radius: 22,
              backgroundImage: NetworkImage(
                widget.author.thumbnailUrl,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(widget.author.name,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        Spacer(),
        Center(
          child: SizedBox(
            width: 85,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: TextButton(
                  onPressed: onLikeButtonTapped,
                  child: (_favorites.isNotEmpty)
                      ? Row(
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            const Icon(
                              Icons.touch_app,
                              size: 15.0,
                              color: Colors.green,
                            ),
                            const Text(
                              'Following',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      : Row(
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            const Icon(
                              Icons.touch_app,
                              size: 15.0,
                              color: Colors.grey,
                            ),
                            const Text(
                              'Follow',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 8),
                          ],
                        )),
            ),
          ),
        )
      ],
    );
  }
}
