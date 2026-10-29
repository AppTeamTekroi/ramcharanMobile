import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
/// 🔠 Uppercase Formatter (FOR IFSC, PAN, etc.)
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
