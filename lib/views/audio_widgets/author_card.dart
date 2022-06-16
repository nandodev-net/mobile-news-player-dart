import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noticias_sin_filtro/application_wrapper.dart';
import 'package:noticias_sin_filtro/entities/author.dart';
import 'package:noticias_sin_filtro/views/audio_views/audio_author_screen.dart';
import 'package:like_button/like_button.dart';
import 'package:decorated_icon/decorated_icon.dart';

class AuthorCard extends StatelessWidget {
  final Author author;
  final String port;

  AuthorCard({Key? key, required this.author, required this.port})
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
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () {
          context.read(selectedAuthorProvider).state = widget.author;
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => AuthorScreen(
          //             port: widget.port,
          //             author: widget.author,
          //           )),
          // );
        },
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(26, 26, 25, 25),
            borderRadius: BorderRadius.circular(4),
          ),
          clipBehavior: Clip.antiAlias,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.network(
                widget.author.thumbnailUrl.toString(),
                height: 48,
                width: 48,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 8),
              Text(widget.author.name),
              const SizedBox(width: 8),
              Center(
                child: LikeButton(
                  size: 30.0,
                  likeBuilder: (isTapped) {
                    return DecoratedIcon(
                      Icons.star,
                      color: isTapped ? Colors.yellowAccent : Colors.grey,
                      shadows: [
                        BoxShadow(
                          blurRadius: 15.0,
                          color: isTapped ? Colors.grey : Colors.transparent,
                        ),
                      ],
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
