import 'package:flutter/services.dart';

class TFLiteHelper {
  static const _channel = MethodChannel('com.company.ramcharan/tflite');

  static Future<String> runInference(String imagePath) async {
    try {
      final result = await _channel.invokeMethod('runModel', {
        'imagePath': imagePath,
      });
      return result.toString();
    } on PlatformException catch (e) {
      return "Failed: '${e.message}'.";
    }
  }
}
