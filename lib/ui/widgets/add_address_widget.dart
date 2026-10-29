import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ramcharan/features/controllers/farmerController.dart';

import '../../../../ui/color/appColor.dart';
import '../Buttons/button.dart';
import 'CommonWidget.dart';

class AddAddressWidget extends StatefulWidget {
  final String? district;
  final String? mandal;
  final String? village;

  const AddAddressWidget({
    Key? key,
    this.district,
    this.mandal,
    this.village,

  }) : super(key: key);

  @override
  State<AddAddressWidget> createState() => _AddAddressWidgetState();
}

class _AddAddressWidgetState extends State<AddAddressWidget> {
  final FarmerController cc = Get.find<FarmerController>();

  String? selectedDistrict;
  int? selectedDistrictId;
  String? selectedMandal;
  int? selectedMandalId;
  String? selectedVillage;
  int? selectedVillageId;

  @override
  void initState() {
    super.initState();
    selectedDistrict = widget.district;
    selectedMandal = widget.mandal;
    selectedVillage = widget.village;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Container(
      width: width,
      height: height * 0.45,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(22),
          topRight: Radius.circular(22),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const Text(
                'Enter Address',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),

              // District Dropdown
              CommonWidget(
                child: Obx(() {
                  if (cc.isLoading6.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return DropdownSearch<Map<String, dynamic>>(
                    selectedItem: selectedDistrictId != null
                        ? cc.districtData.firstWhere(
                          (d) => d['district_id'] == selectedDistrictId,
                    )
                        : null,

                    items: (filter, infiniteScrollProps) {
                      return cc.districtData
                          .cast<Map<String, dynamic>>()
                          .toList();
                    },

                    itemAsString: (district) => district['district_name'],

                    // ✅ REQUIRED FIX — NOTHING ELSE CHANGED
                    compareFn: (item, selectedItem) =>
                    item['district_id'] == selectedItem['district_id'],

                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                      fit: FlexFit.loose,
                      constraints: const BoxConstraints(maxHeight: 300),
                      searchFieldProps: TextFieldProps(
                        decoration: InputDecoration(
                          hintText: 'Search District...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        ),
                      ),
                    ),

                    onChanged: (district) async {
                      if (district == null) return;

                      setState(() {
                        selectedDistrict = district['district_name'];
                        selectedDistrictId = district['district_id'];
                        selectedMandal = null;
                        selectedMandalId = null;
                        selectedVillage = null;
                      });

                      // ✅ RESTORED — EXACTLY AS YOU HAD
                      await cc.mandal(context, selectedDistrictId!);
                    },

                    decoratorProps: DropDownDecoratorProps(
                      decoration: InputDecoration(
                        hintText: 'District', // ✅ HINT TEXT PRESERVED
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                      ),
                    ),
                  );


                }),
              ),

              // Mandal Dropdown
              CommonWidget(
                child: Obx(() {
                  if (cc.isLoading7.value) {
                    return const Center(child: CircularProgressIndicator());
                  }


                  return DropdownSearch<Map<String, dynamic>>(

                    selectedItem: selectedMandalId != null

                        ?
                    cc.mandalData.firstWhere(
                          (d) => d['mandal_id'] == selectedMandalId,
                    )
                    // "$selectedMandal"
                        : null,

                    items: (filter, infiniteScrollProps) {
                      return cc.mandalData
                          .cast<Map<String, dynamic>>()
                          .toList();
                    },

                    itemAsString: (district) => district['mandal_name'],

                    // ✅ REQUIRED FIX — NOTHING ELSE CHANGED
                    compareFn: (item, selectedItem) =>
                    item['mandal_id'] == selectedItem['mandal_id'],

                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                      fit: FlexFit.loose,
                      constraints: const BoxConstraints(maxHeight: 300),
                      searchFieldProps: TextFieldProps(
                        decoration: InputDecoration(
                          hintText: 'Search Mandal...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        ),
                      ),

                    ),


//,${mandal['mandal_id']}
                    onChanged: (mandal) async {
                      if (mandal == null) return;

                      setState(() {
                        selectedMandal = mandal['mandal_name'];
                        selectedMandalId = mandal['mandal_id'];
                        selectedVillage = null;
                        selectedVillageId = null;
                      });

                      // ✅ Load villages for selected mandal
                      await cc.village(context, selectedMandalId!);
                    },
                    decoratorProps: DropDownDecoratorProps(
                      decoration: InputDecoration(
                        hintText: 'Mandal',
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                      ),
                    ),

                  );
                }),
              ),

              // Village Dropdown
              CommonWidget(
                child: Obx(() {
                  if (cc.isLoading10.value) {
                    return const Center(child: CircularProgressIndicator());
                  }


                  return DropdownSearch<String>(
                    selectedItem: selectedVillage,
                    items: (filter, infiniteScrollProps) {
                      if (cc.villageData.isEmpty) {
                        return ['No List'];
                      } else {
                        return cc.villageData.map((village) => "${village['village_name']}").toList();
                      }
                    },
                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                      fit: FlexFit.loose,
                      constraints: const BoxConstraints(maxHeight: 300),
                      searchFieldProps: TextFieldProps(
                        decoration: InputDecoration(
                          hintText: 'Search Village...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        ),
                      ),

                    ),
                    onChanged: (val) {
                      setState(() {
                        selectedVillage = val;
                      });
                    },
                    decoratorProps: DropDownDecoratorProps(
                      decoration: InputDecoration(
                        hintText: 'Village',
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                      ),
                    ),

                  );
                }),
              ),
              SizedBox(height: 25,),
              // Save Button
              Container(
                height: 90,
                child: Center(
                  child: CustomButton(
                    height: 53,
                    title: 'Save',
                    buttonText: const Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    backgroundColor: AppColors.primary,
                    borderRadius: 15,
                    onPressed: () {
                      Navigator.pop(context, {
                        "district": selectedDistrict,
                        "districtId": selectedDistrictId,
                        "mandal": selectedMandal,
                        "mandalId": selectedMandalId,
                        "village": selectedVillage,
                        "villageId": selectedVillageId,

                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}