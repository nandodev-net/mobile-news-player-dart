import 'package:flutter/material.dart';
import 'package:noticias_sin_filtro/entities/news.dart';
import 'package:noticias_sin_filtro/views/list_items/news_list_item.dart';
import 'package:noticias_sin_filtro/services/requests/get_news.dart';

// TODO: handle query params
class NewsList extends StatefulWidget {
  const NewsList({
    Key? key,
    required this.port,
    required this.showNewsAppBar,
    this.category,
    this.site
  }) : super(key: key);
  final String port;
  final bool showNewsAppBar;
  final String? category;
  final String? site;

  @override
  _newsListState createState() => _newsListState();
}

class _newsListState extends State<NewsList> {

  List<News> _newsList = [];

  @override
  void initState() {
    super.initState();
    getNewsFromApi();
  }

  void getNewsFromApi() async {
    List<News> newsList = await getNews(widget.port,widget.category,widget.site);
    setState(() {
      _newsList = newsList;
    });
  }


  @override
  Widget build(BuildContext context) {

    //TODO: Change this for a loader
    if(widget.port == "") {
      return Text("Cargando");
    }

    // if port exists
    return Navigator(
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              return
                Container(
                  child: ListView.builder(
                    itemCount: _newsList.length,
                    itemBuilder: (context, index) =>
                        NewsListItem(
                            news: _newsList[index],
                            port: widget.port,
                            showNewsAppBar: widget.showNewsAppBar,
                        ),
                  ));
            }
          );
        }
    );




  }
}
