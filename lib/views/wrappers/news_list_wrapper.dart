import 'package:flutter/material.dart';
import 'package:noticias_sin_filtro/views/news_list.dart';

class NewsListWrapper extends StatelessWidget {
  const NewsListWrapper({
    Key? key,
    required this.title,
    this.port = "",
    this.site,
    this.category
  }) : super(key: key);

  final String port;
  final String title;
  final String? site;
  final String? category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            title,
            style: TextStyle(fontSize: 15),
          ),
          backgroundColor: Colors.grey[700],
          foregroundColor: Colors.grey[100],
        ),
        body: NewsList(port:port, showNewsAppBar: false, site:site, category: category)
    );
  }
}
