import 'package:flutter/material.dart';
import 'package:noticias_sin_filtro/views/audio_views/audio_author_screen.dart';

class AuthorCard extends StatelessWidget {
  final ImageProvider image;
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
              MaterialPageRoute(builder: (context) => AuthorScreen(image: image,)),
            );
          },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image(
            image: image,
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
  final AssetImage image;
  final String label;
  const RowAuthorCard({
    Key? key,
    required this.image,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AuthorScreen(image: image,)),
            );
          },
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(26, 26, 25, 25),
            borderRadius: BorderRadius.circular(4),
          ),
          clipBehavior: Clip.antiAlias,
          child: Row(
            children: [
              Image(
                image: image,
                height: 48,
                width: 48,
                fit: BoxFit.cover,
              ),
              SizedBox(width: 8),
              Text(label)
            ],
          ),
        ),
      ),
    );
  }
}