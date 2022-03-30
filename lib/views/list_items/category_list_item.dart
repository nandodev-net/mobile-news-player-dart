import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:noticias_sin_filtro/views/news_list.dart';
import 'package:noticias_sin_filtro/views/wrappers/news_list_wrapper.dart';

class CategoryListItem extends StatefulWidget {
  const CategoryListItem({Key? key, required this.category, required this.port}) : super(key: key);
  final String port;
  final String category;

  @override
  _categoryListItem createState() => _categoryListItem();
}


class _categoryListItem extends State<CategoryListItem>  {

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
          return NewsListWrapper(port: widget.port, title:"Categoría " + widget.category);
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
        child: Container(
            child: Row(
              children: <Widget>[
                Container(
                    height: 70,
                    width: 100,
                    color: Colors.redAccent
                ),
                Expanded(child:
                Padding(
                  padding: EdgeInsets.fromLTRB(8, 8, 0, 8),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.category,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          maxLines: 1,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.grey[800]
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