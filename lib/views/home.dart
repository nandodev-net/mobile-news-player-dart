import 'package:flutter/material.dart';
import 'package:noticias_sin_filtro/entities/news.dart';
import 'package:noticias_sin_filtro/views/list_items/news_list_item.dart';
import 'package:noticias_sin_filtro/services/get_news.dart';


class Home extends StatefulWidget {
  const Home({Key? key, required this.port}) : super(key: key);
  final String port;

  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<Home> {

  List<News> _newsList = [];

  @override
  void initState() {
    super.initState();
    getNewsFromApi();
  }

  void getNewsFromApi() async {
    List<News> newsList = await getNews();
    setState(() {
      _newsList = newsList;
    });
  }

  //TODO: Conditional rendering of thing
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
                            port: widget.port
                        ),
                  ));
            }
          );
        }
    );




  }
}
