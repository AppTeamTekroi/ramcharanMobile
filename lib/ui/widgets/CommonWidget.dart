import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:get/get.dart';
import '../color/appColor.dart';

class FormCommonWidget extends StatelessWidget {
  final double? width;
  final Widget child;
  final Color? color;

  const FormCommonWidget({
    Key? key,
     this.width,
    this.color,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        height: 50,
        width: width ?? MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 0),
        decoration: BoxDecoration(
          // border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(10),
          color: color ?? Colors.transparent,
          boxShadow: const [
            BoxShadow(
              blurRadius: 6,
              color: Colors.black12,
            )
          ],
        ),
        child: child,
      ),
    );
  }
}
class CommonWidget extends StatelessWidget {
  final double? width;
  final Widget child;
  final Color? color;

  const CommonWidget({
    Key? key,
    this.width,
    this.color,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        width: width ?? MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(10),
          color: color ?? Colors.transparent,
        ),

        child: child,
      ),
    );
  }
}
//
// Container(
// width: width,
// height: height * 0.095,
// //requestType == "3" ? height * 0.2 :
// padding: EdgeInsets.symmetric(horizontal: 10),
// decoration: BoxDecoration(
// border: Border.all(color: Colors.grey),
// borderRadius: BorderRadius.circular(25),
// ),
// child:

class CommonStyles {

  static void showSnackbar({required bool status, required String message}) {
    Get.snackbar(
      status ? "Success" : "Error",
      "",
      snackPosition: SnackPosition.TOP, // ✅ Display at the bottom
      backgroundColor:  AppColors.white, // ✅ Success (green) or error color
      colorText: Colors.black,
      borderColor: status ? Colors.green : Colors.red,
      borderWidth: 1.5,
      isDismissible: false,
      // duration: Duration(seconds: 3), // ✅ Auto-dismiss after 3 seconds
      icon: Icon(
        status ? Icons.check_circle : Icons.error, // ✅ Tick icon for success, error icon otherwise
        color: Colors.green.shade900,
      ),
      snackStyle: SnackStyle.FLOATING, // ✅ Floating style snackbar
      titleText: SizedBox.shrink(),
      // Text(
      //   status ? "Success" : "Error",
      //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
      // ),
      messageText: Row(
        children: [
          Expanded(
            child: Text(
              message,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ),

      GestureDetector(
        onTap: () => Get.closeCurrentSnackbar(),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: status ? Colors.green.shade100 : Colors.red.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            "OK",
            style: TextStyle(
              color: status ? Colors.green.shade900 : Colors.red.shade900,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
        ],
      ),
    );
  }
//Color(0xFF17B54C)
  static TextStyle requestTextStyle({Color? color,FontWeight? weight, double? fontSize}) {
    return GoogleFonts.roboto(

            //Colors.text,
        fontSize: fontSize ?? 14,
        fontWeight: weight ?? FontWeight.w400,
        color :  color ?? AppColors.black,


    );

  }
  static TextStyle requestTextStyleOutline({Color? color,FontWeight? weight}) {
    return GoogleFonts.roboto(

      //Colors.text,
      fontSize: 14,
      fontWeight: weight ?? FontWeight.w400,
      foreground: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color =  (color ?? Colors.white),


    );

  }

  static Widget shimmerWidget() {
    return ListView.builder(
      itemCount: 2, // shimmer count
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      // height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius:
                        BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4, horizontal: 8),
                    child: Container(
                      height: 20,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius:
                        BorderRadius.circular(7),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.only(bottom: 10),
                    child: Container(
                      height: 30,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius:
                        BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}