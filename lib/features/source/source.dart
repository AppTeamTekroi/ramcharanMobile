import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ramcharan/Login/login_controller.dart';
import 'package:http/http.dart' as http;
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import '../../../core/headerfiles.dart';
import '../../../core/error/failure.dart';
import '../../../core/error/unauth_dilogbox.dart';
import '../../core/API/URLConst.dart';
import 'package:get/get.dart';
abstract class SourceRepository {
  Future<Either<Failure, dynamic>> farmerList(BuildContext context);
  Future<Either<Failure, dynamic>> cropList(BuildContext context,);
  Future<Either<Failure, dynamic>> districtList();
  Future<Either<Failure, dynamic>> varietyList();
  Future<Either<Failure, dynamic>> mandalList(BuildContext context,int id);
  Future<Either<Failure, dynamic>> villageList(BuildContext context,int id);
  Future<Either<Failure, dynamic>> FarmerOverview(BuildContext context,int id,String type);
  Future<Either<Failure, dynamic>> farmerDetails(BuildContext context,int qd_int);
  Future<Either<Failure, dynamic>> collectionList(BuildContext context);
}

class SourceImpl implements SourceRepository {

  // int? id; // Nullable int
  //
  // Future<int?> getUserName() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   id = prefs.getInt('userId');
  //   return id;
  // }

