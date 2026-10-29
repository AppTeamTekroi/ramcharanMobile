import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../ui/color/appColor.dart';
import '../ui/widgets/richtext.dart';
import 'controllers/farmerController.dart';

class Inventorylisting extends StatelessWidget {
  const Inventorylisting({super.key});

  @override
  Widget build(BuildContext context) {
    FarmerController farmer = Get.find();
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return  Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        // automaticallyImplyLeading: false,
        // toolbarHeight: 120,
        // leadingWidth: 40,
        // iconTheme: const IconThemeData(
        //   color: Colors.grey, // ✅ makes the back arrow white
        // ),
        backgroundColor: AppColors.white,
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                    Text("Inventory Transfer",
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
                // GestureDetector(
                //   onTap: () {
                //     Get.to(FarmerRegistrationScreen());
                //   },
                //   child: Padding(
                //     padding: const EdgeInsets.only(right: 8.0),
                //     child: Container(
                //       padding: EdgeInsets.all(5),
                //       decoration: BoxDecoration(
                //           color: AppColors.primary,
                //           borderRadius: BorderRadius.circular(8)),
                //       child: Icon(
                //         Icons.add,
                //         color: AppColors.white,
                //       ),
                //     ),
                //   ),
                // )
              ],
            ),
            // SizedBox(
            //   height: 15,
            // ),
            // Container(
            //   margin: EdgeInsets.only(right: 0, left: 0, bottom: 12),
            //   decoration: BoxDecoration(
            //     color: Color(0xFFF1F1F1),
            //     borderRadius: BorderRadius.circular(10),
            //     // border: Border.all(
            //     //     color: AppColors.secondary, width: 1),
            //   ),
            //   child: Padding(
            //     padding: const EdgeInsets.only(left: 10, right: 5),
            //     child: TextField(
            //       decoration: InputDecoration(
            //           hintText: "Search Name or Phone...",
            //           hintStyle: GoogleFonts.openSans(
            //               fontSize: 18,
            //               fontWeight: FontWeight.w400,
            //               color: AppColors.text),
            //           border: InputBorder.none,
            //           //suffixIcon:
            //           // Padding(
            //           //   padding: const EdgeInsets.only(top: 15),
            //           //   child: Padding(
            //           //     padding: const EdgeInsets.only(left: 8, right: 8),
            //           //     child: Text(
            //           //       'Search',
            //           //       style: TextStyle(fontSize: 15),
            //           //     ),
            //           //   ),
            //           // )
            //           prefixIcon: Icon(Icons.search, color: AppColors.text)),
            //       // onChanged: (val) {
            //       //   // Use the original full list (not already filtered one)
            //       //   if (val.isNotEmpty && val.length > 2) {
            //       //     // start search after 3+ chars (optional)
            //       //     final query = val.toLowerCase();
            //       //
            //       //     farmer.filteredList.value =
            //       //         farmer.opplist.where((item) {
            //       //           final name = item["farmer_name"]?.toLowerCase() ?? '';
            //       //           final phone = item["farmer_mobile"].toString() ?? '';
            //       //           return name.contains(query) || phone.contains(query);
            //       //         }).toList();
            //       //   } else {
            //       //     farmer.filteredList.value = farmer.opplist;
            //       //   }
            //       //
            //       //   farmer.filteredList.refresh();
            //       // },
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
          child: Obx(
                () => ListView.builder(
                itemCount: farmer.inventoryData.length,
                itemBuilder: (context, index) {
                  final data = farmer.inventoryData[index];
                  final status = data['sap_sync'];
                  final bool = false;
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 8),
                    child: GestureDetector(
                      onTap: () {
                        bool != bool;
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
                                    // onTap: () {
                                    //   Get.to(() => Farmerdetails(
                                    //     data: data,
                                    //     farmerId: data['id'],
                                    //   ));
                                    // },
                                    child: Row(
                                      spacing: 5,
                                      children: [
                                        Text("Item: ${
                                          data['item_code'].toString()}",
                                          style: GoogleFonts.roboto(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15),
                                        ),
                                        Container(
                                          height: height * 0.025,
                                           padding: EdgeInsets.symmetric(horizontal: 5),                                          decoration: BoxDecoration(
                                              color: status == 0 ? Colors.red.shade50:Colors.green.shade50,
                                              //AppColors.green,
                                              // Color.fromARGB(255, 255, 232, 157),
                                              //  Color(0Xff30CB00),
                                              borderRadius:
                                              BorderRadius.circular(12)),
                                          child: Center(
                                            child: Text(status == 0 ? 'Sync Pending': "SAP Synced",
                                                style: TextStyle(
                                                    fontSize: height * 0.01,
                                                    color: status == 0 ? Colors.red:Colors.green,
                                                    fontWeight: FontWeight.bold)),
                                          ),
                                        ),
                                        Spacer(),

                                        Padding(
                                          padding:
                                          const EdgeInsets.only(right: 0.0),
                                          child: Container(
                                            // padding: EdgeInsets.all(12),
                                            // decoration: BoxDecoration(color: Colors.red.shade50,
                                            //     borderRadius: BorderRadius.circular(8)
                                            // ),
                                              child:                                       Text('Qty: ${data['quantity']}'),



                                              // Text('Details➤',style: TextStyle(
                                              //   fontSize: 15,
                                              //   color: AppColors.text,
                                              // ),
                                              )
                                        //),
                                        ),
                                      ],
                                    ),
                                  ),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Doc Entry: ${data['doc_entry']}'),
                            Text('Transfer Id: ${data['transfer_id']}'),
]
                        ),

                            CommonRichText(
                                    label: 'From warehouse',
                                    value: data['from_warehouse'].toString(),
                                  ),
                                  CommonRichText(
                                    label: 'To warehouse',
                                    value: data['to_warehouse'].toString(),
                                  ),
                                  // Text('Doc Entry: ${data['doc_entry']}'),

                                  // if(bool == true)
                                  // Row(
                                  //   mainAxisAlignment:
                                  //   MainAxisAlignment.spaceBetween,
                                  //   children: [
                                  //     Text('Doc Entry: ${data['doc_entry']}'),
                                  //     Text('Transfer Id: ${data['transfer_id']}'),
                                  //

                                      // Text('📍${data['item_code']}'),
                                      // GestureDetector(
                                      //   onTap: () => Get.to(() =>NewCropRegister(
                                      //     selectedFarmer: data,
                                      //   )),
                                      //   child: Padding(
                                      //     padding:
                                      //     const EdgeInsets.only(right: 8.0),
                                      //     child: Container(
                                      //       padding: EdgeInsets.symmetric(
                                      //           horizontal: 12, vertical: 5),
                                      //       decoration: BoxDecoration(
                                      //           color: Colors.red.shade50,
                                      //           borderRadius:
                                      //           BorderRadius.circular(8)),
                                      //       child: Text(
                                      //         "ADD FFB",
                                      //         style: TextStyle(
                                      //           color: AppColors.primary,
                                      //           fontSize: 11,
                                      //         ),
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                  //   ],
                                  // )
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
        )
    );

   // );
  }
}
