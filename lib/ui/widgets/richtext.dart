 import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../color/appColor.dart';
// import 'package:healthware/ui/color/appColor.dart';
//
class CommonNormalRichText extends StatelessWidget {
  final String label;
  final dynamic value;

  const CommonNormalRichText({Key? key, required this.label, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      maxLines: 20,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        text: '$label',
        style: TextStyle(color: Colors.black87,fontWeight: FontWeight.w400,fontSize: 14),

      //  style: TextStyle(color: AppColors.blues, fontWeight: FontWeight.w500, fontSize: 15),
        children: [
          TextSpan(
            text: value.toString(), // Convert value to string
            style: TextStyle(color: Colors.black87,fontWeight: FontWeight.w500,fontSize: 15),
          ),
        ],
      ),
    );
  }
}
 class CommonRichText extends StatelessWidget {
   final String label;
   final String value;

   const CommonRichText({
     super.key,
     required this.label,
     required this.value,
   });

   @override
   Widget build(BuildContext context) {
     return Row(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         SizedBox(
           width: 130, // Adjust this width as needed for your labels
           child: Text(
             label,
             style:  GoogleFonts.openSans(color: AppColors.text,fontWeight: FontWeight.w400,fontSize: 13
             ),
           ),
         ),
         Expanded(
           child: Text(
             maxLines: 20,
             overflow: TextOverflow.ellipsis,
             value,
           style: GoogleFonts.openSans(color: AppColors.black,fontWeight: FontWeight.w500,fontSize: 14),
           ),
         ),
       ],
     );
   }
 }

