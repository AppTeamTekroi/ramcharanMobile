import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class ApiHelper {
  static Future<Map<String, String>> getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token =  prefs.getString('token');
    print('in headerfiles ---$token');
    final headers = <String, String>{};
    if (token != null) {
      headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    }
    headers[HttpHeaders.contentTypeHeader] = 'application/json';
    headers[HttpHeaders.acceptHeader] = 'application/json';
    return headers;
  }
}


