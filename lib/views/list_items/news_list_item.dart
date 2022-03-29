import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:noticias_sin_filtro/entities/news.dart';
import 'package:noticias_sin_filtro/views/native_webview/webview_wrapper.dart';

class NewsListItem extends StatefulWidget {
  const NewsListItem({Key? key, required this.news, required this.port}) : super(key: key);
  final String port;
  final News news;

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
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  WebviewWrapper(
          url:widget.news.link??"",
          title: widget.news.title??"",
          port:widget.port)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return
      GestureDetector(
        onTap: () {_navigate(context);},
        child: Container(
          child: Row(
            children: <Widget>[
              Container(
                  height: 100,
                  width: 100,
                  child: Image.network(
                      widget.news.image_url != null?
                      widget.news.image_url.toString():
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
                            maxLines: 2,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color:Colors.grey[800]
                            ),
                        ),
                        Text(
                            widget.news.description.toString(),
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
                padding:  const EdgeInsets.fromLTRB(0, 0, 15, 0),
                child: Row (
                    children:<Widget> [
                      Padding(
                          padding:  const EdgeInsets.fromLTRB(0, 0, 5, 0),
                          child:  IconButton(
                            iconSize: 20,
                            icon: Icon(
                                liked?CupertinoIcons.heart_solid:CupertinoIcons.heart,
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