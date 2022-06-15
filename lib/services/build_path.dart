import 'package:flutter_dotenv/flutter_dotenv.dart';
// this function builds the URI path for other services

String? baseURL = dotenv.env['BASE_URL'].toString();
String? version = dotenv.env['VERSION'].toString();


Uri buildPath(String relativePath, [var queryParams])  {
  var uri = Uri(
    port: 8000, //delete #TODO
    scheme: 'http',
    host: baseURL,
    path: '/$version/$relativePath',
    queryParameters:queryParams??queryParams
    //queryParameters: {'apikey':'pub_513800388590479796ae728a8efb8bee1854', 'country':'au,ca'}
  );
  return uri;
}