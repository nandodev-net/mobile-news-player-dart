import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noticias_sin_filtro/application_wrapper.dart';
import 'package:noticias_sin_filtro/entities/audio.dart';


class AudioCard extends StatelessWidget {
  final Audio audio;
  const AudioCard({Key? key, required this.audio}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 120.0,
        child: GestureDetector(
          onTap: () {
            context.read(selectedAudioProvider).state = audio;
          },
          child: Column(
            children: [
              Image.network(
                audio.thumbnailUrl.toString(),
                width: 120.0,
                height: 120.0,
              ),
              Text(
                "${audio.title} - ${audio.author}",
                style: Theme.of(context).textTheme.caption,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              )
            ],
          ),
        ));
  }
}

class RowAudioCard extends StatelessWidget {
  final Audio audio;

  const RowAudioCard({Key? key, required this.audio}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () {
            context.read(selectedAudioProvider).state = audio;
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
                audio.thumbnailUrl.toString(),
                height: 48,
                width: 48,
                fit: BoxFit.cover,
              ),
              Text(
                "${audio.title} - ${audio.author}",
                style: Theme.of(context).textTheme.caption,
              ),
              SizedBox(width: 20,),
              Text(
                audio.duration,
                style: Theme.of(context).textTheme.caption,
              ),
              SizedBox(width: 20,)
              // const Padding(
              //   padding: EdgeInsets.fromLTRB(0,0,15,0),
              //   child: Icon(
              //     Icons.play_arrow,
              //     color: Colors.black,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}


class RowAudioTile extends StatelessWidget {
  final Audio audio;

  const RowAudioTile({Key? key, required this.audio}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () {
            context.read(selectedAudioProvider).state = audio;
          },
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(4),
          ),
          clipBehavior: Clip.antiAlias,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 48,),
              Text(
                "${audio.title} - ${audio.author}",
                style: Theme.of(context).textTheme.caption,
              ),
              SizedBox(width: 20,),
              Text(
                audio.duration,
                style: Theme.of(context).textTheme.caption,
              ),
              SizedBox(width: 20,)
              // const Padding(
              //   padding: EdgeInsets.fromLTRB(0,0,15,0),
              //   child: Icon(
              //     Icons.play_arrow,
              //     color: Colors.black,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}