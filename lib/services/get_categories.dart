import 'dart:convert';
import 'package:noticias_sin_filtro/entities/news.dart';
import 'package:noticias_sin_filtro/mappers/news_mapper.dart';
import 'package:http/http.dart' as http;
import 'package:noticias_sin_filtro/services/build_path.dart';

Future<List<String>> getCategories() async {
  // TODO: This request should use a proxy

  print("Categories request is being made");

  List<String> categoriesList = [];

  var uri = buildPath('categories');

  http.Response response = await http.get(uri);

  categoriesList = List.from(json.decode(Utf8Decoder().convert(response.bodyBytes)));

  print("Categories are returned");

  return categoriesList;
}