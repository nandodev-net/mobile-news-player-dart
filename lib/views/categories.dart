import 'package:flutter/material.dart';
import 'package:noticias_sin_filtro/entities/news.dart';
import 'package:noticias_sin_filtro/services/get_categories.dart';
import 'package:noticias_sin_filtro/views/list_items/category_list_item.dart';
import 'package:noticias_sin_filtro/views/list_items/news_list_item.dart';
import 'package:noticias_sin_filtro/services/get_news.dart';


class Categories extends StatefulWidget {
  const Categories({Key? key, required this.port}) : super(key: key);
  final String port;

  @override
  _categoriesState createState() => _categoriesState();
}

class _categoriesState extends State<Categories> {

  List<String> _categories = [];

  @override
  void initState() {
    super.initState();
    getCategoriesFromApi();
  }

  void getCategoriesFromApi() async {
    List<String> categories = await  getCategories();
    setState(() {
      _categories = categories;
    });
  }

  @override
  Widget build(BuildContext context) {

    //TODO: Change this for a loader
    if(widget.port == ""|| _categories.length <1) {
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
                        itemCount: _categories.length,
                        itemBuilder: (context, index) =>
                            CategoryListItem(
                                category: _categories[index],
                                port: widget.port
                            ),
                      ));
              }
          );
        }
    );
  }
}
