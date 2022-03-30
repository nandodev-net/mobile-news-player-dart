import 'dart:convert';
import 'package:http/io_client.dart';
import 'package:noticias_sin_filtro/entities/news.dart';
import 'package:noticias_sin_filtro/mappers/news_mapper.dart';
import 'package:http/http.dart' as http;
import 'package:noticias_sin_filtro/services/build_path.dart';
import 'package:noticias_sin_filtro/services/config_proxy.dart';

Future<List<String>> getSites(String proxyPort) async {
  // TODO: This request should use a proxy

  print("Sites request is being made");

  List<String> sitesList = [];

  var uri = buildPath('media_sites');

  IOClient httpClientWithProxy = configProxy(proxyPort);
  http.Response response = await httpClientWithProxy.get(uri);

  sitesList = List.from(json.decode(Utf8Decoder().convert(response.bodyBytes)));

  print("Sites are returned");

  return sitesList;
}