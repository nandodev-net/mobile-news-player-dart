import 'dart:convert';
import 'package:http/io_client.dart';
import 'package:noticias_sin_filtro/entities/audio.dart';
import 'package:http/http.dart' as http;
import 'package:noticias_sin_filtro/services/build_path.dart';
import 'package:noticias_sin_filtro/services/config_proxy.dart';


Future<Map> getSearchResults(
    String proxyPort, String keyword, List<String> nextUrl) async {
  print("Search Screen request is being made");

  var authorResponse = {};
  var uri = buildPath('audio/search/${keyword}');
  if (nextUrl.isNotEmpty) uri = Uri.parse(nextUrl[0]);

  //IOClient httpClientWithProxy = configProxy(proxyPort);

  //http.Response response = await httpClientWithProxy.get(uri);
  var response = await http.get(uri);

  authorResponse['audios'] = [];
  authorResponse['nextUrl'] = null;

  if (response.statusCode != 204) {
    var responseApi = json.decode(const Utf8Decoder().convert(response.bodyBytes));
    authorResponse['nextUrl'] = responseApi['next'];
    if (responseApi['results'].isNotEmpty) {
      authorResponse['audios'] = List.from(responseApi['results'])
          .map((result) => Audio.fromJson(result))
          .toList();
    }
  }

  return authorResponse;
}
