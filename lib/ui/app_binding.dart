
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get.dart';
import 'package:ramcharan/features/controllers/farmerController.dart';
import 'package:ramcharan/features/controllers/report_controller.dart';
import 'package:ramcharan/features/userController.dart';
import '../Login/login_controller.dart';


class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<LoginController>(LoginController(), permanent: true);
    Get.put<UserController>(UserController(), permanent: true);
    Get.put<FarmerController>(FarmerController(), permanent: true);
    Get.put<ReportController>(ReportController(), permanent: true);
  }

}
