import 'dart:convert';
import 'package:noticias_sin_filtro/entities/news.dart';
import 'package:noticias_sin_filtro/mappers/news_mapper.dart';
import 'package:http/http.dart' as http;

Future<List<News>> getNews() async {
  // TODO: This request should use a proxy

  List<News> newsList = [];
  var uri = Uri(
      scheme: 'https',
      host: 'newsdata.io',
      path: 'api/1/news',
      queryParameters: {'apikey':'pub_513800388590479796ae728a8efb8bee1854', 'country':'au,ca'}
  );

  var response = await http.get(uri);
  newsList = NewsRequestMapper.fromJson(json.decode(response.body)).results;

  return newsList;
}