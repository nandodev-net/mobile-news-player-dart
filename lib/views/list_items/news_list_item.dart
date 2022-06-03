import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:noticias_sin_filtro/entities/news.dart';
import 'package:noticias_sin_filtro/views/wrappers/webview_wrapper.dart';

class NewsListItem extends StatefulWidget {
  const NewsListItem({
    Key? key,
    required this.news,
    required this.port,
    required this.showNewsAppBar
  }) : super(key: key);

  final String port;
  final News news;
  final bool showNewsAppBar;

  @override
  _newsListItem createState() => _newsListItem();
}


class _newsListItem extends State<NewsListItem>  {

  bool liked = false;

  void _heartButtonClicked() {
    //toggle button
    setState(() {
      liked = !liked;
    });
  }


  void _navigate(context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return WebviewWrapper(
                    url:widget.news.url??"",
                    title: widget.news.title??"",
                    port:widget.port,
                    showAppBar: widget.showNewsAppBar,
          );
        },
      ),
    );
  }


  /*//////////////////////////// UI elements /////////////////////// */

  late Column informationSection = Column(
    children: [
      titleSection,
      detailsSection
    ]
  );


  late Text titleSection = Text(
    widget.news.title.toString(),
    overflow: TextOverflow.ellipsis,
    textAlign: TextAlign.left,
    maxLines: 3,
    style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: Colors.grey[800]
    ),
  );

  late Container imageSection =   Container(
      height: 100,
      width: 100,
      child: Image.network(
          widget.news.imageUrl != null ?
          widget.news.imageUrl.toString() :
          "https://raw.githubusercontent.com/agarasul/SampleNewsApp/master/empty_image.png"
      )
  );

  late Row detailsSection =  Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: textExcerpt,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(5, 0, 10, 0),
          child: forwardIcon
        )

      ]
  );

  late IconButton heartButton = IconButton(
    iconSize: 20,
    icon: Icon(
        liked
            ? CupertinoIcons.heart_solid
            : CupertinoIcons.heart,
        color: Colors.redAccent
    ),
    onPressed: _heartButtonClicked,
  );

  late Icon forwardIcon =   Icon(Icons.arrow_forward_ios,
    color: Colors.grey[500],
    size: 20,
  );

  late Text textExcerpt = Text(
    widget.news.excerpt != null?widget.news.excerpt.toString():"",
    overflow: TextOverflow.ellipsis,
    textAlign: TextAlign.left,
    maxLines: 2,
    style: TextStyle(
        fontStyle: FontStyle.italic,
        fontSize: 14,
        color: Colors.grey[700]
    ),
  );

  /*//////////////////////////// Build Section /////////////////////// */
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          _navigate(context);
        },
        child: Container(
            child: Row(
              children: <Widget>[
                imageSection,
                Expanded(
                  child:
                    Padding(
                      padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                      child: informationSection
                    )

                )
              ],

            )
        )
    );
  }

}