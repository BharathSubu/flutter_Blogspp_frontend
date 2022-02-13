import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class NetworkHandler {
  var log = Logger();

  String baseurl = "http://192.168.0.105:5000/";


  FlutterSecureStorage storage = FlutterSecureStorage();
  //Getting the responce from the url
  Future<dynamic> get(String url) async {
    String? token = await storage.read(key: "token");
    url = formater(url);
    var response = await http.get(
      Uri.parse(url),
      headers: {
        //"Content-type": "application/json",
        "Authorization": "Bearer $token"
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      log.i("success");
      log.i(response.body);
      return json.decode(response.body);
    }
    log.i(response.body);
    log.i(response.statusCode);
  }

  Future<http.Response> delete(String url) async {
    String? token = await storage.read(key: "token");
    url = formater(url);
    var response = await http.delete(
      Uri.parse(url),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $token"
      },
    );
    return response;
  }

  Future<http.Response> post(String url, var body) async {
    url = formater(url);
    String? token = await storage.read(key: "token");
    log.d(body);
    var response = await http.post(Uri.parse(url),
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: json.encode(body));

    if (response.statusCode == 200 || response.statusCode == 201) {
      log.i("success");
      log.i(response.body);
    }
    if (response.statusCode == 400 || response.statusCode == 401) {
      log.i("Failure");
      log.i(response.body);
    }
    // log.i("URL---------", Uri.parse(url));
    // log.d("Response Body", response.body);
    // log.d("Response code ", response.statusCode);

    return response;
  }

  Future<http.Response> patch(String url, var body) async {
    String? token = await storage.read(key: "token");
    url = formater(url);
    log.d(body);
    var response = await http.patch(
      Uri.parse(url),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: json.encode(body),
    );
    return response;
  }

  Future<http.Response> patchpassword(String url, var body) async {
    url = formater(url);
    log.d(body);
    var response = await http.patch(
      Uri.parse(url),
      headers: {"Content-type": "application/json"},
      body: json.encode(body),
    );
    return response;
  }

  Future<http.StreamedResponse> patchImage(String url, String filepath) async {
    url = formater(url);
    String? token = await storage.read(key: "token");
    //http.MultipartRequest is used are sending file patch
    var request = http.MultipartRequest('PATCH', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath("img", filepath));
    request.headers.addAll({
      //form data is used as we are sending image as a file
      "Content-type": "multipart/form-data",
      "Authorization": "Bearer $token"
    });
    //type of the Future<StreamedResponse>
    var response = request.send();
    return response;
  }

  String getImage(String imageName) {
    String url = formater("uploads//$imageName.jpg");
    return url;
  }

  String formater(String url) {
    return baseurl + url;
  }
}
