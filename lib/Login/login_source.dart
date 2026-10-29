import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../core/error/failure.dart';
import '../../core/API/URLConst.dart';

class AuthService {
  Future<Either<Failure, Map<String, dynamic>>> login(String UserName, int Password) async {
    try {
      print('$UserName,$Password');

      final Map<String, dynamic> requestBody = {
      //  "loginType" : loginType,
        "mobile": UserName,
        "otp": Password,
      };

      final response = await http.post(
        Uri.parse(URLConst.baseURL+URLConst.loginURL),
        headers: {'Content-Type': 'application/json','accept':'application/json'},

        body: jsonEncode(requestBody),
      );
      print("response in auth");
      print('post response ${response.body}');

      if (response.statusCode == 200) {
        final dynamic responseData = jsonDecode(response.body);
        return Right(
            responseData); // Return successful response wrapped in Right
      } else {
        // Handle failure case
        return Left(Failure(
            statusCode: response.statusCode, message: 'Failed to login user'));
      }
    } catch (e) {
      // Catch any exceptions and rethrow
      print('Exception: $e');
      return Left(Failure(statusCode: 500, message: 'Failed to login: $e'));
    }
  }
}
