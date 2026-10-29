
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../ui/loading.dart';
import '../source/report_source.dart';

class ReportController extends GetxController {
  final ReportImpl qc = ReportImpl();
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var isLoading2 = false.obs;
  var errorMessage2 = ''.obs;
  var reportlist = {}.obs;
  var quatationdetails = {}.obs;
  var errorMessage3 = ''.obs;
  var isLoading3 = false.obs;
  var farmerId = 0.obs;
  var districtId = 0.obs;
  var district = ''.obs;
  var mandalId = 0.obs;
  var mandal = ''.obs;
  var villageId = 0.obs;
  var village = ''.obs;
  var date = ''.obs;
  RxInt districtIndex = (-1).obs;
  RxInt mandalIndex = (-1).obs;
  RxInt villageIndex = (-1).obs;
  var farmerName = ''.obs;
  RxInt farmerIndex = (-1).obs;
//warehouse
 var wareLoading = false.obs;
 var wareError = ''.obs;
  var whslist = [].obs;

//items
  var itemLoading = false.obs;
  var itemError = ''.obs;
  var sapItems = [].obs;

  var isLoading4 = false.obs;
  var errorMsg4 = ''.obs;

//pagination
  var currentPage = 1.obs;
  var isLastPage = false.obs; // Track if it's the last page
  var isLoadingMore = false.obs; // Track pagination loading state
  var searchQuery = ''.obs;
  var filteredcust = [].obs;


  @override
  Future<void> Reportlist(BuildContext context,String report,
      {bool isPagination = false}) async
  {
    print('fetching 1 api');
    try {
      if (!isPagination) {
        isLoading.value = true;
        reportlist.clear(); // Clear old data when fetching new list
        currentPage.value = 1; // Reset page on new fetch
        isLastPage.value = false; // Reset last page status
      } else {
        isLoadingMore.value = true;
      }

      final result = await qc.Reportlist(
          context, currentPage.value, searchQuery.value,report,farmerId.value,village.value,district.value,mandal.value,date.value);
      result.fold((failure) {
        isLoading.value = false;
        errorMessage.value = 'Error: ${failure.message}';
      },

              (responseData) {
            if (responseData.isNotEmpty) {
              reportlist.value = (responseData);
              filteredcust.value = (responseData['data']);

              filteredcust.refresh();
              isLoading.value = false;
              // Append new data
              currentPage.value++; // Increment page number
            } else {
              isLastPage.value = true; // No more data
              isLoading.value = false;
            }
            print(
                '***********reportlist data successfully fetched in controller');
            errorMessage.value = '';
          });

    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'An error occurred: ${e.toString()};';
    }
  }


  @override
  Future<void> warehouselist(BuildContext context, {bool isPagination = false}) async {
    print('fetching 1 api');
    try {
      if (!isPagination) {
        wareLoading.value = true;
        reportlist.clear(); // Clear old data when fetching new list
        currentPage.value = 1; // Reset page on new fetch
        isLastPage.value = false; // Reset last page status
      } else {
        isLoadingMore.value = true;
      }

      final result = await qc.warehouselist(context);
      result.fold((failure) {
        wareLoading.value = false;
        wareError.value = 'Error: ${failure.message}';
      },

              (responseData) {
            if (responseData.isNotEmpty) {
              // warehouses.value = (responseData);
              whslist.value = (responseData['data']);
              // filteredcust.refresh();
              wareLoading.value = false;
              // Append new data
              currentPage.value++; // Increment page number
            } else {
              isLastPage.value = true; // No more data
              wareLoading.value = false;
            }
            print(
                '*********** ${whslist}reportlist data successfully fetched in controller');
            wareError.value = '';
          });

    } catch (e) {
      wareLoading.value = false;
      wareError.value = 'An error occurred: ${e.toString()};';
    }
  }


  @override
  Future<void> itemslist(BuildContext context,
      {bool isPagination = false}) async
  {
    print('fetching 1 api');
    try {
      if (!isPagination) {
        itemLoading.value = true;
        reportlist.clear(); // Clear old data when fetching new list
        currentPage.value = 1; // Reset page on new fetch
        isLastPage.value = false; // Reset last page status
      } else {
        isLoadingMore.value = true;
      }

      final result = await qc.itemslist(context);
      result.fold((failure) {
        itemLoading.value = false;
        itemError.value = 'Error: ${failure.message}';
      },

              (responseData) {
            if (responseData.isNotEmpty) {
              // reportlist.value = (responseData);
              sapItems.value = (responseData['data']);
              // filteredcust.refresh();
              itemLoading.value = false;
              // Append new data
              // currentPage.value++; // Increment page number
            } else {
              isLastPage.value = true; // No more data
              itemLoading.value = false;
            }
            print(
                '***********reportlist data successfully fetched in controller');
            itemError.value = '';
          });

    } catch (e) {
      itemLoading.value = false;
      itemError.value = 'An error occurred: ${e.toString()};';
    }
  }


  Future<dynamic> inventory(context, body) async {
    try {
      LoadingOverlay.show('Processing ...');
      isLoading4.value = true;
      final result = await qc.inventory(context, body);
      var responseData;

      result.fold((failure) {
        isLoading4.value = false;
        errorMsg4.value = 'Error: ${failure.message}';
        LoadingOverlay.hide();
      },
              (result) {
                isLoading4.value = false;
            LoadingOverlay.hide();
            responseData = result;
            errorMsg4.value = '';
              });
      return responseData;
    } catch (e) {
      isLoading4.value = false;
      LoadingOverlay.hide();
      errorMsg4.value = '';

      itemError.value = 'An error occurred: ${e.toString()};';
    } finally {
      isLoading4.value = false;
      LoadingOverlay.hide();
  }
  }
}






