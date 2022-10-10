import 'package:http/io_client.dart';
import 'package:http/http.dart' as http;
import 'package:noticias_sin_filtro/services/build_path.dart';
import 'package:noticias_sin_filtro/services/config_proxy.dart';

Future<bool> patchAudioVotes(String proxyPort, int audioId, int opt) async{
  var uri = buildPath('audio/vote/${audioId.toString()}/${opt.toString()}');
  IOClient httpClientWithProxy = configProxy(proxyPort);
  await http.get(uri);
  return true;
} 