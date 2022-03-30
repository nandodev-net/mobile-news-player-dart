import 'dart:convert';
import 'dart:ffi';
import 'package:http/io_client.dart';
import 'package:noticias_sin_filtro/entities/news.dart';
import 'package:noticias_sin_filtro/mappers/news_mapper.dart';
import 'package:http/http.dart' as http;
import 'package:noticias_sin_filtro/services/build_path.dart';
import 'package:noticias_sin_filtro/services/config_proxy.dart';

Future<List<News>> getNews(String proxyPort, [String? category, String? site]) async {
  // TODO: This request should use a proxy

  print("News request is being made");

  List<News> newsList = [];

  Map<String, String> queryParameters = {};

  if(category != null) {
    // List<String> categoryArray = [];
    // categoryArray.add(category.toString());
    queryParameters['categories[]'] = category.toString();
  }

  if(site != null) {
    // List<String> siteArray = [];
    // siteArray.add(site.toString());
    queryParameters['media_sites[]'] = site.toString();
  }


  var uri = buildPath('headlines', queryParameters);

  IOClient httpClientWithProxy = configProxy(proxyPort);
  http.Response response = await httpClientWithProxy.get(uri);
  newsList = NewsRequestMapper.fromJson(json.decode(Utf8Decoder().convert(response.bodyBytes))).results;

  print(newsList[1].title);
  print("News are returned");

  return newsList;
}