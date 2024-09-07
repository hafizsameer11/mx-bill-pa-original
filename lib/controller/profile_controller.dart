import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:bill_payment/controller/auth_controller.dart';
import 'package:bill_payment/controller/language_controller.dart';
import 'package:bill_payment/controller/response_helper.dart';
import 'package:bill_payment/models/user_model.dart';
import 'package:bill_payment/screens/auth/signin_screen.dart';
import 'package:bill_payment/utils/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:bill_payment/utils/app_constants.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  // profile info
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  // password
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final box = GetStorage();
  // dashboard data
  BillRecord? dashboardData;
  dynamic monthLabels;
  dynamic yearCompleteBills;
  dynamic maximumHeight = 0;

  UserModel? userData;
  bool isLoading = true;
  String errorMessage = '';

  String? selectedLanguage;
  int? selectedLanguageIndex;

  late LanguageController languageController;
  late AuthController authController;
  @override
  void onInit() {
    super.onInit();
    authController = Get.put(AuthController());
  }

  // fetching user info
  Future fetchUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString(AppConstants.token);
    isLoading = true;
    update();

    try {
      String apiUrl = '${AppConstants.baseUri}${AppConstants.profileUri}';
      Uri uri = Uri.parse(apiUrl);
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $authToken', // Assuming it's a Bearer token
        },
      );

      await authController.fetchUserData();
      checkVerificationStatus();

      final Map<String, dynamic> data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (data["status"] == "failed") {
          return data["message"];
        }
        userData = UserModel.fromJson(data['message']);
        final dynamic langIdx = data['message']['userLanguageId'];
        selectedLanguageIndex = int.parse(langIdx.toString());
        selectedLanguage = userData?.languages
            .firstWhere((language) => language.id == selectedLanguageIndex)
            .name;
        errorMessage = '';
      } else if (response.statusCode == 401) {
        Get.offAllNamed(SignInScreen.routeName);
      } else {
        if (kDebugMode) {
          print("Error fetching user info");
        }
        throw Exception('Result Not Found!');
      }
    } catch (e) {
      errorMessage = 'Result Not Found!';
      if (kDebugMode) {
        print("Error fetching user info: $e");
      }
    } finally {
      isLoading = false;
      update();
    }
  }

  // upload profile image
  Future<void> profileImageUpload(File file) async {
    final prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString(AppConstants.token);
    isLoading = true;
    update();

    try {
      String apiUrl =
          '${AppConstants.baseUri}${AppConstants.profileImageUploadUri}';
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(apiUrl),
      );

      // Attach the file to the request
      request.files.add(
        http.MultipartFile(
          'profile_picture',
          http.ByteStream(file.openRead()),
          await file.length(),
          filename: 'profile.jpg',
        ),
      );

      // Add other parameters if needed
      // request.fields['key'] = 'value';

      request.headers['Authorization'] = 'Bearer $authToken';
      var response = await request.send();

      if (response.statusCode == 200) {
        Get.snackbar(
          colorText: CustomColors.getTextColor(),
          'Success',
          'Image uploaded successfully',
          duration: const Duration(seconds: 2),
          backgroundColor: CustomColors.getContainerColor(),
        );
        fetchUserInfo();
        update();
      } else if (response.statusCode == 401) {
        Get.offAllNamed(SignInScreen.routeName);
      } else {
        Get.snackbar(
          colorText: CustomColors.getTextColor(),
          'Failed',
          'Failed to upload image',
          duration: const Duration(seconds: 2),
          backgroundColor: CustomColors.getContainerColor(),
        );
        if (kDebugMode) {
          print('Failed to upload file. Status code: ${response.statusCode}');
        }
        update();
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error: $error');
      }
    } finally {
      isLoading = false;
    }
  }

  // update profile information
  Future<void> postPersonalInfo() async {
    final prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString(AppConstants.token);
    isLoading = true;
    update();

    // Replace the Map below with your request data
    final Map<String, dynamic> postData = {
      'name': nameController.text,
      'city': cityController.text,
      'username': usernameController.text,
      'email': emailController.text,
      'language': selectedLanguageIndex,
      'address': addressController.text,
      'phone': "+880", // this field will be phone number
      'phone_code': phoneController.text,
    };
    try {
      String apiUrl =
          '${AppConstants.baseUri}${AppConstants.profileInfoUpdateUri}';
      Uri uri = Uri.parse(apiUrl);
      final response = await http.post(
        uri,
        body: jsonEncode(postData),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken', // Assuming it's a Bearer token
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        String status = data['status'];
        String message = data['message'];
        Get.snackbar(
          colorText: CustomColors.getTextColor(),
          status,
          message,
          duration: const Duration(seconds: 2),
          backgroundColor: CustomColors.getContainerColor(),
        );
        if (kDebugMode) {
          print('Response: $data');
        }

        // store language index
        final box = GetStorage();
        box.write('languageIndex', selectedLanguageIndex);

        // reinitialize language
        languageController = await Get.put(LanguageController());
        await languageController.fetchLanguageData(selectedLanguageIndex!);
        fetchUserInfo();

        update();
      } else if (response.statusCode == 401) {
        Get.offAllNamed(SignInScreen.routeName);
      } else {
        Get.snackbar(
          colorText: CustomColors.getTextColor(),
          'Failed',
          'Cannot Update Successfully',
          duration: const Duration(seconds: 2),
          backgroundColor: CustomColors.getContainerColor(),
        );
        if (kDebugMode) {
          print('Failed to post data. Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
        update();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error posting data: $e');
      }
    } finally {
      isLoading = false;
    }
  }

  // change password
  Future<void> changePassword() async {
    final prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString(AppConstants.token);
    isLoading = true;
    update();

    // Replace the Map below with your request data
    final Map<String, dynamic> postData = {
      'currentPassword': currentPasswordController.text,
      'password': newPasswordController.text,
      'password_confirmation': confirmPasswordController.text,
    };
    try {
      String apiUrl =
          '${AppConstants.baseUri}${AppConstants.profilePassUpdateUri}';
      Uri uri = Uri.parse(apiUrl);
      final response = await http.post(
        uri,
        body: jsonEncode(postData),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken', // Assuming it's a Bearer token
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        String status = data['status'];
        String message = data['message'];
        Get.snackbar(
          colorText: CustomColors.getTextColor(),
          status,
          message,
          duration: const Duration(seconds: 2),
          backgroundColor: CustomColors.getContainerColor(),
        );
        currentPasswordController.text = "";
        newPasswordController.text = "";
        confirmPasswordController.text = "";
        update();
      } else if (response.statusCode == 401) {
        Get.offAllNamed(SignInScreen.routeName);
      } else {
        Get.snackbar(
          colorText: CustomColors.getTextColor(),
          'Failed',
          'Failed to change password',
          duration: const Duration(seconds: 2),
          backgroundColor: CustomColors.getContainerColor(),
        );
        if (kDebugMode) {
          print('Failed to post data. Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
        update();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error posting data: $e');
      }
    } finally {
      isLoading = false;
    }
  }

  // fetching dashboard data
  Future<void> fetchDashboardData() async {
    final prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString(AppConstants.token);
    isLoading = true;
    update();

    try {
      String apiUrl = '${AppConstants.baseUri}${AppConstants.dashboardUri}';
      Uri uri = Uri.parse(apiUrl);
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $authToken', // Assuming it's a Bearer token
        },
      );

      // checkVerificationStatus();

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        // dashboardData = data['message']['billRecord'];
        log(data.toString());
        dashboardData = BillRecord.fromJson(data['message']['billRecord']);
        monthLabels = data['message']['chart']['monthLabels'];
        yearCompleteBills = data['message']['chart']['yearCompleteBills'];

        maximumHeight = yearCompleteBills
            .reduce((value, element) => value > element ? value : element);

        errorMessage = '';
      } else if (response.statusCode == 401) {
        Get.offAllNamed(SignInScreen.routeName);
      } else {
        if (kDebugMode) {
          print("Error fetching dashboard data");
        }
        throw Exception('Result Not Found!');
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching dashboard data: $e");
      }
      errorMessage = 'Result Not Found!';
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> deleteAccount() async {
    final prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString(AppConstants.token);
    isLoading = true;

    try {
      String apiUrl = '${AppConstants.baseUri}${AppConstants.deleteaccountUri}';
      Uri uri = Uri.parse(apiUrl);
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $authToken', // Assuming it's a Bearer token
        },
      );
      log(response.body);
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        await prefs.clear();
        Get.offAllNamed(SignInScreen.routeName); // move to home screen
      } else {
        throw response.reasonPhrase ?? "Unknown Error Occured";
      }
    } on http.ClientException catch (e) {
      throw e.message;
    } catch (e) {
      Get.snackbar(
        colorText: CustomColors.getTextColor(),
        'Failed',
        e.toString(),
        duration: const Duration(seconds: 2),
        backgroundColor: CustomColors.getContainerColor(),
      );
    }
  }
}
