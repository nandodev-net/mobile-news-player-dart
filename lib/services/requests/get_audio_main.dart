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

  var responseApi = json.decode(const Utf8Decoder().convert(response.bodyBytes));
  print('HOLA0');
  mainResponse['lastCapsule'] =  List.from(responseApi['last_capsule']).map((result)=> Audio.fromJson(result)).toList();
  print('HOLA1');
  mainResponse['recentlyAdded'] =  List.from(responseApi['recently_added']).map((result)=> Audio.fromJson(result)).toList();
  print('HOLA2');
  mainResponse['podcast_authors'] =  List.from(responseApi['podcast_authors']).map((result)=> Author.fromJson(result)).toList();
  print('HOLA3');
  mainResponse['news_authors'] =  List.from(responseApi['news_authors']).map((result)=> Author.fromJson(result)).toList();
  print('HOLA4');
  mainResponse['mostVoted'] =  List.from(responseApi['most_voted']).map((result)=> Audio.fromJson(result)).toList();
  print('HOLA5');
  mainResponse['basedOnListens'] =  List.from(responseApi['most_listened']).map((result)=> Audio.fromJson(result)).toList();
  print('HOLA6');

  return mainResponse;
}