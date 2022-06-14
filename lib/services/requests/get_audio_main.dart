import 'dart:convert';
import 'package:http/io_client.dart';
import 'package:noticias_sin_filtro/entities/audio.dart';
import 'package:noticias_sin_filtro/entities/author.dart';
import 'package:http/http.dart' as http;
import 'package:noticias_sin_filtro/services/build_path.dart';
import 'package:noticias_sin_filtro/services/config_proxy.dart';

Future<Map> getAudioMain(String proxyPort) async {
  print("Main Audio Screen request is being made");

  var mainResponse = {};

  var uri = buildPath('audio/main');

  IOClient httpClientWithProxy = configProxy(proxyPort);

  http.Response response = await httpClientWithProxy.get(uri);

  var responseApi = json.decode(Utf8Decoder().convert(response.bodyBytes));

  mainResponse['lastCapsule'] = List.from(responseApi['last_capsule']).map((result)=> Audio.fromJson(result)).toList();
  mainResponse['recentlyAdded'] = List.from(responseApi['recently_added']).map((result)=> Audio.fromJson(result)).toList();
  mainResponse['authors'] = List.from(responseApi['authors']).map((result)=> Author.fromJson(result)).toList();
  mainResponse['mostVoted'] = List.from(responseApi['most_voted']).map((result)=> Audio.fromJson(result)).toList();
  mainResponse['basedOnListens'] = List.from(responseApi['most_listened']).map((result)=> Audio.fromJson(result)).toList();

  return mainResponse;
}