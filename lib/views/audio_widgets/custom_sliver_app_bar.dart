import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/*
  Upper bar with search icon Widget
*/
class CustomSliverAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Adding properties and search button
    return SliverAppBar(
      floating: true,
      backgroundColor: Color.fromARGB(255, 243, 243, 243),
      leadingWidth: 100.0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        //child: Image.asset('assets/yt_logo_dark.png'),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.grey,),
          onPressed: () {
            showSearch(context: context, delegate: MySearchDelegate(),);
          },
        ),
      ],
    );
  }
}

class MySearchDelegate extends SearchDelegate {
    List<String> searchResults = [
      'Korn',
      'Crazy Town',
      'SOAD',
      'Linkin Park',
      'Amon Amarth',
      'Blink 182'
    ];

  @override 
  Widget? buildLeading(BuildContext context) => IconButton(onPressed: () => close(context, null), icon: const Icon(Icons.arrow_back));

  @override 
  List<Widget>? buildActions(BuildContext context) => [
      IconButton(
        onPressed: (){ 
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
          }
          }, 
        icon: const Icon(Icons.clear)
        ),
  ];


  @override 
  Widget buildResults(BuildContext context) => Center(child: Text(query, style: const TextStyle(fontSize: 64),),);

  @override 
  Widget buildSuggestions(BuildContext context){
    List<String> suggestions = searchResults.where((searchResult){
      final result = searchResult.toLowerCase();
      final input = query.toLowerCase();
      return result.contains(input);
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index){
        final suggestion = suggestions[index];
        return ListTile(
          title: Text(suggestion),
          onTap: (){
            query = suggestion;
            showResults(context);
          },
        );
      },
    );
  }
}