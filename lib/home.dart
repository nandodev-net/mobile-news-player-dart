import 'package:flutter/material.dart';
import 'package:noticias_sin_filtro/entities/news.dart';
import 'package:noticias_sin_filtro/list_item.dart';
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

    if(widget.port == "") {
      return Text("Cargando");
    }

    // if port exists
    return Container(
            child: ListView.builder(
              itemCount: _newsList.length,
              itemBuilder: (context, index) =>
                  ListItem(_newsList[index],
                  widget.port
                ),
            ));

  }
}
