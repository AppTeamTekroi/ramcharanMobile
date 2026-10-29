import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ramcharan/features/controllers/farmerController.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../ui/color/appColor.dart';
import '../ui/widgets/richtext.dart';

class Croplist extends StatefulWidget {
  const Croplist({super.key});

  @override
  State<Croplist> createState() => _CroplistState();
}

class _CroplistState extends State<Croplist> {
  FarmerController qc = Get.find();
  String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  final ScrollController _scrollController = ScrollController();

  var totalrecords = "0".obs;
  var filterrecords = '0'.obs;
  var totalAmount = "₹0.00".obs;
  var sales_employee = "".obs;

  @override
  void initState() {
    super.initState();
    // qc.searchQuery.value = '';

  }

  Future<void> _launchURL(url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: AppColors.white,
          title: Text(
            "FFB Collection",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Column(children: [
          Expanded(child: Obx(() {
            if (qc.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else if (qc.errorMessage.value.isNotEmpty) {
              return Center(child: Text(qc.errorMessage.value));
            } else {
              if (qc.cropsData.isEmpty) {
                return Center(
                  child: Text(
                    'No records Found',
                    style: TextStyle(fontSize: 18),
                  ),
                );
              }
              return ListView.builder(
                  controller: _scrollController,
                  itemCount: qc.cropsData.length,
                  itemBuilder: (context, index) {
                    if (index == qc.cropsData.length) {
                      return Center(child: CircularProgressIndicator());
                    }
                    final item = qc.cropsData[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 5, horizontal: Get.height * 0.015),
                      child: InkWell(
                        onTap: () {},
                        child: Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Container(
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: Get.height * 0.015),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Receipt No: ${item["receipt_id"]}',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.primary),
                                      ),
                                      (item["pdf"] != null || item["pdf"] == "")
                                          ? GestureDetector(
                                              onTap: () {
                                                if (item["pdf"] != null &&
                                                    item["pdf"] != '') {
                                                  _launchURL(item["pdf"]);
                                                }
                                              },
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'View PDF',
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFFC09500),
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    // style: CommonWidget.,
                                                  ),
                                                ],
                                              ),
                                            )
                                          : GestureDetector(
                                              onTap: () {
                                                if (item["pdf"] != null &&
                                                    item["pdf"] != '') {
                                                  _launchURL(item["pdf"]);
                                                }
                                              },
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'Generate PDF',
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFFC09500),
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    // style: CommonWidget.,
                                                  ),
                                                ],
                                              ),
                                            ),
                                    ],
                                  ),

                                  Divider(),

                                  CommonRichText(
                                    label: 'Farmer Name: ',
                                    value: item["farmer_name"] ?? '',
                                  ),

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Driver Name'),
                                      Text((item["driver_name"]?.toString()) ??
                                          '- -'),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Driver Mobile'),
                                      Text(
                                          (item["driver_mobile"]?.toString()) ??
                                              '- -'),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Vehical No'),
                                      Text((item["vehicle_no"]?.toString()) ??
                                          '- -'),
                                    ],
                                  ),

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Gross Wt'),
                                      Text((item["gross_wt"]?.toString()) ??
                                          '- -'),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Tare Wt'),
                                      Text((item["tare_wt"]?.toString()) ??
                                          '- -'),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Net Wt'),
                                      Text((item["net_wt"]?.toString()) ??
                                          '- -'),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Rejection Wt'),
                                      Text((item["rejection_wt"]?.toString()) ??
                                          '- -'),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Final Wt'),
                                      Text((item["final_wt"]?.toString()) ??
                                          '- -'),
                                    ],
                                  ),

                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Text('Price: ${item["unit_price"] ?? '--'.toString()}'),
                                      Text('Govt Price: ${item["govt_price"] ?? '--'.toString()}'),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Text('Recorded: ${item["receipt_date"] ?? '--'.toString()}'),
                                      Text('Updated: ${item["govt_price_announce_date"] ?? '--'.toString()}'),
                                    ],
                                  ),
                                  // Row(
                                  //   mainAxisAlignment:
                                  //       MainAxisAlignment.spaceBetween,
                                  //   children: [
                                  //     Text(
                                  //       "Details➤",
                                  //       style: TextStyle(
                                  //         fontSize: 14,
                                  //         color: Colors.grey,
                                  //       ),
                                  //     ),
                                  //     Text(item["created_at"] ?? '- -'),
                                  //   ],
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            }
          })),
        ]));
  }
}
