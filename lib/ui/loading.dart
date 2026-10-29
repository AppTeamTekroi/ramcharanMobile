import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'assets/app_assets.dart';

class LoadingOverlay {
  static void show(String text) {
    if (!Get.isDialogOpen!) {
      Get.dialog(
        PopScope(
          canPop: false, // disables back button & gesture pop
          onPopInvoked: (didPop) async {
            // Explicitly prevent popping
            return;
          },
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Material(
              color: Colors.transparent,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        AppImagePaths.applogo,
                        height: 90,
                        width: 70,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        text,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        barrierDismissible: false, // disables tap-outside dismiss
      );
    }
  }

  static void hide() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
  }
}
