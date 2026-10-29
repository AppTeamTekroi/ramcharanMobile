import 'package:flutter/material.dart';

import 'assets/app_assets.dart';

class CommonBackground extends StatelessWidget {
  final Widget child; // This will wrap the content of each screen

  const CommonBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Colors.transparent, // Optional, useful if wrapping in another Scaffold
      body: Stack(
        children: [
          Image.asset(
            AppImagePaths.background,
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          Container(
           // color: Colors.black.withValues(alpha: 0.5), // transparent overlay
          ),
          child, // Your Column or content here
        ],
      )
    //  body:    Stack(
    //       children: [
    //         ColorFiltered(
    //           // colorFilter: ColorFilter.mode(
    //           //   // Colors.black.withValues(alpha: 0.9), // dull and semi-transparent effect
    //           //   // BlendMode.dstIn,
    //           // ),
    //           child: Image.asset(
    //             AppImagePaths.background,
    //             fit: BoxFit.cover,
    //             height: double.infinity,
    //             width: double.infinity,
    //           ),
    //         ),
    //         Container(
    //           color: Colors.black.withValues(alpha: 0.3), // additional transparent overlay
    //         ),
    //         child, // Your Column or content here
    //       ],
    //     )


    );
  }
}
class LoginBackground extends StatelessWidget{
  final Widget child; // This will wrap the content of each screen

  const LoginBackground({super.key, required this.child});


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Container(
                width: width,
                height: height/6.5,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppImagePaths.background),
                    fit: BoxFit.cover, // You can change to BoxFit.fill if needed
                  ),
                ),
              ),

              SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 15.0,
                  right: 15.0,
                  top: height * 0.075,
                  bottom: 20, // optional padding at bottom
                ),
                child: child,
              ),

              // Column(children: [
              //   Container(
              //     padding:  EdgeInsets.only(left: 15.0, right: 15.0,top: height*0.08),
              //
              //     child: child,
              //   ),
              // ],)

              // Positioned.fill(
              //   child: Container(
              //     padding:  EdgeInsets.only(left: 15.0, right: 15.0,top: height*0.08),
              //
              //     child: SingleChildScrollView(child: child),
              //   ),
              // ),
            ],
          );
        },
      ),
    );
  }
}

class BackgroundWidget extends StatelessWidget {
  final double? top, bottom, left, right;
  final List<Color> colors;

  const BackgroundWidget({
    Key? key,
    this.top,
    this.bottom,
    this.left,
    this.right,
    required this.colors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Positioned(
      top: top != null ? height * top! : null,
      bottom: bottom != null ? height * bottom! : null,
      left: left != null ? width * left! : null,
      right: right != null ? width * right! : null,
      child: Container(
        width: 300,
        height: 200,
        decoration: BoxDecoration(
          //shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: colors.map((color) => color.withOpacity(0.1)).toList(),
            center: Alignment.center,
            radius: 0.5,
          ),
        ),
      ),
    );
  }
}

