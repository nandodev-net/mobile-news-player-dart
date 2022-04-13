import 'package:flutter/material.dart';
import 'package:noticias_sin_filtro/entities/category.dart';
import 'package:noticias_sin_filtro/entities/news.dart';
import 'package:noticias_sin_filtro/services/requests/get_categories.dart';
import 'package:noticias_sin_filtro/views/list_items/category_list_item.dart';
import 'package:noticias_sin_filtro/views/list_items/news_list_item.dart';
import 'package:noticias_sin_filtro/services/requests/get_news.dart';


class Categories extends StatefulWidget {
  const Categories({Key? key, required this.port}) : super(key: key);
  final String port;

  @override
  _categoriesState createState() => _categoriesState();
}

class _categoriesState extends State<Categories> {

  List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    getCategoriesFromApi();
  }

  void getCategoriesFromApi() async {
    List<Category> categories = await  getCategories(widget.port);
    setState(() {
      _categories = categories;
    });
  }

  @override
  Widget build(BuildContext context) {

    //TODO: Change this for a loader
    if(widget.port == ""|| _categories.isEmpty) {
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
