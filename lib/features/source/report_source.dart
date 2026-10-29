import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import '../../../../core/headerfiles.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/error/unauth_dilogbox.dart';
import '../../core/API/URLConst.dart';

abstract class ReportRepository {
  Future<Either<Failure, dynamic>> Reportlist(BuildContext context,int page,String searchQuery,String report,int farmerId,String village,String district,String mandal,String date);
  // Future<Either<Failure, dynamic>> Quatationdetails(BuildContext context,String qd_int,String page);
  // Future<Either<Failure, dynamic>> QuatationStore (BuildContext context, Map<String, dynamic> body,String page,File file);
  Future<Either<Failure, dynamic>> warehouselist(BuildContext context);
  Future<Either<Failure, dynamic>> itemslist(BuildContext context);

}

class ReportImpl implements ReportRepository {
  @override
  Future<Either<Failure, dynamic>> Reportlist(BuildContext context, page,
      searchQuery, report, farmerId, village, district, mandal, date) async {
    try {
      final headers = await ApiHelper.getHeaders();

      // final url = Uri.parse('${URLConst.baseURL}${URLConst
      //     .salesReport}?page=$page&search_quotation=$searchQuery');
      // final url = Uri.parse('${URLConst.baseURL}${URLConst.salesReport}?draw=1&length=20&start=0&branch_count=10&status=&search_quotation');

      var url;

      switch (report) {
        case 'FBB Report':
          url = Uri.parse('${URLConst.baseURL}${URLConst
              .salesReport}?farmerId=$farmerId&village=$village&district=$district&mandal=$mandal&date=$date&draw=1&length=20&start=0&branch_count=10&status=&search_quotation');

          break;

      // case 'Opportunity Report':
      //
      //   break;

        // case 'Consolation Report':
        //   url = Uri.parse('${URLConst.baseURL}${URLConst
        //       .consolationReport}?draw=1&length=20&start=0&branch_count=10&status=&search_quotation');
        //
        //   break;

      // case 'CT Report':
      //
      //   break;

        default:
        // Handle unexpected value
          print("Unknown report selected");
      }
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
        print("Quatation List fetched: ${response.body}");
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return Right(jsonResponse);
      } else {
        return Left(Failure(
          statusCode: response.statusCode,
          message: 'Failed to fetch Quatation list data',
        ));
      }
    } catch (e) {
      return Left(Failure(
        statusCode: 500,
        message: 'Error occurred: $e',
      ));
    }
  }

  Future<Either<Failure, dynamic>> warehouselist(BuildContext context) async {
    try {
      final headers = await ApiHelper.getHeaders();

      final url = Uri.parse('${URLConst.baseURL}${URLConst.warehouse}');
      final response = await http.get(url,
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
        print("Warehouse List fetched: ${response.body}");
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return Right(jsonResponse);
      } else {
        return Left(Failure(
          statusCode: response.statusCode,
          message: 'Failed to fetch Warehouse list data',
        ));
      }
    } catch (e) {
      return Left(Failure(
        statusCode: 500,
        message: 'Error occurred: $e',
      ));
    }
  }

  Future<Either<Failure, dynamic>> itemslist(BuildContext context) async {
    try {
      final headers = await ApiHelper.getHeaders();

      final url = Uri.parse('${URLConst.baseURL}${URLConst.items}');
      final response = await http.get(url,
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
        print("Warehouse List fetched: ${response.body}");
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return Right(jsonResponse);
      } else {
        return Left(Failure(
          statusCode: response.statusCode,
          message: 'Failed to fetch Items list data',
        ));
      }
    } catch (e) {
      return Left(Failure(
        statusCode: 500,
        message: 'Error occurred: $e',
      ));
    }
  }

  Future<Either<Failure, dynamic>> inventory(BuildContext context,
      dynamic body) async {
    try {
      final headers = await ApiHelper.getHeaders();

      final url = Uri.parse('${URLConst.baseURL}${URLConst.IT}');
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      // print("List fetched: ${response.body}");

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

      print("Warehouse List fetched: ${response.body}");

      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201 ) {
        print("Warehouse List fetched: ${response.body}");
        return Right(jsonResponse);
      } else {
        return Left(Failure(
          statusCode: response.statusCode,
          message: jsonResponse['message'],
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