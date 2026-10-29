import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../../ui/loading.dart';
import '../../ui/widgets/pdfview.dart';
import '../customerNavBar.dart';
import '../source/source.dart';




class FarmerController extends GetxController {
  final SourceImpl qc = SourceImpl();

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var isLoading2 = false.obs;
  var errorMessage2 = ''.obs;
  var opplist = <dynamic>[].obs;
  var filteredList = <dynamic>[].obs;
  var filteredList2 = <dynamic>[].obs;
  var oppdetails = [].obs;

  var updateRequest = {}.obs;
  var errorMessage3 = ''.obs;
  var isLoading3 = false.obs;
   var searchQuery = "".obs;
  var feedbackRequest = {}.obs;
  var errorMessage4 = ''.obs;
  var isLoading4 = false.obs;


  var workLoading = false.obs;
  var feedbackLoading = false.obs;

  var feederrorMessage = ''.obs;
  var workerror = ''.obs;
  var workFlow = [].obs;
  var feedback = [].obs;
  var cropData = [].obs;
  var districtData = [].obs;
  var mandalData = [].obs;
  var villageData = [].obs;

  var isLoading5 = false.obs;
  var isLoading6 = false.obs;
  var isLoading7 = false.obs;


  var errorMessage5 = ''.obs;
  var errorMessage6 = ''.obs;
  var errorMessage7 = ''.obs;

  var errorMessage8 = ''.obs;
  var isLoading8 = false.obs;
  var varietyData = [].obs;

  var errorMessage9 = ''.obs;
  var errorMessage10 = ''.obs;

  var isLoading9 = false.obs;
  var isLoading10 = false.obs;

  var cropsData = [].obs;

  var isLoading11 = false.obs;
  var errorMessage11 = ''.obs;

  var collectionList = [].obs;

  var isLoading12 = false.obs;
  var errorMessage12 = ''.obs;
  var inventoryData = <dynamic>[].obs;

  var address_1_billing = "".obs;
  var country_billing = "".obs;
  var pincode_billing = "".obs;
  var city_billing = "".obs;
  var state_billing = "".obs;
  var billing_same_as_shipping = 0.obs;

  var totalCollection = "0.00".obs;
  var totalLoads = "0".obs;
  var activeFarmers = 0.obs;


  // void searchServicesByName(String query) {
  //   print(';hitting in controller: $query');
  //
  //   if (query.isEmpty) {
  //     filteredList.value = opplist;
  //   } else {
  //     filteredList.value = opplist.where((product) {
  //       // final serial = product['service_date']?.toString().toLowerCase() ?? '';
  //       final itemNo = product['equipment']?.toString().toLowerCase() ?? '';
  //
  //       return itemNo.contains(query.toLowerCase());
  //     }).toList();
  //   }
  //
  //   filteredList.refresh(); // Force the UI to refresh
  //   update(); // Notify GetX to update the UI
  //
  //   // Print the filtered list for debugging
  //   print('Filtered List Length: ${filteredList.length}');
  //   for (var product in filteredList) {
  //     print('Product Item No: ${product['item_no']}');
  //   }
  // }

  Future<void> farmerList(BuildContext context) async {
    print('fetching 1 api');
    try {
      isLoading.value = true;
      final result = await qc.farmerList(context);
      print(result);
      result.fold((failure) {
        isLoading.value = false;
        errorMessage.value = 'Error: ${failure.message}';
        opplist.value = [];
        filteredList.value = [];
        print(errorMessage.value);
      },
              (responseData) {
            if (responseData['data'] is List) {
              opplist.value = responseData['data'];
              filteredList.value = responseData['data'];
            }
            print(
                '***********Opportunity data successfully fetched in controller');
            errorMessage.value = '';
            isLoading.value = false;
          }
      );
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'An error occurred: ${e.toString()};';
      print(errorMessage.value);
    }
  }

