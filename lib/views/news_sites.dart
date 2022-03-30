import 'package:flutter/material.dart';
import 'package:noticias_sin_filtro/views/list_items/site_list_item.dart';
import 'package:noticias_sin_filtro/services/requests/get_sites.dart';

// TODO: handle query params
class NewsSites extends StatefulWidget {
  const NewsSites({Key? key, required this.port, required this.showNewsAppBar}) : super(key: key);
  final String port;
  final bool showNewsAppBar;

  @override
  _newsSitesState createState() => _newsSitesState();
}

class _newsSitesState extends State<NewsSites> {

  List<String> _sites = [];
  List<String> _url = ["lapatilla.com", "efectococuyo.com", "otros"];

  @override
  void initState() {
    super.initState();
    getSitesFromApi();
  }

  void getSitesFromApi() async {

    List<String> sites = await  getSites(widget.port);
    setState(() {
      _sites = sites;
    });
  }


  @override
  Widget build(BuildContext context) {

    //TODO: Change this for a loader
    if(widget.port == "" || _sites.length <1) {
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