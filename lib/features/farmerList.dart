import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:ramcharan/features/FarmerRegistration.dart';
import 'package:ramcharan/features/NewCropRegister.dart';
import 'package:ramcharan/features/scanner_sreen.dart';

import '../Login/login_controller.dart';
import 'customerNavBar.dart';
import 'userController.dart';
import '../ui/CommonBackground.dart';
import '../ui/assets/app_assets.dart';
import '../ui/color/appColor.dart';
import '../ui/headers.dart';
import '../ui/widgets/CommonWidget.dart';
import '../ui/widgets/richtext.dart';
import 'controllers/farmerController.dart';
import 'farmerDetails.dart';

class Farmerlist extends StatefulWidget {
  final bool fromCrop;
  const Farmerlist({super.key, required this.fromCrop});

  @override
  State<Farmerlist> createState() => _FarmerlistState();
}

class _FarmerlistState extends State<Farmerlist> {
  UserController upc = Get.find();
  FarmerController farmer = Get.find();

  // ADD THIS
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Pulls a usable code out of the QR (handles plain text and your
  // upi://pay?...&farmer_code=XYZ payload)
  String _extractCodeFromQr(String raw) {
    final uri = Uri.tryParse(raw);
    if (uri != null && uri.queryParameters['farmer_code'] != null) {
      return uri.queryParameters['farmer_code']!;
    }
    return raw.trim();
  }

  void _applyFilter(String val) {
    if (val.isNotEmpty && val.length > 2) {
      final query = val.toLowerCase();
      farmer.filteredList.value = farmer.opplist.where((item) {
        final name  = item["farmer_name"]?.toLowerCase() ?? '';
        final phone = item["farmer_mobile"].toString();
        final code  = (item["farmer_code"] ?? '').toString().toLowerCase();
        return name.contains(query) || code.contains(query) || phone.contains(query);
      }).toList();
    } else {
      farmer.filteredList.value = farmer.opplist;
    }
    farmer.filteredList.refresh();
  }

  Future<void> _openQrScanner() async {
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const QrScanPage()),
    );
    if (result == null || result.isEmpty) return;

    final query = _extractCodeFromQr(result);
    _searchController.text = query;
    _applyFilter(query);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Color(0xFFF1F1F1),
        appBar: AppBar(
          scrolledUnderElevation: 0,
          // automaticallyImplyLeading: false,
          toolbarHeight: 120,
          // leadingWidth: 40,
          // iconTheme: const IconThemeData(
          //   color: Colors.grey, // ✅ makes the back arrow white
          // ),
          backgroundColor: AppColors.white,
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // GestureDetector(
                  //   onTap: () => Get.back(),
                  //   child: Padding(
                  //     padding: const EdgeInsets.only(right: 8.0),
                  //     child: Icon(
                  //       Icons.arrow_back_ios,
                  //       color: AppColors.black,
                  //     ),
                  //   ),
                  // ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Farmers Directory",
                          style: GoogleFonts.openSans(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              wordSpacing: 0)),
                      Text("Ramcharan Oil Industries",
                          style: GoogleFonts.openSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              wordSpacing: 0,
                              color: Colors.grey)),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(FarmerRegistrationScreen());
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(8)),
                        child: Icon(
                          Icons.add,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                controller: _searchController,                    // ← add
                decoration: InputDecoration(
                  hintText: "Search Name or Phone...",
                  hintStyle: GoogleFonts.openSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: AppColors.text,
                  ),
                  border: InputBorder.none,
                  suffixIcon: GestureDetector(
                    onTap: _openQrScanner,                        // ← wire it
                    child: Icon(Icons.qr_code, color: AppColors.text),
                  ),
                ),
                onChanged: _applyFilter,                          // ← reuse same logic
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
          child: Obx(
            () => ListView.builder(
                itemCount: farmer.filteredList.length,
                itemBuilder: (context, index) {
                  final data = farmer.filteredList[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 8),
                    child: GestureDetector(
                      onTap: () {
                        if (widget.fromCrop == true) {
                          Get.back(result: data);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            // border: Border.all(
                            //     color: Colors.grey.shade300, width: 1),
                            color: Colors.white),
                        child: Row(
                          children: [
                            // CircleAvatar(
                            //   radius: 29,
                            //
                            //   // backgroundImage: AssetImage(
                            //   //   "lib/ui/assets/images/download.jpeg",
                            //   // ),
                            // ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Column(
                                spacing: 3,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Get.to(() => Farmerdetails(
                                        data: data,
                                        farmerId: data['id'],
                                      ));
                                    },
                                    child: Row(
                                      spacing: 5,
                                      children: [
                                        Text(
                                          data['farmer_name'],
                                          style: GoogleFonts.roboto(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15),
                                        ),
                                        // Container(
                                        //   height: height * 0.025,
                                        //   width: width * 0.15,
                                        //   decoration: BoxDecoration(
                                        //       color: Colors.green.shade50,
                                        //       //AppColors.green,
                                        //       // Color.fromARGB(255, 255, 232, 157),
                                        //       //  Color(0Xff30CB00),
                                        //       borderRadius:
                                        //           BorderRadius.circular(12)),
                                        //   child: Center(
                                        //     child: Text('Active',
                                        //         style: TextStyle(
                                        //             fontSize: height * 0.01,
                                        //             color: Colors.green,
                                        //             fontWeight: FontWeight.bold)),
                                        //   ),
                                        // ),
                                        Spacer(),

                                     Padding(
                                            padding:
                                                const EdgeInsets.only(right: 0.0),
                                            child: Container(
                                                // padding: EdgeInsets.all(12),
                                                // decoration: BoxDecoration(color: Colors.red.shade50,
                                                //     borderRadius: BorderRadius.circular(8)
                                                // ),
                                                child: Icon(
                                              Icons.arrow_forward_ios,
                                              size: 15,
                                              color: AppColors.text,
                                            )),
                                          ),
                                      ],
                                    ),
                                  ),
                                  CommonRichText(
                                    label: 'Farmer Code',
                                    value: data['farmer_code'],
                                  ),
                                  CommonRichText(
                                    label: 'Mobile',
                                    value: data['farmer_mobile'].toString(),
                                  ),
                                  if(data['status'] == 1)
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('📍${data['district']}'),
                                      GestureDetector(
                                        onTap: () => Get.to(() =>NewCropRegister(
                                          selectedFarmer: data,
                                        )),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 5),
                                            decoration: BoxDecoration(
                                                color: Colors.red.shade50,
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: Text(
                                              "ADD FFB",
                                              style: TextStyle(
                                                color: AppColors.primary,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ));
  }
}
