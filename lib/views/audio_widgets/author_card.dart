import 'package:flutter/material.dart';
import 'package:noticias_sin_filtro/data.dart';
import 'package:noticias_sin_filtro/views/audio_views/audio_author_screen.dart';
import 'package:like_button/like_button.dart';
import 'package:decorated_icon/decorated_icon.dart';

class AuthorCard extends StatelessWidget {
  final String image;
  final String label;
  final double size;

  AuthorCard({
    Key? key,
    required this.image,
    required this.label,
    this.size = 120,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AuthorScreen(
                    thumbnailUrl: image,
                  )),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            image,
            width: size,
            height: size,
            fit: BoxFit.cover,
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(label)
        ],
      ),
    );
  }
}

class RowAuthorCard extends StatelessWidget {
  final Author author;

  const RowAuthorCard({Key? key, required this.author})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AuthorScreen(
                      thumbnailUrl: author.thumbnailUrl,
                    )),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(26, 26, 25, 25),
            borderRadius: BorderRadius.circular(4),
          ),
          clipBehavior: Clip.antiAlias,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.network(author.thumbnailUrl,
                height: 48,
                width: 48,
                fit: BoxFit.cover,
              ),
              SizedBox(width: 8),
              Text(author.name),
              SizedBox(width: 8),
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
