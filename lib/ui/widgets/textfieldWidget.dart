// import 'package:flutter/material.dart';
//
// class Textfieldwidget extends StatelessWidget {
//   final TextEditingController controller;
//   final String hinttext;
//   final bool isDateField; // Added a flag to distinguish date fields
//   final onChanged;
//   final double width;
//   Textfieldwidget({
//     Key? key, // Added the key parameter
//     required this.controller,
//     required this.hinttext,
//     this.onChanged,
//     required this.width,
//     this.isDateField = false, // Default to false if not specified
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final h = MediaQuery.of(context).size.height;
//     final w = MediaQuery.of(context).size.width;
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 10),
//       height: h*0.03,
//       width: width,
//       // height: h*0.04,
//       // width: w*0.25,
//       decoration: BoxDecoration(
//         color: Colors.grey[200],
//         borderRadius: BorderRadius.circular(9),
//       ),
//       child: GestureDetector(
//           onTap: isDateField
//               ? () async {
//                   // Show date picker if it is a date field
//                   DateTime? pickedDate = await showDatePicker(
//                     context: context,
//                     initialDate: DateTime.now(),
//                     firstDate: DateTime(2000),
//                     lastDate: DateTime(2100),
//                   );
//
//                   if (pickedDate != null) {
//                     // Format the selected date and set it to the controller
//                     String formattedDate =
//                       // "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
//                        "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
//                         controller.text = formattedDate;
//                   }
//                 }
//               : null, // Disable onTap if not a date field
//           child: AbsorbPointer(
//             absorbing: isDateField, // Prevent manual editing for date fields
//             child: TextFormField(
//               controller: controller,
//               onChanged: onChanged,
//               maxLines: 1,
//               style: TextStyle(
//                 fontSize: h * 0.02,
//                 color: Colors.black,
//               ),
//               decoration: InputDecoration(
//                 border: InputBorder.none,
//                 hintText: hinttext,
//                 hintStyle: TextStyle(
//
//                   color: Colors.grey.withOpacity(1),
//                   fontSize: h * 0.015,
//                   fontWeight: FontWeight.w500,
//                 ),
//                 contentPadding: const EdgeInsets.all(9),
//               ),
//               keyboardType: TextInputType.number,
//             ),
//           ),
//         ),
//
//     );
//   }
// }
import 'package:flutter/material.dart';

class Textfieldwidget extends StatelessWidget {
  final TextEditingController controller;
  final String hinttext;
  final bool isDateField; // Flag to distinguish date fields
  final bool isEnabled; // New parameter to control text field enable/disable
  final ValueChanged<String>? onChanged; // Added proper typing for onChanged
  final double width;

  Textfieldwidget({
    Key? key, // Added key parameter
    required this.controller,
    required this.hinttext,
    this.onChanged,
    required this.width,
    this.isDateField = false, // Default to false if not specified
    this.isEnabled = true, // New parameter with a default value
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: h * 0.05,
      width: width,
      decoration: BoxDecoration(
        color: isEnabled ? Colors.grey[200] : Colors.grey[300], // Adjust color based on enabled state
        borderRadius: BorderRadius.circular(9),
      ),
      child: GestureDetector(
        onTap: isDateField
            ? () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );

          if (pickedDate != null) {
            String formattedDate =
                "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
            controller.text = formattedDate;
          }
        }
            : null, // Disable onTap if not a date field
        child: AbsorbPointer(
          absorbing: isDateField, // Prevent manual editing for date fields
          child: TextFormField(
            controller: controller,
            onChanged: onChanged,
            enabled: isEnabled, // Enable/disable text field based on parameter
            maxLines: 1,
            style: TextStyle(
              fontSize: h * 0.02,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hinttext,
              hintStyle: TextStyle(
                color: Colors.grey.withOpacity(0.8),
                fontSize: h * 0.015,
                fontWeight: FontWeight.w500,
              ),
              contentPadding: const EdgeInsets.all(9),
            ),
           // keyboardType: isDateField ? TextInputType.datetime : TextInputType.text,
          ),
        ),
      ),
    );
  }
}
