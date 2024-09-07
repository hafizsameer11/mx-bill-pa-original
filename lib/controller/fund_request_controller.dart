import 'dart:convert';
import 'package:bill_payment/controller/response_helper.dart';
import 'package:bill_payment/models/bill_request_model.dart';
import 'package:bill_payment/screens/auth/signin_screen.dart';
import 'package:bill_payment/utils/app_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FundRequestController extends GetxController {
  dynamic statusIcon;
  Color? statusColor;
  Color? statusBgColor;
  final box = GetStorage();

  final ScrollController scrollController = ScrollController();
  List<FundRequestModel> billRequestLists = [];
  int currentPage = 1;
  int lastPage = 1;
  bool isLoading = true;
  bool isError = false;

  Future<void> fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString(AppConstants.token);

    try {
      String apiUrl = '${AppConstants.baseUri}${AppConstants.fundRequestUri}?page=$currentPage';
      Uri uri = Uri.parse(apiUrl);

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $authToken',
        },
      );

      checkVerificationStatus();

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> billData = data['message']['deposits']['data'];

        billRequestLists.addAll(billData.map((json) => FundRequestModel.fromJson(json)));

        currentPage = data['message']['deposits']['current_page'];
        lastPage = data['message']['deposits']['last_page'];

        isLoading = false;
        update();
      } else if (response.statusCode == 401) {
        Get.offAllNamed(SignInScreen.routeName);
      } else {
        isLoading = false;
        isError = true;
        update();
        if (kDebugMode) {
          print('Failed to load data. Status Code: ${response.statusCode}');
        }
        throw Exception('Failed to load data. Status Code: ${response.statusCode}');
      }
    } catch (error) {
      isLoading = false;
      isError = true;
      update();
      if (kDebugMode) {
        print('Error fetching data: $error');
      }
    } finally {
      isLoading = false;
      update();
      if (kDebugMode) {
        print('CURRENT PAGE: $currentPage \nLASTPAGE: $lastPage');
      }
    }
  }

  Future<void> loadMoreData() async {
    if (currentPage < lastPage) {
      currentPage++;
      await fetchData();
    }
  }
}
