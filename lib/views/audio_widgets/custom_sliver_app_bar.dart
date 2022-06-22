import 'package:flutter/material.dart';
import 'package:noticias_sin_filtro/application_wrapper.dart';
import 'package:noticias_sin_filtro/entities/author.dart';
import 'package:noticias_sin_filtro/services/requests/get_author_suggestions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noticias_sin_filtro/views/audio_widgets/audio_search_response.dart';

/*
  Upper bar with search icon Widget
*/
class CustomSliverAppBar extends StatelessWidget {
  const CustomSliverAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Adding properties and search button
    return SliverAppBar(
      floating: true,
      backgroundColor: const Color.fromARGB(250, 250, 250, 255),
      leadingWidth: 100.0,
      leading: const Padding(
        padding: EdgeInsets.only(left: 12.0),
        //child: Image.asset('assets/yt_logo_dark.png'),
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.search,
            color: Colors.grey,
          ),
          onPressed: () {
            showSearch(
              context: context,
              delegate: MySearchDelegate(),
            );
          },
        ),
      ],
    );
  }
}

class MySearchDelegate extends SearchDelegate {
  List<String> searchResults_ = [];
  bool _isSuggestionsLoaded = false;

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back));

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
            onPressed: () {
              if (query.isEmpty) {
                close(context, null);
              } else {
                query = '';
              }
            },
            icon: const Icon(Icons.clear)),
      ];

  @override
  Widget buildResults(BuildContext context){
    return Consumer(builder: (context, watch, _){
      var _port = watch(proxyProvider).state;
      return AudioSearchResponse(port:_port, keyword: query,);
    });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Consumer(builder: (context, watch, _) {
      if (_isSuggestionsLoaded != true){
        var _port = watch(proxyProvider).state;
        getSuggestionsFromApi(_port);
        _isSuggestionsLoaded = true;
      }
      List<String> suggestions = searchResults_.where((searchResult) {
        final result = searchResult.toLowerCase();
        final input = query.toLowerCase();
        return result.contains(input);
      }).toList();

      return ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          return ListTile(
            title: Text(suggestion),
            onTap: () {
              query = suggestion;
              showResults(context);
            },
          );
        },
      );
    });
  }

  getSuggestionsFromApi(_port) async {
    List<String> suggestions = [];
    List<AuthorSuggestion> suggestionsResponse = await getAuthorSuggestions(_port);

    for (var item in suggestionsResponse) {
      suggestions.add(item.name);
    }
    searchResults_ = suggestions;
  }
}
