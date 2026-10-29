import 'package:flutter/material.dart';
import 'package:ramcharan/ui/color/appColor.dart';

class EngneerCommonRichText extends StatelessWidget {
  final String label;
  final dynamic value;

  const EngneerCommonRichText({Key? key, required this.label, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      maxLines: 20,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        text: '$label ',
        style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 14),

        //  style: TextStyle(color: AppColors.blues, fontWeight: FontWeight.w500, fontSize: 15),
        children: [
          TextSpan(
            text: value.toString(), // Convert value to string
            style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 14),
          ),
        ],
      ),
    );
  }
}