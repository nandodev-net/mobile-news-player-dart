import 'dart:convert';
import 'package:noticias_sin_filtro/entities/news.dart';
import 'package:noticias_sin_filtro/mappers/news_mapper.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<List<News>> getNews() async {
  // TODO: This request should use a proxy

  print("News request is being made");

  List<News> newsList = [];
  String? baseURL = dotenv.env['BASE_URL'].toString();
  String? version = dotenv.env['VERSION'].toString();

  var uri = Uri(
      scheme: 'http',
      host: baseURL,
      path: '/$version/headlines',
      //queryParameters: {'apikey':'pub_513800388590479796ae728a8efb8bee1854', 'country':'au,ca'}
  );

  var response = await http.get(uri);
  newsList = NewsRequestMapper.fromJson(json.decode(response.body)).results;

  print("News are returned");

  return newsList;
}