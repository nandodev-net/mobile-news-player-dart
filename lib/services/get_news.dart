import 'dart:convert';
import 'package:noticias_sin_filtro/entities/news.dart';
import 'package:noticias_sin_filtro/mappers/news_mapper.dart';
import 'package:http/http.dart' as http;
import 'package:noticias_sin_filtro/services/build_path.dart';

Future<List<News>> getNews() async {
  // TODO: This request should use a proxy

  print("News request is being made");

  List<News> newsList = [];

  var uri = buildPath('headlines');

  http.Response response = await http.get(uri);

  newsList = NewsRequestMapper.fromJson(json.decode(Utf8Decoder().convert(response.bodyBytes))).results;

  print(newsList[1].title);
  print("News are returned");

  return newsList;
}