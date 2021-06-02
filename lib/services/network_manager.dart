import 'dart:async';

import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkManager {
  static NetworkManager _sharedInstance = new NetworkManager.internal();
  NetworkManager.internal();

  factory NetworkManager() => _sharedInstance;

  final JsonDecoder _decoder = new JsonDecoder();

  Future<dynamic> get(String url) {
    var urlO = Uri(scheme: url);
    print("URL: $urlO");
    return http.get(urlO).then((http.Response response) {
      final String res = response.body;
      print("RES: $res");
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400) {
        throw new Exception("Error while fetching data");
      }
      return _decoder.convert(res);
    }).catchError((onError) {
      throw new Exception("Error while fetching data");
    });
  }

  // Future<dynamic> post(String url, {Map headers, body, encoding}) {
  //   var urlO = Uri(scheme: url);
  //   return http
  //       .post(urlO, body: body, headers: headers, encoding: encoding)
  //       .then((http.Response response) {
  //     final String res = response.body;
  //     final int statusCode = response.statusCode;

  //     if (statusCode < 200 || statusCode > 400 || json == null) {
  //       throw new Exception("Error while fetching data");
  //     }
  //     return _decoder.convert(res);
  //   });
  // }
}
