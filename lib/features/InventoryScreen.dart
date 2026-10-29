import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:get/get.dart';
import 'package:ramcharan/Login/login_controller.dart';
import 'package:ramcharan/features/controllers/farmerController.dart';

import '../ui/Buttons/button.dart';
import '../ui/color/appColor.dart';
import '../ui/widgets/CommonWidget.dart';
import 'controllers/report_controller.dart';
import 'inventoryListing.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final ReportController rc = Get.find();
  final FarmerController farmerController = Get.find();

  final LoginController loginController = Get.find();
  String? fromwhs;
  String? towhs;
  final selectedItems = <Map<String, dynamic>>[].obs;

  @override
  void initState() {
    super.initState();
    _fetchData();
    selectedItems.clear();
  }
  //
  void _fetchData()  {
     rc.warehouselist(context);
     rc.itemslist(context);
  }

  var errorMsg = ''.obs;
  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(

          title: Text("INVENTORY TRANSFER",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 15)),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          actions: [
            InkWell(
              onTap: ()=>Get.to(()=>Inventorylisting()),
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(
                  Icons.list,
                  color: Colors.grey,
                ),
              ),
            )
          ]),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              height: 10,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(
                'From WHS ',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 14),
              ),
              CommonWidget(
                width: width * 0.7,
                child: Obx(() {
                  if (rc.wareLoading.value) {
                    return const Center(child: Text('Loading..'));
                  }

                  return DropdownSearch<String>(
                    // selectedItem: selectedMandalId != null
                    // ? "$selectedMandal"
                    //     : null,

                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                      fit: FlexFit.loose,
                      constraints: const BoxConstraints(maxHeight: 300),
                      searchFieldProps: TextFieldProps(
                        decoration: InputDecoration(
                          hintText: 'Search warehouse...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                        ),
                      ),
                    ),

                    items: (filter, infiniteScrollProps) {
                      if (rc.whslist.isEmpty) {
                        return [];
                      } else {
                        return rc.whslist
                            .map((entry) =>
                                "${entry['WarehouseName']}, ${entry['WarehouseCode']}")
                            .toList();
                      }
                    },
                    onChanged: (val) async {
                      if (val == null) return;
                      final parts = val.split(',');
                      setState(() {
                        fromwhs = parts[1];
                        // selectedMandal = parts[0];
                        // selectedMandalId = int.tryParse(parts[1]);
                        // selectedVillage = null;
                      });
                      // await cc.village(context, selectedMandalId!);
                    },
                    decoratorProps: DropDownDecoratorProps(
                      decoration: InputDecoration(
                        hintText: 'warehouse',
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 8),
                      ),
                    ),
                  );
                }),
              ),
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'To WHS   ',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
                ),
                CommonWidget(
                  width: width * 0.7,
                  child: Obx(() {
                    if (rc.wareLoading.value) {
                      return const Center(child: Text('Loading..'));
                    }

                    return DropdownSearch<String>(
                      // selectedItem: selectedMandalId != null
                      // ? "$selectedMandal"
                      //     : null,

                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                        fit: FlexFit.loose,
                        constraints: const BoxConstraints(maxHeight: 300),
                        searchFieldProps: TextFieldProps(
                          decoration: InputDecoration(
                            hintText: 'Search warehouse...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                          ),
                        ),
                      ),

                      items: (filter, infiniteScrollProps) {
                        if (rc.whslist.isEmpty) {
                          return [];
                        } else {
                          return rc.whslist
                              .map((entry) =>
                                  "${entry['WarehouseName']}, ${entry['WarehouseCode']}")
                              .toList();
                        }
                      },
                      //,${mandal['mandal_id']}
                      onChanged: (val) async {
                        if (val == null) return;
                        final parts = val.split(',');
                        setState(() {
                          towhs = parts[1];

                          // selectedMandal = parts[0];
                          // selectedMandalId = int.tryParse(parts[1]);
                          // selectedVillage = null;
                        });
                        // await cc.village(context, selectedMandalId!);
                      },
                      decoratorProps: DropDownDecoratorProps(
                        decoration: InputDecoration(
                          hintText: 'warehouse',
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 8),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'ITEMS   ',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
                ),
                Text(
                  '(checkBox for item multi select)   ',
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                      fontSize: 11),
                ),
              ],
            ),
            CommonWidget(
              child: Obx(() {
                if (rc.itemLoading.value) {
                  return const Center(child: Text('Loading..'));
                }

                final items = rc.sapItems
                    .map((entry) =>
                        "${entry['ItemName']} - ${entry['ItemCode']}")
                    .toList();

                return DropdownSearch<String>.multiSelection(
                  items: (filter, infiniteScrollProps) {
                    return items;
                  },
                  popupProps: PopupPropsMultiSelection.menu(
                    showSearchBox: true,
                    fit: FlexFit.loose,
                    constraints: const BoxConstraints(maxHeight: 300),
                    searchFieldProps: TextFieldProps(
                      decoration: InputDecoration(
                        hintText: 'Search items...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                      ),
                    ),
                  ),
                  decoratorProps: DropDownDecoratorProps(
                    decoration: InputDecoration(
                      hintText: 'select items',
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 8),
                    ),
                  ),
                  onChanged: (List<String> selectedValues) {
                    final updatedList = selectedValues.map((value) {
                      final parts = value.split('-');
                      final name = parts.first.trim();
                      final code =
                          parts.length > 1 ? parts.last.trim() : value.trim();
                      final existingItem = selectedItems.firstWhereOrNull(
                        (item) => item["ItemCode"] == code,
                      );
                      return {
                        "ItemName": name,
                        "ItemCode": code,
                        "Quantity": existingItem?["Quantity"] ?? "",
                      };
                    }).toList();

                    selectedItems.value = updatedList;
                  },
                );
              }),
            ),
            const SizedBox(height: 10),
            Obx(() {
              if (selectedItems.isEmpty) return const SizedBox.shrink();

              return Column(children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: selectedItems.length,
                      itemBuilder: (context, index) {
                        final item = selectedItems[index];

                        final quantityControllers =
                            TextEditingController(text: item["Quantity"] ?? "");

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${item["ItemName"]} (${item["ItemCode"]})",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 14),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: quantityControllers,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'Enter quantity',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                              ),
                              onChanged: (val) {
                                selectedItems[index]["Quantity"] = val;
                                // selectedItems.refresh(); // refresh UI
                              },
                            ),
                          ],
                        );
                      }),
                ),
              ]);
            }),
          ]),
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        decoration: const BoxDecoration(color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() =>  Text(errorMsg.value,style: TextStyle(color: Colors.red),)),
              ButtonBS(
                onPressed: () async {
                  print(selectedItems);
                  errorMsg.value = '';
                  if(fromwhs == null || towhs == null){
                    errorMsg.value = 'Warehouse Selection';
                    return;
                  }

                  if(selectedItems.isEmpty){
                    errorMsg.value = 'ADD Items for IT';
                    return;
                  }

                  List<Map<String, dynamic>> selectedItemsList = [];
                  selectedItemsList.clear(); // make sure list starts clean

                  for (var element in selectedItems) {
                    if(element['Quantity'] == '' || element['Quantity'] == '0' ){
                      errorMsg.value = 'Quantity Error';
                      selectedItemsList.clear();
                      return;
                    }
                    selectedItemsList.add({
                      "ItemCode": element['ItemCode'],
                      "Quantity": element['Quantity'],
                      "FromWarehouseCode": fromwhs,
                      "WarehouseCode": towhs,
                    });
                  };

                  final body = {
                    "field_officer" : loginController.userId,
                    "FromWarehouse": fromwhs,
                    "ToWarehouse": towhs,
                    "StockTransferLines": selectedItemsList
                  };
                   print(body);
                  final  result = await rc.inventory(context, body);
                  print('Response: $result');

                  if (result['success'] == true) {
                    // Cast message as a map
                    final message = result['message'].toString();
                    farmerController.inventoryList(context);
                    // print(docEntry);
                    Get.back();
                     _showSuccess(context,message );
                  } else {
                    _showSuccess(context,result['message']?.toString() ?? 'Something went wrong', );
                  }
                },
                title: 'POST IT',
                textColor: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
                width: width * 0.4,
                height: height * 0.04,
                // width: width * 0.39,
                // height: height * 0.04,
                padding: 5.0,
                backgroundColor: AppColors.primary,
                borderRadius: 7,
                // child: Text('Submit Request',style: TextStyle(color: Colors.red),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


