import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noticias_sin_filtro/application_wrapper.dart';
import 'package:noticias_sin_filtro/database/db_helper.dart';
import 'package:noticias_sin_filtro/entities/author.dart';
import 'package:noticias_sin_filtro/views/audio_views/audio_author_screen.dart';
import 'package:noticias_sin_filtro/views/audio_widgets/audio_alertDialog.dart';

class AuthorCard extends StatelessWidget {
  final Author author;
  final String port;

  const AuthorCard({Key? key, required this.author, required this.port})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AuthorScreen(
                    author: author,
                    port: port,
                  )),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            author.thumbnailUrl.toString(),
            width: 120,
            height: 120,
            fit: BoxFit.cover,
          ),
          const SizedBox(
            height: 10.0,
          ),
          Text(author.name)
        ],
      ),
    );
  }
}

class RowAuthorCard extends StatefulWidget {
  final Author author;
  final String port;

  const RowAuthorCard({Key? key, required this.author, required this.port})
      : super(key: key);

  @override
  State<RowAuthorCard> createState() => _RowAuthorCardState();
}

class _RowAuthorCardState extends State<RowAuthorCard> {
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
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () {
          context.read(selectedAuthorProvider).state = widget.author;
        },
        child: Card(
          color: const Color.fromARGB(240, 255, 255, 255),
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 10,
          shadowColor: Colors.black,
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(26, 26, 25, 25),
              borderRadius: BorderRadius.circular(4),
            ),
            clipBehavior: Clip.antiAlias,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.bold)),
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
            ),
          ),
        ),
      ),
    );
  }
}

class AuthorInfoCard extends StatefulWidget {
  final Author author;
  final String port;
  const AuthorInfoCard({Key? key, required this.author, required this.port})
      : super(key: key);

  @override
  State<AuthorInfoCard> createState() => _AuthorInfoCardState();
}

class _AuthorInfoCardState extends State<AuthorInfoCard> {
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
    return GestureDetector(
      onTap: () {
        context.read(selectedAuthorProvider).state = widget.author;
      },
      child: Card(
        color: const Color.fromARGB(167, 255, 255, 255),
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: SizedBox(
          width: 160,
          height: 305,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: (_favorites.isNotEmpty)
                      ? Colors.green
                      : const Color.fromARGB(158, 0, 0, 0),
                  radius: 58,
                  child: CircleAvatar(
                    radius: 55,
                    backgroundImage: NetworkImage(
                      widget.author.thumbnailUrl,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(2, 5, 2, 0),
                  child: SizedBox(
                    height: 33,
                    child: Text(
                      widget.author.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 70,
                    child: Text(widget.author.description,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.caption),
                  ),
                ),
                SizedBox(
                  width: 112,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      onPressed: onLikeButtonTapped,
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              (_favorites.isNotEmpty)
                                  ? Colors.green
                                  : Colors.transparent)),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.touch_app,
                              size: 20.0,
                            ),
                            (_favorites.isNotEmpty)
                                ? const Text(
                                    "Following",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 12),
                                  )
                                : const Text(
                                    "Follow",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 12),
                                  )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 10,
        shadowColor: Colors.black,
        margin: const EdgeInsets.all(10),
      ),
    );
  }
}
