import 'dart:io';
import 'package:http/io_client.dart';

IOClient configProxy(String proxyPort)  {



// Create a new HttpClient instance.
  HttpClient httpClient = HttpClient();

// Hook into the findProxy callback to set
// the client's proxy.
  if (proxyPort != "") {
    String proxy =  'localhost:$proxyPort';
    httpClient.findProxy = (uri) {
      return "PROXY $proxy;";
    };
  }


// This is a workaround to allow Charles to receive
// SSL payloads when your app is running on Android.
  httpClient.badCertificateCallback =
  ((X509Certificate cert, String host, int port) => Platform.isAndroid);

// Pass your newly instantiated HttpClient to http.IOClient.
  IOClient myClient = IOClient(httpClient);
  return myClient;
}