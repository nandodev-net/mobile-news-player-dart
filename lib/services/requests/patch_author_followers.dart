import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:noticias_sin_filtro/services/build_path.dart';
import 'package:noticias_sin_filtro/services/config_proxy.dart';

Future<bool> patchAuthorFollowers(String proxyPort, int authorId, int opt) async{
  var uri = buildPath('author/follow/${authorId.toString()}/${opt.toString()}');
  IOClient httpClientWithProxy = configProxy(proxyPort);
  await http.get(uri);
  return true;
}