  Future<void> cropList(BuildContext context) async {
    print('fetching crop api');
    try {
      isLoading9.value = true;
      final result = await qc.cropList(context);
      print(result);
      result.fold((failure) {
        isLoading9.value = false;
        errorMessage9.value = 'Error: ${failure.message}';
        cropsData.value = [];
        //filteredList.value = [];
        print(errorMessage9.value);
      },
              (responseData) {
            if (responseData['data'] is List) {
              cropsData.value = responseData['data'];
              //filteredList.value = responseData['data'];
            }
            print(
                '***********ffb data successfully fetched in controller');
            errorMessage9.value = '';
            isLoading9.value = false;
          }
      );
    } catch (e) {
      isLoading9.value = false;
      errorMessage9.value = 'An error occurred: ${e.toString()};';
      print(errorMessage9.value);
    }
  }

  Future<void> districtList(BuildContext context) async {
    print('fetching district api');
    try {
      isLoading6.value = true;
      final result = await qc.districtList();
      print(result);
      result.fold((failure) {
        isLoading6.value = false;
        errorMessage6.value = 'Error: ${failure.message}';
        districtData.value = [];
        filteredList2.value = [];
        print(errorMessage6.value);
      },
              (responseData) {
            if (responseData['villages'] is List) {
              districtData.value = responseData['villages'];
              filteredList2.value = responseData['villages'];
            }
            print(
                '***********district data successfully fetched in controller');
            errorMessage6.value = '';
            isLoading6.value = false;
          }
      );
    } catch (e) {
      isLoading6.value = false;
      errorMessage6.value = 'An error occurred: ${e.toString()};';
      print(errorMessage6.value);
    }
  }
  Future<void> varietyList(BuildContext context) async {
    print('fetching variety api');
    try {
      isLoading8.value = true;
      final result = await qc.varietyList();
      print(result);
      result.fold((failure) {
        isLoading8.value = false;
        errorMessage8.value = 'Error: ${failure.message}';
        varietyData.value = [];
        print(errorMessage8.value);
      },
              (responseData) {
            if (responseData['variety'] is List) {
              varietyData.value = responseData['variety'];
            }
            print(
                '***********variety data successfully fetched in controller');
            errorMessage8.value = '';
            isLoading8.value = false;
          }
      );
    } catch (e) {
      isLoading8.value = false;
      errorMessage8.value = 'An error occurred: ${e.toString()};';
      print(errorMessage8.value);
    }
  }


  Future<void> mandal(BuildContext context, int id) async {
    print('fetching mandal api');
    try {
      isLoading7.value = true;
      final result = await qc.mandalList(context,id);
      print(result);

      result.fold((failure) {
        isLoading7.value = false;
        errorMessage7.value = 'Error: ${failure.message}';
        mandalData.value = [];
      },
              (responseData) {
            if (responseData['villages'] is List) {
              mandalData.value = responseData['villages'];
            }
            print(
                '***********mandal data successfully fetched in controller');
            errorMessage7.value = '';
            isLoading7.value = false;
          }
      );
    } catch (e) {
      isLoading7.value = false;
      errorMessage7.value = 'An error occurred: ${e.toString()};';
    }
  }

  Future<void> village(BuildContext context, int id) async {
    print('fetching village api');
    try {
      isLoading10.value = true;
      final result = await qc.villageList(context,id);
      print(result);

      result.fold((failure) {
        isLoading10.value = false;
        errorMessage10.value = 'Error: ${failure.message}';
        villageData.value = [];
      },
              (responseData) {
            if (responseData['villages'] is List) {
              villageData.value = responseData['villages'];
            }
            print(
                '***********mandal data successfully fetched in controller');
            errorMessage10.value = '';
            isLoading10.value = false;
          }
      );
    } catch (e) {
      isLoading10.value = false;
      errorMessage10.value = 'An error occurred: ${e.toString()};';
    }
  }

  Future<void> collectionCenter(BuildContext context) async {
    print('fetching collection center api');
    try {
      isLoading11.value = true;
      final result = await qc.collectionList(context);
      print(result);

      result.fold((failure) {
        isLoading11.value = false;
        errorMessage11.value = 'Error: ${failure.message}';
        collectionList.value = [];
      },
              (responseData) {
            if (responseData['center'] is List) {
              collectionList.value = responseData['center'];
            }
            print(
                '***********mandal data successfully fetched in controller');
            errorMessage11.value = '';
            isLoading11.value = false;
          }
      );
    } catch (e) {
      isLoading11.value = false;
      errorMessage11.value = 'An error occurred: ${e.toString()};';
    }
  }



