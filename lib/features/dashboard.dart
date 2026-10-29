import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ramcharan/Login/login_controller.dart';
import 'package:ramcharan/features/CropList.dart';
import 'package:ramcharan/features/FarmerRegistration.dart';
import 'package:ramcharan/features/PriceManagement.dart';
import 'package:ramcharan/features/controllers/farmerController.dart';
import 'package:ramcharan/features/farmerList.dart';
import 'package:get/get.dart';
import 'package:ramcharan/features/salesReportpage.dart';
import 'package:ramcharan/features/syncStatus.dart';
import '../ui/assets/app_assets.dart';
import '../ui/color/appColor.dart';
import 'InventoryScreen.dart';
import 'Ledger.dart';
import 'NewCropRegister.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
   HomeScreen({super.key});

  LoginController login = Get.find();
  FarmerController farmerController = Get.find();

   @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _greeting(),
            _statsSection(context),
            // _priceManagmemt(context),

            _buildSectionTitle("Quick Actions"),
            _quickActions(context),
            // syncStatus(),
          ],
        ),
      ),
      // bottomNavigationBar: _bottomNav(context),
      // floatingActionButton: _fab(context),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        children: [
           CircleAvatar(
            radius: 18,
            backgroundImage: AssetImage(AppImagePaths.applogo)

            // NetworkImage(
            //   "https://lh3.googleusercontent.com/aida-public/AB6AXuCF0531i9Mnu6OALc9O9IGzmmnhAhyoVNC67kRSgBPAsDtUeVLuEIese6BJ_uJjWjxEkhIXofhBCOb5xhj-vCx_Ozk1ut1FxmsRMwYKGzc2fOBQXz2_ZRbLKBRsOApqB16muvkbR3jsMagAMobUWh4tv_1JPW0mFXNYKgBFLMb_MHRpkF7ZhDhj_jJ7nCqwPX9rUeo2xQ9w7w_Rj-u8KGAFziajcOpKR8DJEhAaY5pPnAbYO2Sn4J6KLeD3qY7BO5CxbFmU0a06CdQ",
            // ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Ramcharan Oil Industries",
                  style: GoogleFonts.inter(
                      fontSize: 14, fontWeight: FontWeight.bold)),
              Text("Agent #000${login.userId}",
                  style: GoogleFonts.inter(
                      fontSize: 10, color: Colors.grey)),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none, color: Colors.grey),
          onPressed: () {},
        )
      ],
    );
  }

  Widget _greeting() {
    final name = login.Name.trim();
    var todayDate = DateFormat('EEE, MMM dd').format(DateTime.now());

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$todayDate",
              style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey)),
          const SizedBox(height: 6),
          RichText(
            text: TextSpan(
              style: GoogleFonts.inter(fontSize: 24, color: Colors.black),
              children: [
                const TextSpan(text: "Hello, "),
                TextSpan(
                  text: name.isNotEmpty ? name : 'User',
                  style: const TextStyle(
                      color: Color(0xffED2327),
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Obx(()=>
          Row(
          children: [
            GestureDetector(
                onTap: (){
                  Get.to(()=>ReportListScreen());
                },
                child: _bigStat("Today's Collection",farmerController.totalCollection.value, "kg", Icons.scale, context)),
            // farmerController.totalCollection.value

            const SizedBox(width: 10),
            Expanded(
              child: Column(
                children: [
                  GestureDetector(
                      onTap: (){
                        Get.to(()=>Farmerlist(fromCrop: false));
                      },
                      child:
                  _smallStat("Active Farmers", "${farmerController.activeFarmers.value}", Icons.group)),
                  const SizedBox(height: 10),
                  _smallStat("Today", "${farmerController.totalLoads.value} Loads", Icons.local_shipping),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child:
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 16,
                decoration: BoxDecoration(
                    color: const Color(0xffED2327),
                    borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(width: 8),
              Text(title,
                  style: GoogleFonts.inter(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          GestureDetector(
            onTap:()=> Get.to(()=> LedgerScreen()),
            child: Container(
              // width: ,
              height: 28,
              padding: EdgeInsets.symmetric(vertical: 1,horizontal: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                border: Border.all(color: AppColors.primary,
                    width: 1
                ),
                color: AppColors.secondary,
               ),
              child: Row(
                children: [


                  // Icon(Icons.price_check_outlined, color: const Color(0xffED2327)),

                  Text("Ledger",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(fontSize: 13,
                          fontWeight: FontWeight.w600)),
                ],
              ),

            ),
          ),
        ],
      ),
    );
  }
  Widget _bigStat(String title, String value, String unit, IconData icon, context) {
    final height = MediaQuery.of(context).size.height;
    return Container(
      height: height * 0.2,
      width: height * 0.23,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xffED2327),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white24,
            child: Icon(icon, color: Colors.white),
          ),
          Text(title,
              style: GoogleFonts.inter(
                  fontSize: 15, color: Colors.white70)),
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: AutoSizeText(
              value,
              maxLines: 1,
              minFontSize: 10,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            unit,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),



      // Row(
        //     children: [
        //       Text(value,
        //           overflow: TextOverflow.ellipsis,
        //
        //           style: GoogleFonts.inter(
        //               fontSize: 28,
        //               fontWeight: FontWeight.bold,
        //               color: Colors.white)),
        //       const SizedBox(width: 4),
        //       Text(unit,
        //           style: GoogleFonts.inter(color: Colors.white70)),
        //     ],
        //   ),
        ],
      ),
    );
  }
  Widget _smallStat(String title, String value, IconData icon) {
    return Container(
      height: 75,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: Colors.grey.shade100,
            child: Icon(icon, size: 16),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(value,
                  style: GoogleFonts.inter(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              Text(title,
                  style: GoogleFonts.inter(
                      fontSize: 10, color: Colors.grey)),
            ],
          )
        ],
      ),
    );
  }

  Widget _priceManagmemt(BuildContext context) {
     return Padding(
       padding: const EdgeInsets.symmetric(vertical:  5.0,horizontal:  15),
       child: Row(
         children: [
           Container(
             padding: EdgeInsets.all(9),
             decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(8),
                 border: Border.all(color: AppColors.white,
                     width: 4
                 ),
           color: AppColors.secondary,
             ),
             child: Row(
               children: [


             Icon(Icons.price_check_outlined, color: const Color(0xffED2327)),

               const SizedBox(height: 8),
               Text("Price Managment",
               textAlign: TextAlign.center,
               style: GoogleFonts.inter(
               fontSize: 11, fontWeight: FontWeight.w600)),
               ],
               ),

           ),
         ],
       ),
     );
  }
   Widget syncStatus() {
     return Padding(
       padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
       child: SizedBox(
         width: double.infinity,
         child: ElevatedButton(
           onPressed: () {
            Get.to(()=>SyncStatusScreen());
           },
           style: ElevatedButton.styleFrom(
             backgroundColor: AppColors.secondary,
             foregroundColor: Colors.black,
             padding: const EdgeInsets.symmetric(vertical: 14),
             shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(10),
               side: const BorderSide(
                 color: Colors.white,
                 width: 2,
               ),
             ),
             elevation: 2,
           ),
           child: Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               const Icon(Icons.price_check_outlined, color: Color(0xffED2327)),
               const SizedBox(width: 10),
               Text(
                 "Check Sync Status",
                 style: GoogleFonts.inter(
                   fontSize: 13,
                   fontWeight: FontWeight.w600,
                 ),
               ),
             ],
           ),
         ),
       ),
     );
   }
  Widget _quickActions(BuildContext context) {
    final actions = [
      ("Register Farmer", Icons.person_add,  () => Get.to(() => const FarmerRegistrationScreen())),
      ("Farmers Data", Icons.groups, () => Get.to(() => const Farmerlist(fromCrop: false,))),
      ("Create FFB", Icons.add_circle,  () => Get.to(() => const NewCropRegister())),
      ("View Collection", Icons.inventory_2, () => Get.to(() => const Croplist())),
      ("Reports", Icons.analytics, () => Get.to(() => ReportListScreen())),
      ("Inventory Transfer", Icons.local_shipping, () => Get.to(() => const InventoryScreen())),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: actions.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          mainAxisExtent: 110,
        ),
        itemBuilder: (_, index) {
          final item = actions[index];
          return InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: item.$3,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(9),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.secondary,
                      width: 4
                      )

                    ),
                    child: Icon(item.$2, color: const Color(0xffED2327)),
                  ),
                  const SizedBox(height: 8),
                  Text(item.$1,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                          fontSize: 11, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
