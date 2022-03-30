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

  //NewsListItem(this.news, this.port);

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
    //   context,
    //   MaterialPageRoute(builder: (context) =>  WebviewWrapper(
    //       url:widget.news.link??"",
    //       title: widget.news.title??"",
    //       port:widget.port)),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          _navigate(context);
        },
        child: Container(
            child: Row(
              children: <Widget>[
                Container(
                    height: 150,
                    width: 150,
                    child: Image.network(
                        widget.news.imageUrl != null ?
                        widget.news.imageUrl.toString() :
                        "https://raw.githubusercontent.com/agarasul/SampleNewsApp/master/empty_image.png"
                    )
                ),
                Expanded(child:
                Padding(
                  padding: EdgeInsets.fromLTRB(8, 8, 0, 8),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.news.title.toString(),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          maxLines: 3,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.grey[800]
                          ),
                        ),
                        Text(
                          widget.news.excerpt != null?widget.news.excerpt.toString():"",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          maxLines: 2,
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 12,
                              color: Colors.grey[700]
                          ),
                        )
                      ]),
                ),
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                    child: Row(
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  0, 0, 5, 0),
                              child: IconButton(
                                iconSize: 20,
                                icon: Icon(
                                    liked
                                        ? CupertinoIcons.heart_solid
                                        : CupertinoIcons.heart,
                                    color: Colors.redAccent
                                ),
                                onPressed: _heartButtonClicked,
                              )
                          ),
                          Icon(Icons.arrow_forward_ios,
                            color: Colors.grey[500],
                            size: 20,
                          )
                        ]
                    )
                )


              ],
            )
        )
    );
  }

}