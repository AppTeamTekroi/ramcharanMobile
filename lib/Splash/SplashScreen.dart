import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ramcharan/Login/loginScreen.dart';
import 'package:ramcharan/ui/color/appColor.dart';
import '../Login/login_controller.dart';
import '../features/customerNavBar.dart';
import '../ui/assets/app_assets.dart';
class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {

  final LoginController loginController = Get.find();
  double progress = 0.0;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _startProgress(); // ✅ start animation

  }
  void _startProgress() {
    const duration = Duration(milliseconds: 40); // speed
    Future.doWhile(() async {
      await Future.delayed(duration);
      if (!mounted) return false;

      setState(() {
        progress += 0.02; // increase step
      });

      return progress < 1.0;
    });
  }

  Future<void> _checkLoginStatus() async {
    await loginController.loadLoginState();

    // Optional delay for better UX
    await Future.delayed(const Duration(seconds: 1));

    if (loginController.isLogin.value) {
      Get.offAll(() => BottomNav()); // ✅ Go to dashboard
    } else {
      Get.offAll(() => const LoginScreen()); // ✅ Go to login
    }
  }

  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: Column(
       spacing: 5,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: height * 0.05,
          ),
          Row(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(child: Image(image: AssetImage(AppImagePaths.applogo)),),
              Text("KISAN TO ENTREPRENEUR",style: GoogleFonts.oswald(
                  fontSize: 21,
                  fontWeight: FontWeight.bold
                  ,color: AppColors.text),),
            ],
          ),
          //const Spacer(),
          SizedBox(height: height * 0.01),
          Image.asset(AppImagePaths.icon5,
            // height: height * 0.35,
            // width: width * 0.72,
            fit: BoxFit.contain,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: constraints.maxWidth * progress,
                    height: height*0.02,
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              },
            ),
          ),
          Text("Loading............",style: GoogleFonts.oswald(fontSize: 15, fontWeight: FontWeight.w300,color: Colors.grey.shade400),),

          Text("Easy way to manage\n service & support",style: GoogleFonts.oswald(fontSize: 30, fontWeight: FontWeight.bold,color: Colors.grey.shade600),),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("This productive tool is designed to help\n             you better manage your\n      service and support conveniently",style: TextStyle(fontSize: 15,color: Colors.grey),),
          ),
          SizedBox(height: 20,),


        ],
      ),
    );
  }
}