import 'dart:convert';
import 'package:http/io_client.dart';
import 'package:noticias_sin_filtro/entities/author.dart';
import 'package:http/http.dart' as http;
import 'package:noticias_sin_filtro/services/build_path.dart';
import 'package:noticias_sin_filtro/services/config_proxy.dart';


Future<List<AuthorSuggestion>> getAuthorSuggestions(String proxyPort) async {
  print("Search Screen Suggestions request is being made");

  List<AuthorSuggestion> suggestionsResponse = [];
  var uri = buildPath('audio/suggestions');

  IOClient httpClientWithProxy = configProxy(proxyPort);

  //http.Response response = await httpClientWithProxy.get(uri);
  var response = await http.get(uri);
  var responseApi = json.decode(const Utf8Decoder().convert(response.bodyBytes));

  suggestionsResponse = List.from(responseApi).map((result)=> AuthorSuggestion.fromJson(result)).toList();

  return suggestionsResponse;
}