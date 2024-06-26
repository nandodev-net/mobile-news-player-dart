import 'dart:convert';
import 'package:http/io_client.dart';
import 'package:noticias_sin_filtro/entities/category.dart';
import 'package:noticias_sin_filtro/entities/news.dart';
import 'package:noticias_sin_filtro/mappers/news_mapper.dart';
import 'package:http/http.dart' as http;
import 'package:noticias_sin_filtro/services/build_path.dart';
import 'package:noticias_sin_filtro/services/config_proxy.dart';

Future<List<Category>> getCategories(String proxyPort) async {
  // TODO: This request should use a proxy

  print("Categories request is being made");

  // List<String> categoriesList = [];
  List<Category> categoriesList = [];

  var uri = buildPath('categories');

  IOClient httpClientWithProxy = configProxy(proxyPort);
  http.Response response = await httpClientWithProxy.get(uri);
  //results = List.from(json['results']).map((result)=> News.fromJson(result)).toList(),

  categoriesList = List.from(json.decode(Utf8Decoder().convert(response.bodyBytes))).map((result)=> Category.fromJson(result)).toList();

//print(categoriesList);
 // results = List.from(json['results']).map((result)=> News.fromJson(result)).toList(),
//   categoriesList = List.from(json.decode(Utf8Decoder().convert(response.bodyBytes)));

  print("Categories are returned");

  return categoriesList;
}