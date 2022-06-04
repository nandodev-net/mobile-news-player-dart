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

class RowAudioCard extends StatelessWidget {
  final AssetImage image;
  final String label;

  const RowAudioCard({Key? key, required this.image, required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(26, 26, 25, 25),
            borderRadius: BorderRadius.circular(4),
          ),
          clipBehavior: Clip.antiAlias,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image(
                image: image,
                height: 48,
                width: 48,
                fit: BoxFit.cover,
              ),
              Text(
                label,
                style: Theme.of(context).textTheme.caption,
              ),
              IconButton(
                icon: const Icon(Icons.play_arrow),
                color: Colors.black,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