  @override
  Future<Either<Failure, dynamic>> farmerList(context) async {
    try {
      // id = await getUserName();

      final headers = await ApiHelper.getHeaders();
      final url = Uri.parse('${URLConst.baseURL}${URLConst.Farmer_list}');
      print(url);
      final response = await http.get(
        url,
        headers: headers,
      );

        print("List fetched: ${response.body}");

      if (response.statusCode == 401) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: Text('Unauthorized access'),
      //       duration: Duration(seconds: 3),
      //       backgroundColor: Colors.red,
      //     ),
      //   );
        UnauthDilogbox(context); // Call your custom dialog here if needed.
        return Left(Failure(
          statusCode: 401,
          message: 'Unauthorized access',
        ));
      }

      if (response.statusCode == 200) {
        // print("Opportunity List fetched: ${response.body}");
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return Right(jsonResponse);
      } else {
        return Left(Failure(
          statusCode: response.statusCode,
          message: 'Failed to fetch farmer data',
        ));
      }
    } catch (e) {
      return Left(Failure(
        statusCode: 500,
        message: 'Error occurred: $e',
      ));
    }
  }

  Future<Either<Failure, dynamic>> cropList(context) async {
    try {
      // id = await getUserName();

      final headers = await ApiHelper.getHeaders();
      final url = Uri.parse('${URLConst.baseURL}${URLConst.Crop_list}');
      print(url);
      final response = await http.get(
        url,
        headers: headers,
      );

      //  print("List fetched: ${response.body}");

      if (response.statusCode == 401) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Unauthorized access'),
        //     duration: Duration(seconds: 3),
        //     backgroundColor: Colors.red,
        //   ),
        // );
        UnauthDilogbox(context); // Call your custom dialog here if needed.
        return Left(Failure(
          statusCode: 401,
          message: 'Unauthorized access',
        ));
      }

      if (response.statusCode == 200) {
        // print("Opportunity List fetched: ${response.body}");
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return Right(jsonResponse);
      } else {
        return Left(Failure(
          statusCode: response.statusCode,
          message: 'Failed to FFB collection',
        ));
      }
    } catch (e) {
      return Left(Failure(
        statusCode: 500,
        message: 'Error occurred: $e',
      ));
    }
  }

  Future<Either<Failure, dynamic>> districtList() async {
    try {
      final headers = await ApiHelper.getHeaders();
      final url = Uri.parse('${URLConst.baseURL}${URLConst.Districts}');
      print(url);
      final response = await http.get(
        url,
        headers: headers,
      );

      //  print("List fetched: ${response.body}");

      // if (response.statusCode == 401) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: Text('Unauthorized access'),
      //       duration: Duration(seconds: 3),
      //       backgroundColor: Colors.red,
      //     ),
      //   );
      //   UnauthDilogbox(); // Call your custom dialog here if needed.
      //   return Left(Failure(
      //     statusCode: 401,
      //     message: 'Unauthorized access',
      //   ));
      // }

      if (response.statusCode == 200) {
        // print("Opportunity List fetched: ${response.body}");
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return Right(jsonResponse);
      } else {
        return Left(Failure(
          statusCode: response.statusCode,
          message: 'Failed to fetch District list data',
        ));
      }
    } catch (e) {
      return Left(Failure(
        statusCode: 500,
        message: 'Error occurred: $e',
      ));
    }
  }

  Future<Either<Failure, dynamic>> varietyList() async {
    try {
      final headers = await ApiHelper.getHeaders();
      final url = Uri.parse('${URLConst.baseURL}${URLConst.Variety}');
      print(url);
      final response = await http.get(
        url,
        headers: headers,
      );

      //  print("List fetched: ${response.body}");

      // if (response.statusCode == 401) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: Text('Unauthorized access'),
      //       duration: Duration(seconds: 3),
      //       backgroundColor: Colors.red,
      //     ),
      //   );
      //   UnauthDilogbox(); // Call your custom dialog here if needed.
      //   return Left(Failure(
      //     statusCode: 401,
      //     message: 'Unauthorized access',
      //   ));
      // }

      if (response.statusCode == 200) {
        // print("Opportunity List fetched: ${response.body}");
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return Right(jsonResponse);
      } else {
        return Left(Failure(
          statusCode: response.statusCode,
          message: 'Failed to fetch Variety list data',
        ));
      }
    } catch (e) {
      return Left(Failure(
        statusCode: 500,
        message: 'Error occurred: $e',
      ));
    }
  }
  Future<Either<Failure, dynamic>> mandalList(BuildContext context,id) async {
    try {

      final headers = await ApiHelper.getHeaders();
      final url = Uri.parse('${URLConst.baseURL}${"${URLConst.Mandals}$id"}');
      print(url);
      final response = await http.get(
        url,
        headers: headers,
      );


      if (response.statusCode == 200) {
        // print("Opportunity List fetched: ${response.body}");
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return Right(jsonResponse);
      } else {
        return Left(Failure(
          statusCode: response.statusCode,
          message: 'Failed to fetch Mandals list data',
        ));
      }
    } catch (e) {
      return Left(Failure(
        statusCode: 500,
        message: 'Error occurred: $e',
      ));
    }
  }
  Future<Either<Failure, dynamic>> villageList(BuildContext context,int id) async {
    try {
      final headers = await ApiHelper.getHeaders();
      final url = Uri.parse('${URLConst.baseURL}${"${URLConst.Villages}$id"}');
      print(url);
      final response = await http.get(
        url,
        headers: headers,
      );


      if (response.statusCode == 200) {
        // print("Opportunity List fetched: ${response.body}");
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return Right(jsonResponse);
      } else {
        return Left(Failure(
          statusCode: response.statusCode,
          message: 'Failed to fetch Villages list data',
        ));
      }
    } catch (e) {
      return Left(Failure(
        statusCode: 500,
        message: 'Error occurred: $e',
      ));
    }
  }
  Future<Either<Failure, dynamic>> collectionList(BuildContext context) async {
    try {

      final headers = await ApiHelper.getHeaders();
      final url = Uri.parse('${URLConst.baseURL}${URLConst.collection}');
      print(url);
      final response = await http.get(
        url,
        headers: headers,
      );
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        // print("Opportunity List fetched: ${response.body}");
        return Right(jsonResponse);
      } else {
        return Left(Failure(
          statusCode: response.statusCode,
          message: "${jsonResponse['message']}",
        ));
      }
    } catch (e) {
      return Left(Failure(
        statusCode: 500,
        message: 'Error occurred: $e',
      ));
    }
  }

  @override
  Future<Either<Failure, dynamic>> FarmerOverview(BuildContext context,int id,String type) async {
    try {
      final headers = await ApiHelper.getHeaders();

      final url = Uri.parse("${URLConst.baseURL}${URLConst.farmerOverview}$id");
      print(url);
      final response = await http.get(
        url,
        headers: headers,
      );
      print("List fetched: ${response.body}");

      if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unauthorized access'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
        // UnauthDilogbox(context); // Call your custom dialog here if needed.
        return Left(Failure(
          statusCode: 401,
          message: 'Unauthorized access',
        ));
      }
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        print("ffb details fetched: ${response.body}");
        return Right(jsonResponse);
      } else {
        return Left(Failure(
          statusCode: response.statusCode,
          message: "${jsonResponse['message']}",
        ));
      }
    } catch (e) {
      return Left(Failure(
        statusCode: 500,
        message: 'Error occurred: $e',
      ));
    }
  }
  @override
  Future<Either<Failure, dynamic>> farmerDetails(BuildContext context,qd_int) async {
    try {
      final headers = await ApiHelper.getHeaders();

      final url = Uri.parse(URLConst.baseURL+URLConst.serviveHistory+"$qd_int");
      print(url);
      final response = await http.get(
        url,
        headers: headers,
      );
      print("List fetched: ${response.body}");

      if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unauthorized access'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
        UnauthDilogbox(context); // Call your custom dialog here if needed.
        return Left(Failure(
          statusCode: 401,
          message: 'Unauthorized access',
        ));
      }

      if (response.statusCode == 200) {
        print("Opportunity details fetched: ${response.body}");
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return Right(jsonResponse);
      } else {
        return Left(Failure(
          statusCode: response.statusCode,
          message: 'Failed to fetch farmer data',
        ));
      }
    } catch (e) {
      return Left(Failure(
        statusCode: 500,
        message: 'Error occurred: $e',
      ));
    }
  }


  @override
  Future<Either<Failure, dynamic>> postCropCollection(context, body) async {
    var isLoading = false.obs;
    print('ffbCollection Posting');
    isLoading.value = true;
    final headers = await ApiHelper.getHeaders();
    try {
      print("${URLConst.baseURL}store-newCrop");
      final response = await http.post(
        Uri.parse("${URLConst.baseURL}store-newCrop"),
        headers: headers,
        body: jsonEncode(body),
      );
      print("FFB Collection posting ${response.body}");

      final decoded = jsonDecode(response.body); // ✅ parse JSON

      if (response.statusCode == 200) {
        isLoading.value = false;
        return Right(decoded);
      } else {
        isLoading.value = false;
        return Left(Failure(
          statusCode: response.statusCode,
          message: "${decoded['message']}",
        ));
      }
    } catch (e) {
      isLoading.value = false;
      Navigator.of(Get.context!).pop(); // close loading dialog if open
      print("Exception: $e");

      return Left(Failure(
        statusCode: 500,
        message: "Something went wrong while posting data: $e",
      ));
    }
  }
  @override
  Future<Either<Failure, dynamic>> userSummary(BuildContext context) async {
    try {
      final headers = await ApiHelper.getHeaders();

      final url = Uri.parse("${URLConst.baseURL}${URLConst.userSummary}");
      print(url);
      final response = await http.get(
        url,
        headers: headers,
      );
      print("List fetched: ${response.body}");

      if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unauthorized access'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
        // UnauthDilogbox(context); // Call your custom dialog here if needed.
        return Left(Failure(
          statusCode: 401,
          message: 'Unauthorized access',
        ));
      }
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        print("ffb details fetched: ${response.body}");
        return Right(jsonResponse);
      } else {
        return Left(Failure(
          statusCode: response.statusCode,
          message: "${jsonResponse['message']}",
        ));
      }
    } catch (e) {
      return Left(Failure(
        statusCode: 500,
        message: 'Error occurred: $e',
      ));
    }
  }
  @override
  Future<Either<Failure, dynamic>> inventoryList(context) async {
    try {
      // id = await getUserName();

      final headers = await ApiHelper.getHeaders();
      final url = Uri.parse('${URLConst.baseURL}${URLConst.inventoryList}');
      print(url);
      final response = await http.get(
        url,
        headers: headers,
      );

      print("List fetched: ${response.body}");

      if (response.statusCode == 401) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //       content: Text('Unauthorized access'),
        //       duration: Duration(seconds: 3),
        //       backgroundColor: Colors.red,
        //     ),
        //   );
        UnauthDilogbox(context); // Call your custom dialog here if needed.
        return Left(Failure(
          statusCode: 401,
          message: 'Unauthorized access',
        ));
      }

      if (response.statusCode == 200) {
        // print("Opportunity List fetched: ${response.body}");
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return Right(jsonResponse);
      } else {
        return Left(Failure(
          statusCode: response.statusCode,
          message: 'Failed to fetch farmer data',
        ));
      }
    } catch (e) {
      return Left(Failure(
        statusCode: 500,
        message: 'Error occurred: $e',
      ));
    }
  }

}

