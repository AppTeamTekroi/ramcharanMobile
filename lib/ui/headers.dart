import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'assets/app_assets.dart';


class CommonHeader extends StatefulWidget {
   final Color? color;
   const CommonHeader(this.color, {super.key});

  @override
  _CommonHeaderState createState() => _CommonHeaderState();
}

class _CommonHeaderState extends State<CommonHeader> {
  String name = "Loading...";

  @override
  void initState() {
    super.initState();
    getUserName(); // Fetch stored username
  }

  Future<void> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedName = prefs.getString('name');
    print("Fetched Name from SharedPreferences: $storedName"); // Debug log

    setState(() {
      name = storedName ?? 'Unknown';
    });

    print("Updated Name in UI: $name"); // Debug log
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width; // Get screen width

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.white,
            child: Image.asset(AppImagePaths.kims, fit: BoxFit.cover),
          ),
          SizedBox(width: w * 0.02),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w700,color: widget.color ?? Colors.white),
              ),
              Text(
                "Hello, Welcome back to your account.",
                style: TextStyle(fontSize: 13, color:  widget.color ?? Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
