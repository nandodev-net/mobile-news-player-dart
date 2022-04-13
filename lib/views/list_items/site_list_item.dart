import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:noticias_sin_filtro/views/wrappers/news_list_wrapper.dart';
import 'package:noticias_sin_filtro/entities/site.dart';
import 'dart:math';

class SiteListItem extends StatefulWidget {
  const SiteListItem({Key? key, required this.site, required this.port}) : super(key: key);
  final String port;
  final Site site;


  @override
  _siteListItemState  createState() => _siteListItemState ();
}


class _siteListItemState extends State<SiteListItem>  {

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
          return NewsListWrapper(port: widget.port, title:"Medio " + widget.site.siteName, site: widget.site.siteLookableName);
        },
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          _navigate(context);
        },
        // widget.news.imageUrl != null ?
        // widget.news.imageUrl.toString() :
        // "https://raw.githubusercontent.com/agarasul/SampleNewsApp/master/empty_image.png"
        child: Container(
            child: Row(
              children: <Widget>[
                Container(
                    height: 70,
                    width: 100,
                    child: Image.network(
                      widget.site.siteUrlImage.toString()
                        //"https://raw.githubusercontent.com/agarasul/SampleNewsApp/master/empty_image.png"
                    )
                ),
                Expanded(child:
                Padding(
                  padding: EdgeInsets.fromLTRB(8, 8, 0, 8),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.site.siteName,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          maxLines: 1,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.grey[800]
                          ),
                        ),
                        Text(
                          widget.site.siteUrl,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[500]
                          ),
                        ),
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