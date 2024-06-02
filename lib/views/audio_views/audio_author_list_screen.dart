import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noticias_sin_filtro/application_wrapper.dart';
import 'package:noticias_sin_filtro/database/db_helper.dart';
import 'package:noticias_sin_filtro/entities/author.dart';
import 'package:noticias_sin_filtro/services/requests/patch_author_followers.dart';
import 'package:noticias_sin_filtro/views/audio_views/audio_main_screen.dart';
import 'package:noticias_sin_filtro/views/audio_widgets/audio_alertDialog.dart';
import 'package:noticias_sin_filtro/views/audio_widgets/widgets.dart';

class AuthorListScreen extends StatefulWidget {
  final List<Author> authors;
  final List<Preference> favorites;
  final String port;
  final Function() notifyParentRefresh;

  const AuthorListScreen(
      {Key? key,
      required this.authors,
      required this.favorites,
      required this.port,
      required this.notifyParentRefresh})
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
      body: WillPopScope(
        onWillPop: () async {
          context.read(selectedAuthorListProvider).state = null;
          return false;
        },
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onTap: () {
                      widget.notifyParentRefresh();
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
                    AuthorListTile(
                      author: author,
                      port: widget.port,
                      favorites: widget.favorites,
                      notifyParentRefresh: widget.notifyParentRefresh,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthorListTile extends StatefulWidget {
  final Author author;
  final List<Preference> favorites;
  final Function() notifyParentRefresh;
  final String port;

  const AuthorListTile(
      {Key? key,
      required this.author,
      required this.favorites,
      required this.port,
      required this.notifyParentRefresh})
      : super(key: key);

  @override
  State<AuthorListTile> createState() => _AuthorListTileState();
}

class _AuthorListTileState extends State<AuthorListTile> {
  List<Map<String, dynamic>> _favorites = [];

  @override
  void initState() {
    super.initState();
    widget.notifyParentRefresh();
  }

  _showDialog(BuildContext context) {
    VoidCallback continueCallBack = () async => {
          Navigator.of(context).pop(),
          // code on continue comes here
          await patchAuthorFollowers(widget.port, widget.author.id, 0),
          await SQLHelper.deleteFavorite(widget.author.id),
          widget.notifyParentRefresh(),
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
    if (checkFavorite(widget.favorites)){
      _showDialog(context);
    } else{
      await SQLHelper.createFavorite(widget.author.id);
      await patchAuthorFollowers(widget.port, widget.author.id, 1);
    }

    widget.notifyParentRefresh();
    ;

    /// if failed, you can do nothing
    // return success? !isLiked:isLiked;
  }

  checkFavorite(List<Preference> favorites) {
    List result =
        favorites.where((element) => element.id == widget.author.id).toList();
    return (result.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read(selectedAuthorProvider).state = widget.author;
      },
      child: Card(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: CircleAvatar(
                backgroundColor: (checkFavorite(widget.favorites))
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
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            const Spacer(),
            Center(
              child: SizedBox(
                width: 85,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: TextButton(
                      onPressed: onLikeButtonTapped,
                      child: (checkFavorite(widget.favorites))
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
        ),
      ),
    );
  }
}
