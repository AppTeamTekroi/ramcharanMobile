import 'dart:ui';

// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ramcharan/Login/loginScreen.dart';
import 'package:ramcharan/Splash/SplashScreen.dart';
import 'package:ramcharan/ui/app_binding.dart';
import 'package:ramcharan/ui/color/appColor.dart';

import 'Login/login_controller.dart';

import 'features/customerNavBar.dart';
import 'notification_service.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) async{
    // await Firebase.initializeApp();
    //
    // await FirebaseMessaging.instance.requestPermission();
    // await initFCM();
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: AppBinding(),
      title: 'Ramcharan',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home : Splashscreen()
    );
  }
}




