import 'package:flutter/material.dart';
import 'package:noticias_sin_filtro/views/list_items/site_list_item.dart';

// TODO: handle query params
class NewsSites extends StatefulWidget {
  const NewsSites({Key? key, required this.port, required this.showNewsAppBar}) : super(key: key);
  final String port;
  final bool showNewsAppBar;

  @override
  _newsSitesState createState() => _newsSitesState();
}

class _newsSitesState extends State<NewsSites> {

  List<String> _sites = ["La Patilla", "Efecto Cocuyo"];
  List<String> _url = ["lapatilla.com", "efectococuyo.com"];

  @override
  void initState() {
    super.initState();
    getSitesFromApi();
  }

  void getSitesFromApi() async {

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
                        itemCount: _sites.length,
                        itemBuilder: (context, index) =>
                            SiteListItem(
                              site: _sites[index],
                              port: widget.port,
                              siteUrl: _url[index]
                            ),
                      ));
              }
          );
        }
    );


  }
}