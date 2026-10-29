import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  var pageNumber = 0.obs;
  var expand = true.obs;
  var idx = 0.obs;
  var pageController = PageController(initialPage: 0);
  var currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void onPageChanged(int index) {
    currentIndex.value = index;
    update();
  }

  void toggleExpand() {
    expand.value = !expand.value;
  }
}
