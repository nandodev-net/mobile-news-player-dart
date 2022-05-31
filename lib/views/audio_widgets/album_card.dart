import 'package:flutter/material.dart';


class AlbumCard extends StatelessWidget {
  final ImageProvider image;
  final String label;
  const AlbumCard({
    Key? key,
    required this.image,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(image: image, width: 120.0, height: 120.0, fit: BoxFit.cover,),
        SizedBox(
          height: 10.0,
        ),
        Text(label)
      ],
    );
  }
}
