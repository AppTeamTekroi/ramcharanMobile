import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ramcharan/Login/loginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/API/URLConst.dart';
import 'login_source.dart';
import 'package:http/http.dart' as http;


class LoginController extends GetxController {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final AuthService authService = AuthService();

  var otpVisibility = false.obs;
  var isPasswordVisible = true.obs;
  var Password = "".obs;
  var isLoading = false.obs;
  var isLogin = false.obs;
  var UserName = "".obs;
  var phone = "";
  var token = '';
  var loginType;
  var Name = '';
  var collectionCenter = '';
  var userId = 0;
  var district = '';

  var getuser = 0.obs;
  void togglePasswordVisibility() {
    isPasswordVisible.toggle();
  }

  @override
  void onInit() {
    super.onInit();
    loadLoginState();

  }

  Future<dynamic> loadLoginState() async {

    final prefs = await SharedPreferences.getInstance();
    isLogin.value = prefs.getBool('isLogin') ?? false;
    token = prefs.getString("access_token") ?? '';
    loginType = prefs.getInt("loginType") ?? 0;
    Name = prefs.getString("name") ?? '';
    userId = prefs.getInt("userId") ?? 0;
    phone = prefs.getString("phone") ?? "";
    collectionCenter = prefs.getString("collection_center") ?? "";
    district = prefs.getString("district") ?? "";

    print("token in pref $token");

  }


  Future<dynamic> getOtp(String fcmToken) async {
    final body = jsonEncode({
      "mobile": UserName.value,
      "fcm_token": fcmToken,
    });
    print(body);
       await http.post(
          Uri.parse(URLConst.baseURL+URLConst.generateOtp),
          body: body,
         headers: {
           'Content-Type': 'application/json',
           'Accept': 'application/json',
         },
      );
  }




      Future<dynamic> loginUser() async {
    // final String UserName = usernameController.text;
    // final String Password = passwordController.text;
        final pass = int.tryParse( Password.value);
    try {
      isLoading.value = true;
      var response = await authService.login(
        UserName.value,pass!


      );
      var responseData;
     print(response);
      response.fold(
            (failure) {
          responseData .clear();
          print('Failure in login  : ${failure.message}');
          responseData = 'Failure in login: ${failure.message}';
        },
            (res) => responseData = res,
      );

      if (responseData != null ) {
        isLogin.value = true;
        saveLoginState();
      } else {
        isLogin.value = false;
        saveLoginState();
      }

      return responseData;
    } catch (e) {
      print('Exception: $e');
      throw Exception('Failed to login: $e');
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> logOutUser() async {
    isLogin.value = false;
    token = '';
    userId = -1;
    Name = '';
    phone = '';
    await saveLoginState();
    Get.offAll(LoginScreen());
  }

  Future<void> saveLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLogin', isLogin.value);

    if (isLogin.value) {
      prefs.setString('token', token);
      prefs.setInt('loginType', loginType ?? 1);  // ✅ Save `loginType`
    } else {
      prefs.remove('token');
      prefs.remove('userId');
      prefs.remove('name');

      prefs.remove('loginType');  // ✅ Remove on logout
    }
  }


}