import 'package:flutter/material.dart';

class AudioCard extends StatelessWidget {
  final AssetImage image;
  const AudioCard({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 120.0,
        child: Column(
          children: [
            Image(
              image: image,
              width: 120.0,
              height: 120.0,
            ),
            Text(
              "Bad Bunny, Justin Bieber, Marilyn Manson, Taylor Swift,...",
              style: Theme.of(context).textTheme.caption,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            )
          ],
        ));
  }
}