  Future<void> farmerDetails(BuildContext context, int qd_id) async {
    print('fetching qd_id api');
    try {
      isLoading2.value = true;
      final result = await qc.farmerDetails(context, qd_id);
      print(result);

      result.fold((failure) {
        isLoading2.value = false;
        errorMessage2.value = 'Error: ${failure.message}';
        oppdetails.value = [];
      },
              (responseData) {
            if (responseData['data'] is List) {
              oppdetails.value = responseData['data'];
            }
            print(
                '***********Opportunity data successfully fetched in controller');
            errorMessage2.value = '';
            isLoading2.value = false;
          }
      );
    } catch (e) {
      isLoading2.value = false;
      errorMessage2.value = 'An error occurred: ${e.toString()};';
    }
  }
  Future<void> farmerCropDetails(BuildContext context, int id, String type) async {
    print('fetching ffb api');
    try {
      isLoading5.value = true;
      final result = await qc.FarmerOverview(context,id,type);
      print(result);

      result.fold((failure) {
        isLoading5.value = false;
        errorMessage5.value = 'Error: ${failure.message}';
        cropData.value = [];
      },
              (responseData) {
            if (responseData['data'] is List) {
              cropData.value = responseData['data'];
            }
            print(
                '***********ffb data successfully fetched in controller');
            errorMessage5.value = '';
            isLoading5.value = false;
          }
      );
    } catch (e) {
      isLoading5.value = false;
      errorMessage5.value = 'An error occurred: ${e.toString()};';
    }
  }
  Future<void> UserSummary(BuildContext context) async {
    print('fetching ffb api');
    try {
      final result = await qc.userSummary(context);
      print(result);
      result.fold((failure) {
        totalCollection.value = "0";
        totalLoads.value = "0";
        activeFarmers.value = 0;
      },
              (responseData) {
            if (responseData != null) {
              final data = responseData;
              totalCollection.value = data['today_total_net_weight'].toString();
              totalLoads.value = data['today_total_loads'].toString();
              activeFarmers.value = data['today_active_farmers'];
            }
            print(
                '***********ffb data successfully fetched in controller');

          }
      );
    } catch (e) {
      print('An error occurred: ${e.toString()};');
    }
  }


  Future<void> submitCropData(BuildContext context,body) async {

    LoadingOverlay.show('Processing ...');
    print(body);
    final response = await qc.postCropCollection(context, body);

    LoadingOverlay.hide();
    response.fold(
          (failure) {
        QuickAlert.show(
          context: Get.context!,
          type: QuickAlertType.error,
          title: "Error",
          text: failure.message,
        );
      },
          (data) {
        QuickAlert.show(
            context: Get.context!,
            type: QuickAlertType.success,
            title: "Success",
            text: "FFB Data Updated successfully!",
            confirmBtnText: "Receipt",
            cancelBtnText: "Close",
            showCancelBtn: true,
            onConfirmBtnTap: () async {
              if (data["pdf"] != null && data["pdf"] != '') {
                Get.offAll(() => pdfview(
                  pdf: data["pdf"],
                ));
                // _launchURL(data["pdf"]);
              } else {
                Get.snackbar("Error", "PDF link is missing");
              }
            },
            onCancelBtnTap: () =>
                Get.offAll(() => BottomNav())
        );
       cropList(context);
        },


    );
  }
  Future<void> inventoryList(BuildContext context) async {
    print('fetching 1 api');
    try {
      isLoading12.value = true;
      final result = await qc.inventoryList(context);
      print(result);
      result.fold((failure) {
        isLoading12.value = false;
        errorMessage12.value = 'Error: ${failure.message}';
        inventoryData.value = [];
        print(errorMessage.value);
      },
              (responseData) {
            if (responseData['data'] is List) {
              inventoryData.value = responseData['data'];
            }
            print(
                '***********Opportunity data successfully fetched in controller');
            errorMessage12.value = '';
            isLoading12.value = false;
          }
      );
    } catch (e) {
      isLoading12.value = false;
      errorMessage12.value = 'An error occurred: ${e.toString()};';
      print(errorMessage12.value);
    }
  }




}