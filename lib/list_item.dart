import 'package:flutter/material.dart';
import 'package:noticias_sin_filtro/news_mapper.dart';

class ListItem extends StatelessWidget {
  final News news;
  ListItem(this.news);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
          children: <Widget>[
            Container(
                height: 80,
                width: 100,
                child: Image.network(
                    news.image_url != null?
                    news.image_url.toString():
                    "https://raw.githubusercontent.com/agarasul/SampleNewsApp/master/empty_image.png"
                )
            ),
            Expanded(child:
              Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                          news.title.toString(),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          maxLines: 2,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                          news.description.toString(),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          maxLines: 2,
                          style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                      )
                    ]),
              )

            )

          ],
        ));
  }
}