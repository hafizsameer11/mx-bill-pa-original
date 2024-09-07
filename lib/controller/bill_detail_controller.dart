import 'dart:convert';
import 'package:bill_payment/controller/response_helper.dart';
import 'package:bill_payment/models/bill_detail_model.dart';
import 'package:bill_payment/screens/auth/signin_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:bill_payment/utils/app_constants.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BillDetailController extends GetxController {
  BillDetail? billData;
  Customer? customers;
  bool isLoading = true;
  bool isError = false;
  String errorMessage = '';
  final box = GetStorage();

  Future<void> fetchData(dynamic id) async {
    final prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString(AppConstants.token);
    isLoading = true;
    update();

    try {
      String apiUrl = '${AppConstants.baseUri}${AppConstants.billDetailUri}$id';
      Uri uri = Uri.parse(apiUrl);
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $authToken', // Assuming it's a Bearer token
        },
      );

      checkVerificationStatus();

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        billData = BillDetail.fromJson(data['message']);
        customers = Customer.fromJson(data['message']['customers']);
        errorMessage = '';
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
    }
  }
}
