import 'dart:async';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ramcharan/features/customerNavBar.dart';
import 'package:ramcharan/ui/Buttons/button.dart';
import 'package:ramcharan/ui/color/appColor.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../ui/CommonBackground.dart';
import '../ui/assets/app_assets.dart';
import '../ui/loading.dart';
import 'login_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginController loginController = Get.put(LoginController(), permanent: true);

  bool showCredentialsText = false;
  final List<TextEditingController> otpControllers =
      List.generate(4, (index) => TextEditingController());
  var _codewidget = true.obs;
  var phoneerror = false.obs;
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }



  Timer? _timer;
  int _secondsRemaining = 60;
  bool _canResend = false;

  void _startCountdown() {
    setState(() {
      _secondsRemaining = 60;
      _canResend = false;
    });

    _timer?.cancel(); // Cancel previous timer if any
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        timer.cancel();
        setState(() {
          _canResend = true;
        });
      }
    });
  }

  void _resendOtp() {
    if (!_canResend) return;
    // Call your OTP API here
    print("Resending OTP...");
    // Restart countdown
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: LoginBackground(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("RAMCHARAN OIL INDUSTRIES",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w500),),
              SizedBox(
                height: height * 0.07,
              ),
              Container(
                // height: height * 0.04,
                // width: width*0.137,
                child: Image.asset(
                  AppImagePaths.applogo,
                  fit: BoxFit.cover,
                  height:height * 0.08,
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.only(left: width * 0.075),
              //   child: Text(
              //     "",
              //     style: GoogleFonts.oswald(
              //         fontSize: 26,
              //         color: AppColors.primary,
              //         fontWeight: FontWeight.w700),
              //   ),
              // ),
              Obx(
                () => _codewidget.value
                    ? Padding(
                        padding: EdgeInsets.only(top: height * 0.04),
                        //   padding: EdgeInsets.symmetric(horizontal: width * 0.075,vertical: height*0.1),
                        child: Container(
                          child: Padding(
                            // padding: EdgeInsets.symmetric(horizontal: width * 0.085,
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            child: Column(
                              children: [
                                Text(
                                  "Enter your mobile number",
                                  style: GoogleFonts.roboto(
                                      fontSize: 16,
                                      color: AppColors.text,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: height * 0.01,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: height * 0.008),
                                  child: Container(
                                    // height: height * 0.06,
                                    //  width: width * 0.85,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                    ),
                                    child: IntlPhoneField(
                                      onCountryChanged: (val) {
                                        // cc.dial_code.value = val.dialCode;
                                      },
                                      //  showDropdownIcon: false,
                                      //  showCountryCode: false, // Hides the country code

                                      disableLengthCheck: true,
                                      flagsButtonPadding:
                                          const EdgeInsets.all(8),
                                      dropdownIconPosition:
                                          IconPosition.trailing,
                                      decoration: InputDecoration(
                                        // contentPadding:
                                        // const EdgeInsets.only(left: 12, top: 7),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 12),

                                        hintText: 'Enter Mobile Number',
                                        hintStyle: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16,
                                            color: Colors.grey.shade400),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                      initialCountryCode: 'IN',
                                      onChanged: (phone) {
                                        if (phone.number.length <= 10) {
                                          loginController.UserName.value = phone.number;
                                          phoneerror.value = false;

                                        }else{
                                          phoneerror.value = true;
                                        }
                                        },
                                    ),
                                  ),
                                ),

                                SizedBox(
                                  height: height * 0.01,
                                ),


                                Text(
                                  "You'll receive a 4 digit code to verify next!",
                                  style: GoogleFonts.roboto(
                                      fontSize: 16,
                                      color: AppColors.text,
                                      fontWeight: FontWeight.w500),
                                ),

                                Obx(() => phoneerror.value
                                    ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                                                        "Mobile Number to be 10 digits",
                                                                        style: GoogleFonts.roboto(
                                      fontSize: 16,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.normal,
                                                                        ),
                                                                      ),
                                    )
                                    :

                                  Padding(
                                  // padding: EdgeInsets.symmetric(horizontal: height*0.017,vertical: width*0.07),
                                  // padding: EdgeInsets.symmetric(
                                  //     vertical: height * 0.01,
                                  //     horizontal: width * 0.07),
                                  padding: EdgeInsets.symmetric(
                                      vertical: width * 0.07),
                                  child: Center(
                                    child: ButtonBS(
                                      title: 'Request OTP',
                                      textColor: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      width: width * 0.8,
                                      height: height * 0.055,
                                      // width: width * 0.39,
                                      // height: height * 0.04,
                                      padding: 5.0,
                                      backgroundColor: AppColors.primary,
                                      borderRadius: 25,
                                      // suffixIcon: Icons.arrow_forward_ios,
                                      // suffixIconColor: Colors.white,
                                      // suffixIconSize: 18,
                                      // prefixIconSize: 0,
                                      // separateSuffixIcon: 5,

                                      onPressed: () async {
                                         if( loginController.UserName.value.length == 10 ) {
                                           // String? fcmToken = await FirebaseMessaging
                                           //     .instance.getToken();
                                           // if (fcmToken != null) {
                                           //   _codewidget.value = false;
                                           //
                                           //    loginController.getOtp(fcmToken);
                                           //   _startCountdown();
                                           // }
                                             _codewidget.value = false;
                                             _startCountdown();
                                         }
                                        },
                                    ),
                                  ),
                                ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: width * 0.075),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Don't have an account?  ",
                                        style: GoogleFonts.roboto(
                                            fontSize: 16,
                                            color: AppColors.text,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        "Sign Up",
                                        style: GoogleFonts.roboto(
                                            fontSize: 18,
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.only(top: height * 0.045),

                        //   padding: EdgeInsets.symmetric(horizontal: width * 0.075,vertical: height*0.1),
                        child: Container(
                          child: Padding(
                            //  padding: EdgeInsets.symmetric(horizontal: width * 0.085,),
                            padding: EdgeInsets.symmetric(horizontal: 0),

                            child: Column(
                              children: [
                                Text(
                                  "Enter authentication code",
                                  style: GoogleFonts.roboto(
                                      fontSize: 26,
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(
                                  height: height * 0.01,
                                ),
                                Text(
                                  "Enter the 4-digit that we have sent",
                                  style: GoogleFonts.manrope(
                                      fontSize: 15,
                                      color: AppColors.black,
                                      fontWeight: FontWeight.normal),
                                ),

                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "via the phone number",
                                      style: GoogleFonts.manrope(
                                          fontSize: 15,
                                          color: AppColors.black,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    Text(
                                      "${loginController.UserName}",
                                      style: GoogleFonts.roboto(
                                          fontSize: 18,
                                          color: AppColors.black,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: height * 0.015,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: height * 0.008,
                                      horizontal: width * 0.02),
                                  child: Container(
                                    // height: height * 0.06,
                                    //  width: width * 0.85,
                                    // decoration: BoxDecoration(
                                    //   color: Colors.white,
                                    //   borderRadius: BorderRadius.circular(30),
                                    //   border: Border.all(color: Colors.grey.shade300),
                                    //
                                    // ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: List.generate(4, (index) {
                                        return Container(
                                          width: width * 0.13,
                                          height: width * 0.13,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: width * 0.02),
                                          decoration: BoxDecoration(
                                            shape: BoxShape
                                                .circle, // Ensures a circular shape
                                            //  color: Colors.grey.shade200,
                                            border: Border.all(
                                                color: Colors.grey.shade400,
                                                width: 1),
                                          ),
                                          alignment: Alignment.center,
                                          child: TextField(
                                            controller: otpControllers[index],
                                            keyboardType: TextInputType.number,
                                            textAlign: TextAlign.center,
                                            maxLength: 1,
                                            style: GoogleFonts.urbanist(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold),
                                            decoration: InputDecoration(
                                                counterText:
                                                    "", // Hides 0/1 character count
                                                border: InputBorder.none,
                                                contentPadding:
                                                    EdgeInsets.all(2)),
                                            onChanged: (value) {
                                              if (value.isNotEmpty &&
                                                  index < 3) {
                                                String otp = otpControllers
                                                    .map((controller) =>
                                                        controller.text)
                                                    .join();
                                                loginController.Password.value = otp;
                                                FocusScope.of(context)
                                                    .nextFocus(); // Auto move to next field
                                              }
                                            },
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ),

                                // SizedBox(
                                //   height: height * 0.01,
                                // ),







                                SizedBox(
                                  height: height * 0.015,
                                ),
                                Padding(
                                  // padding: EdgeInsets.symmetric(horizontal: height*0.017,vertical: width*0.07),

                                  padding: EdgeInsets.symmetric(
                                      vertical: height * 0.01,
                                      horizontal: width * 0.07),
                                  child: Center(
                                    child: ButtonBS(
                                      title: 'Continue',
                                      textColor: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,

                                      width: width * 0.85,
                                      height: height * 0.055,
                                      // width: width * 0.39,
                                      // height: height * 0.04,
                                      padding: 5.0,
                                      backgroundColor: AppColors.primary,
                                      borderRadius: 30,
                                      // suffixIcon: Icons.arrow_forward_ios,
                                      // suffixIconColor: Colors.white,
                                      // suffixIconSize: 18,
                                      // prefixIconSize: 0,
                                      // separateSuffixIcon: 5,
                                      onPressed: () async {
                                        if (loginController
                                                .UserName.value.isNotEmpty &&
                                            loginController
                                                .Password.value.isNotEmpty) {
                                          String otp = otpControllers
                                              .map((controller) =>
                                                  controller.text)
                                              .join();
                                          loginController.Password.value = otp;
                                          try {
                                            LoadingOverlay.show(
                                                'Please wit while Authenticating ..');

                                            print("calling login.....");
                                            final response =
                                                await loginController
                                                    .loginUser();
                                           if(response['status']== true) {
                                             if (response != null &&
                                                 response['access_token'] !=
                                                     null) {
                                               loginController.token =
                                               response['access_token'];
                                               loginController.loginType =
                                               response['role'];
                                               loginController.userId =
                                               response['id'];
                                               loginController.Name =
                                               response['name'];
                                               loginController.collectionCenter = response['collection_center'];
                                               loginController.district = response['district'];

                                               loginController.phone = loginController.UserName.value;
                                               final SharedPreferences _prefs = await SharedPreferences
                                                   .getInstance();
                                               _prefs.setString('token',
                                                   loginController.token);
                                               _prefs.setInt('loginType',
                                                   loginController.loginType);
                                               _prefs.setInt('userId',
                                                   loginController.userId);
                                               _prefs.setString('name',

                                                   loginController.Name);
                                               _prefs.setString('collection_center',
                                                   loginController.collectionCenter);
                                               _prefs.setString('district',
                                                   loginController.district);
                                               _prefs.setString('phone', loginController.phone);
                                               loginController.UserName.value = '';
                                               loginController.Password.value = '';

                                               Get.offAll(() => BottomNav());
                                               LoadingOverlay.hide();

                                               return;
                                             }
                                           }else {
                                               LoadingOverlay.hide();
                                             QuickAlert.show(
                                               context: context,
                                               title: 'Failed',
                                               type: QuickAlertType.error,
                                               text: response['message'],
                                             );
                                           }
                                          } catch (e) {
                                            LoadingOverlay.hide();

                                            print('Server error: $e');
                                            QuickAlert.show(
                                              context: context,
                                              title: 'Failed',
                                              type: QuickAlertType.error,
                                              text: 'Failed to login. Please try again later.',
                                            );
                                          } finally {
                                            LoadingOverlay.hide();

                                            loginController.isLoading.value =
                                                false;
                                          }
                                        }
                                        LoadingOverlay.hide();

                                        loginController.isLogin.value = false;
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.01,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: ()
                            {
                              _codewidget.value = true;
                              otpControllers.forEach((controller) => controller.clear());
                              loginController.Password.value = '';
                            },
                                      child: Text(
                                        "Change number",
                                        style: GoogleFonts.roboto(
                                            fontSize: 16,
                                            color: AppColors.text,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),



                                    _canResend
                                        ?  Text(
                                      "Resend Code",
                                      style: GoogleFonts.roboto(
                                          fontSize: 16,
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w500),
                                    )
                                        : Text(" $_secondsRemaining sec",
                                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                                        ),


                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
              ),
              Container(
                height: height * 0.38,
                child: Image.asset(AppImagePaths.loginScreenLogo),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
