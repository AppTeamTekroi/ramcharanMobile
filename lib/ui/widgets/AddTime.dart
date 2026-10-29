
import "package:flutter/material.dart";
import 'package:get/get.dart';
import "../color/appColor.dart";
import "CommonWidget.dart";
class PriceWidgets {

  static Widget time(String title, TimeOfDay? time, VoidCallback onTap) {
    return FormCommonWidget(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text(title,
                style: CommonStyles.requestTextStyle(
                    weight: FontWeight.normal, color: AppColors.text)
              //   fontSize: 14,
              //   color: AppColors.container,
              // ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: onTap,
              child: Container(
                padding:
                const EdgeInsets.symmetric(vertical: 6, horizontal: 30),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  // border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  time?.format(Get.context!) ?? "00:00",
                  style: TextStyle(
                      fontSize: 12,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget timeRow(String title, TimeOfDay? time, VoidCallback onTap) {
    return FormCommonWidget(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text(title,
                style: CommonStyles.requestTextStyle(
                    weight: FontWeight.normal, color: AppColors.text)
              //   fontSize: 14,
              //   color: AppColors.container,
              // ),
            ),
            GestureDetector(
              onTap: onTap,
              child: Container(
                padding:
                const EdgeInsets.symmetric(vertical: 6, horizontal: 30),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  // border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  time?.format(Get.context!) ?? "00:00",
                  style: TextStyle(
                      fontSize: 12,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget input(String label, TextEditingController controller,
      {TextInputType keyboard = TextInputType.text, int? inputLength }) {
    return FormCommonWidget(
      color: AppColors.form,
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        maxLength: inputLength,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontWeight: FontWeight.w500,
              color: Color(0xFFB1C0CC),
              fontSize: 14),
          border: InputBorder.none,
          counterText: "",

          // border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  static Widget inputRemarks(String label, TextEditingController controller,
      {TextInputType keyboard = TextInputType.text, int? inputLength }) {
    return FormCommonWidget(
      color: AppColors.form,
      child: TextField(

        controller: controller,
        keyboardType: keyboard,
        maxLength: inputLength,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontWeight: FontWeight.w500,
              color: Color(0xFFB1C0CC),
              fontSize: 14),
          border: InputBorder.none,
          counterText: "",

          // border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  static Widget highlightContainer(text,Color? boxColor) {
    return
      Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),

        // width: width ,
        decoration: BoxDecoration(
            color: boxColor?.withValues(alpha: 0.1),
//AppColors.green,
// Color.fromARGB(255, 255, 232, 157),
//  Color(0Xff30CB00),
            borderRadius:
            BorderRadius.circular(12)),
        child: Center(
          child: Text(text,
              style: TextStyle(
                  fontSize: 12,
                  color: boxColor,
                  fontWeight: FontWeight.bold)),
        ),
      );
  }
}
// Row(
// children: [
// Expanded(
// child: TextField(
// controller: startDateController,
// readOnly: true,
// decoration: InputDecoration(
// prefixIcon: Icon(Icons.calendar_today,
// color: Colors.grey[600], size: 20),
// labelText: 'Start Date',
// border: OutlineInputBorder(
// borderRadius: BorderRadius.circular(12)),
// filled: true,
// fillColor: Colors.white70,
// ),
// onTap: () async {
// DateTime? picked = await showDatePicker(
// context: context,
// initialDate: DateTime.now(),
// firstDate: DateTime(2000),
// lastDate: DateTime(2100));
// if (picked != null) {
// setState(() {
// startDateController.text =
// "${picked.day}-${picked.month}-${picked.year}";
// });
// }
// },
// ),
// ),
// SizedBox(width: 12),
// Expanded(
// child: TextField(
// controller: endDateController,
// readOnly: true,
// decoration: InputDecoration(
// prefixIcon: Icon(Icons.event_busy,
// color: Colors.grey[600], size: 20),
// labelText: 'End Date',
// border: OutlineInputBorder(
// borderRadius: BorderRadius.circular(12)),
// filled: true,
// fillColor: Colors.white70,
// ),
// onTap: () async {
// DateTime? picked = await showDatePicker(
// context: context,
// initialDate: DateTime.now(),
// firstDate: DateTime(2000),
// lastDate: DateTime(2100));
// if (picked != null) {
// setState(() {
// endDateController.text =
// "${picked.day}-${picked.month}-${picked.year}";
// });
// }
// },
// ),
// ),
// ],
// ),