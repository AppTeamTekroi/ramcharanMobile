
import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:ramcharan/Login/login_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ramcharan/features/controllers/farmerController.dart';
import 'package:ramcharan/features/userController.dart';
import 'dashboard.dart';
import 'Profile.dart';
import 'farmerList.dart';




class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}
class _BottomNavState extends State<BottomNav> {

  LoginController lc = Get.find();
  UserController uc = Get.find();
  FarmerController farmer = Get.find();
  @override
  void initState() {
    super.initState();
    getUserName();
    farmer.UserSummary(context);
    farmer.farmerList(context);
    farmer.districtList(context);
    farmer.cropList(context);
    farmer.collectionCenter(context);
    farmer.inventoryList(context);

  }
  int _selectedIndex = 0;
  bool _isProfileSelected = false;

  List<Widget> pages = [
    HomeScreen(),
    Farmerlist(fromCrop: false,),
    Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _isProfileSelected = false;
      uc.pageNumber.value = index;
    });
  }
  Future<bool> _onWillPop() async {
    if (_selectedIndex != 0) {
      // If the current page is not the HomeScreen, navigate back to it.
      setState(() {
        _selectedIndex = 0;
      });
      uc.pageNumber.value = 0;
      return false; // Do not exit the app.
    }
    return true; // Exit the app if already on the HomeScreen.
  }
  String name = "Loading...";

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
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;


    return  PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) {
            return;
          }
          final navigator = Navigator.of(context);
          bool value = await _onWillPop();
          if (value) {
            navigator.pop(result);
          }
        },

        child:Scaffold(

          body:  pages[_selectedIndex],

          bottomNavigationBar: SafeArea(
            child: Container(
              // width: w * 0.75,
              // height: h* 0.1,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              // decoration: BoxDecoration(
              //   color: Colors.white,
              //   border: Border(
              //     right: BorderSide(
              //       color: Colors.red,
              //       width: 3,
              //     ),
              //     left:   BorderSide(
              //       color: Colors.red,
              //       width: 3,
              //     ),
              //   ),
              //   borderRadius: BorderRadius.circular(40), // This makes it pill-shaped
              //   // boxShadow: [
              //   // BoxShadow(
              //   // color: Colors.black12,
              //   // blurRadius: 10,
              //   // offset: Offset(0, 4),
              //   // )
              //   // ],
              // ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildNavItem(Icons.home, 0,'Home'),
                  buildNavItem(Icons.people, 1,'Farmers'),
                  // buildNavItem(Icons.grass, 2,'Crop'),

                  buildNavItem(Icons.person, 2,'Profile'),
                ],
              ),
            ),
          ),
          backgroundColor: Colors.white,
        )
    );
  }

  Widget buildNavItem(IconData icon, int index, String name) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        height: 50,
        child: Column(
          children: [
            Icon(
              icon,size: 25,
              color: isSelected ? Colors.red[900] : Colors.black54,
            ),
            Text(name,style: TextStyle(fontSize: 12),)
          ],
        ),
      ),
    );
  }
}



// void showBottomSheetWidget(BuildContext context, Widget childWidget) {
//   showModalBottomSheet(
//     isScrollControlled: true,
//     context: context,
//     builder: (context) => Padding(
//       padding:
//       EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
//       child: childWidget,
//     ),
//   );
// }
//
//
// Widget _buildNavIcon(String assetPath, bool isActive) {
//   return ColorFiltered(
//     colorFilter: ColorFilter.mode(
//       isActive ? AppColors.primary : AppColors.text,
//       BlendMode.srcIn,
//     ),
//     child: Image.asset(
//       assetPath,
//       width: 24,
//       height: 24,
//     ),
//   );
// }
