import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ramcharan/features/controllers/farmerController.dart';

import '../../features/controllers/report_controller.dart';

class ReportDrawerScreen extends StatefulWidget {
  const ReportDrawerScreen({Key? key}) : super(key: key);

  @override
  State<ReportDrawerScreen> createState() => _ReportDrawerScreenState();
}

class _ReportDrawerScreenState extends State<ReportDrawerScreen> {
  final FarmerController cc = Get.find<FarmerController>();
  final ReportController rc = Get.find<ReportController>();

  String? selectedMandal;
  String? selectedVillage;
  String? selectedDistrict;


  String? selectedFarmer;
  String activeFilter = "district"; // current section displayed at right side
  int? selectedMandalIndex;
  int? selectedVillageIndex;
  int? selectedDistrictIndex;
  int? selectedFarmerIndex;
  int? selectedId;
  int? selectedMandalId;

  String selectedDistrictName = "";
  String selectedMandalName = "";
  String selectedVillageName = "";
  int selectedFarmerName = 0;

  List<String> selectedList = ["", "", "", ""];




  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Container(
      width: width,
      height: height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(22),
          topRight: Radius.circular(22),
        ),
      ),
      child: Column(
          children: [
          const SizedBox(height: 10),
      Center(
        child: Container(
          height: 3,
          width: 80,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      const SizedBox(height: 10),
      Expanded(
        child: Row(
                  children: [
                    // 🔹 LEFT DRAWER FILTERS
                    Container(
                      width: width * 0.3,
                      height: height,
                      color: Colors.grey.shade100,
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Filters",
                              style:
                              TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const Divider(),
                          const SizedBox(height: 10),

                          // Mandal filter
                          ListTile(
                            tileColor: activeFilter == "district"
                                ? Colors.green
                                : Colors.transparent,
                            title: const Text("District",style:  TextStyle(fontSize: 14,)),
                            onTap: () {
                              setState(() {
                                activeFilter = "district";
                              });
                            },
                          ),
                          ListTile(
                            tileColor: activeFilter == "mandal"
                                ? Colors.green.shade100
                                : Colors.transparent,
                            title: const Text("Mandal",style:  TextStyle(fontSize: 14,)),
                            onTap: () {
                              setState(() {
                                activeFilter = "mandal";
                                cc.mandal(context, rc.mandalId.value ?? 0);
                              });
                            },
                          ),

                          // Village filter
                          ListTile(
                            tileColor: activeFilter == "village"
                                ? Colors.green.shade100
                                : Colors.transparent,
                            title: const Text("Village",style:  TextStyle(fontSize: 14,)),
                            onTap: () {
                              setState(() {
                                activeFilter = "village";
                                cc.village(context, rc.villageId.value ?? 0); // call your API if needed
                              });
                            },
                          ),

                          // Farmer filter
                          ListTile(
                            tileColor: activeFilter == "farmer"
                                ? Colors.green.shade100
                                : Colors.transparent,
                            title: const Text("Farmer",style:  TextStyle(fontSize: 14,)),
                            onTap: () {
                              setState(() {
                                activeFilter = "farmer";
                                cc.farmerList(context); // call your API
                              });
                            },
                          ),
                          ListTile(
                            title: const Text("Clear",style: TextStyle(fontSize: 14,color: Colors.red),),
                            onTap: () {
                              setState(() {
                                // activeFilter = "farmer";
                                rc.district.value = "";
                                rc.districtIndex.value = -1;
                                rc.mandalId.value = 0;
                                rc.mandal.value = "";
                                rc.village.value = "";
                                rc.villageIndex.value = -1;
                                rc.farmerName.value = "";
                                rc.farmerId.value  = 0;
                                rc.farmerIndex.value = -1;

                              });
                            },
                          ),
                          ListTile(
                            title: const Text("Apply",style: TextStyle(fontSize: 14,color: Colors.blue),),
                            onTap: () {
                              setState(() {
                                rc.Reportlist(context, 'FBB Report',);
                                Get.back();
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    // 🔹 RIGHT SIDE — DATA DISPLAY BASED ON SELECTION
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(10),
                        child: Obx(() {
                          if (activeFilter == "district") {
                            if (cc.isLoading6.value) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            return _buildListView(cc.districtData, "district_name","district_id");
                          }

                          if (activeFilter == "mandal") {
                            if (cc.isLoading7.value) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            return _buildListView(cc.mandalData, "mandal_name","mandal_id");
                          }

                          if (activeFilter == "village") {
                            if (cc.isLoading10.value) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            return _buildListView(cc.villageData, "village_name","village_id");
                          }

                          if (activeFilter == "farmer") {
                            if (cc.isLoading6.value) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            return _buildListView(cc.filteredList, "farmer_name","id");
                          }

                          return const Center(child: Text("Select a filter from the left"));
                        }),
                      ),
                    ),
                  ],
                ),
              ),

          ]
      ),
    );
  }

  Widget _buildListView(List data, String labelKey, String id) {
    if (data.isEmpty) {
      return const Center(child: Text("No data found"));
    }

    int? currentIndex;
    if (activeFilter == "district") currentIndex = rc.districtIndex.value;
    if (activeFilter == "mandal") currentIndex = rc.mandalIndex.value;
    if (activeFilter == "village") currentIndex = rc.villageIndex.value;
    if (activeFilter == "farmer") currentIndex = rc.farmerIndex.value;


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Search...',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: EdgeInsets.all(0)
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];

              return Container(

                color: currentIndex == index
                    ? Colors.green.shade100
                    : Colors.white,
                child: ListTile(
                  title: Text(item[labelKey].toString()),
                  onTap: () {
                    setState(() {
                      if (activeFilter == "district") {
                        rc.district.value = item[labelKey].toString();
                        rc.districtIndex.value = index;
                        rc.mandalId.value = item[id]; // Next API calls use this
                      }

                      if (activeFilter == "mandal") {
                        rc.mandal.value = item[labelKey].toString();
                        rc.mandalIndex.value = index;
                        rc.villageId.value = item[id]; // Used for village API
                      }

                      if (activeFilter == "village") {
                        rc.village.value = item[labelKey].toString();
                        rc.villageIndex.value = index;
                      }

                      if (activeFilter == "farmer") {
                        rc.farmerName.value = item[labelKey].toString();
                        rc.farmerId.value = int.tryParse(item[id].toString()) ?? 0;
                        rc.farmerIndex.value = index;
                      }
                    });


                    print("Selected ID: $selectedId");
                    print("Selected Mandal ID: $selectedMandalId");
                    print("Selected List => $selectedList");
                  },
                ),
              );
            },
          ),
        )
      ],
    );
  }
}