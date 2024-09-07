import 'dart:convert';
import 'dart:developer';
import 'package:bill_payment/controller/payment_controller.dart';
import 'package:bill_payment/controller/response_helper.dart';
import 'package:bill_payment/models/payment_method.dart';
import 'package:bill_payment/screens/auth/signin_screen.dart';
import 'package:bill_payment/screens/fund/add_fund_screen.dart';
import 'package:bill_payment/screens/fund/fund_request_screen.dart';
import 'package:bill_payment/utils/app_colors.dart';
import 'package:bill_payment/utils/app_constants.dart';
import 'package:bill_payment/widgets/custom_alert_dialog.dart';
import 'package:bill_payment/widgets/web_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddFundController extends GetxController {
  final box = GetStorage();

  Map<String, TextEditingController> textControllers = {};
  Map<String, TextEditingController> manualPaymentParameters = {};
  final TextEditingController amountController = TextEditingController();

  Gateway? selectedGateway;
  double? serviceCharge;

  // card info
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';

  // payment preview
  List<Gateway> filteredGateways = [];
  // BillPreview? paymentPreview;
  List<Gateway> gateways = [];
  dynamic utr;

  // getting payment controller
  late SdkPaymentHandle paymentController;

  @override
  void onInit() {
    super.onInit();
    paymentController = Get.find<SdkPaymentHandle>();
  }

  bool isLoading = false;
  bool isScreenLoading = true;
  String errorMessage = '';

  // calculate payable amount
  double? totalPayableAmount;
  void calculatePayableAmount(
      double amount, double fixedCharge, double percentageCharge) {
    var pCharge = (amount / 100) * percentageCharge;
    serviceCharge = pCharge + fixedCharge;
    totalPayableAmount = amount + fixedCharge + pCharge;
  }

  // get gateway params from selectedService
  void storeGatewayParameters() {
    if (selectedGateway != null) {
      for (var fieldName in selectedGateway!.parameters.entries) {
        manualPaymentParameters[fieldName.key] = TextEditingController();
      }
      update();
    }
  }

  // capitalizes the first letter of each word
  String capitalizeEachWord(String input) {
    List<String> words = input.split(' ');
    for (int i = 0; i < words.length; i++) {
      if (words[i].isNotEmpty) {
        words[i] = words[i][0].toUpperCase() + words[i].substring(1);
      }
    }
    return words.join(' ');
  }

  // getting payment options and bill preview data
  Future<void> fetchPaymentMethods(dynamic utr) async {
    final prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString(AppConstants.token);
    isScreenLoading = true;
    isLoading = true;
    update();

    try {
      String apiUrl =
          '${AppConstants.baseUri}${AppConstants.billPreviewUri}$utr';
      Uri uri = Uri.parse(apiUrl);
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $authToken', // Assuming it's a Bearer token
        },
      );

      checkVerificationStatus();

      if (response.statusCode == 200) {
        final List<dynamic> data =
            jsonDecode(response.body)['message']['gateways'];
        gateways.assignAll(data.map((json) => Gateway.fromJson(json)).toList());

        filteredGateways = gateways;

        // saving billPayId for sdk payment handle
        paymentController.billPayId = "-1";

        for (var gateway in gateways) {
          //Stripe
          if (gateway.name.toLowerCase() == "stripe" || gateway.id == 2) {
            paymentController.stripeSecretKey =
                gateway.parameters!['secret_key'];
            paymentController.stripePublisherKey =
                gateway.parameters!['publishable_key'];
          }

          //RazorPay
          if (gateway.name.toLowerCase() == "razorpay") {
            paymentController.keyIdRazorPay = gateway.parameters!['key_id'];
            paymentController.keySecretRazorPay =
                gateway.parameters!['key_secret'];
          }

          //Paytm
          if (gateway.name.toLowerCase() == "paytm") {
            paymentController.midPaytm = gateway.parameters!['MID'];
            paymentController.merchantKeyPaytm =
                gateway.parameters!['merchant_key'];
            paymentController.websitePaytm = gateway.parameters!['WEBSITE'];
            paymentController.industryTypePaytm =
                gateway.parameters!['INDUSTRY_TYPE_ID'];
            paymentController.channelIdPaytm =
                gateway.parameters!['CHANNEL_ID'];
            paymentController.transactionUrlPaytm =
                gateway.parameters!['transaction_url'];
            paymentController.transactionStatusUrlPaytm =
                gateway.parameters!['transaction_status_url'];
          }

          //FlutterWave
          if (gateway.name.toLowerCase() == "flutterwave") {
            paymentController.publicKeyFlutterWave =
                gateway.parameters!['public_key'];
            paymentController.secretKeyFlutterWave =
                gateway.parameters!['secret_key'];
            paymentController.encryptedKeyFlutterWave =
                gateway.parameters!['encryption_key'];
          }

          //Paypal
          if (gateway.name.toLowerCase() == "paypal") {
            paymentController.clientIdPaypal = gateway.parameters!['cleint_id'];
            paymentController.secretKeyPaypal = gateway.parameters!['secret'];
          }

          //PayStack
          if (gateway.name.toLowerCase() == "paystack") {
            paymentController.publicKeyPayStack =
                gateway.parameters!['public_key'];
            paymentController.secretKeyPayStack =
                gateway.parameters!['secret_key'];
          }

          //Monnify
          if (gateway.name.toLowerCase() == "monnify") {
            paymentController.apiKeyMonnify = gateway.parameters!['api_key'];
            paymentController.secretKeyMonnify =
                gateway.parameters!['secret_key'];
            paymentController.contactCodeMonnfiy =
                gateway.parameters!['contract_code'];
          }
        }

        errorMessage = '';
      } else if (response.statusCode == 401) {
        Get.offAllNamed(SignInScreen.routeName);
      } else {
        if (kDebugMode) {
          print('Failed to laod data. Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
        throw Exception('Failed to laod data!');
      }
    } catch (e) {
      errorMessage = 'Failed to laod data!';
      if (kDebugMode) {
        print("$e");
      }
    } finally {
      isLoading = false;
      isScreenLoading = false;
      update();
    }
  }

  // submit payment info (BANK TRANSFER / ID GREATER THAN 999)
  Future<void> submitManualPayment() async {
    final prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString(AppConstants.token);
    isLoading = true;
    update();

    try {
      String apiUrl = '${AppConstants.baseUri}${AppConstants.manualPaymentUri}';
      Map<String, String> request = {};

      // Extract text from additional controllers and add to the request data
      request['billPayId'] = "-1"; // paymentPreview!.id.toString();
      request['gatewayId'] = selectedGateway!.id.toString();
      request['amount'] = totalPayableAmount.toString();

      // Add text field values to formData
      manualPaymentParameters.forEach((fieldName, controller) {
        request[fieldName] = controller.text;
      });

      // Make the HTTP request to the API with the 'Authorization' header
      final response = await http.post(
        Uri.parse(apiUrl),
        body: json.encode(request),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer $authToken', // Add your authorization token here
        },
      );

      final Map<String, dynamic> data = jsonDecode(response.body);
      // Handle the response as needed
      if (response.statusCode == 200) {
        // ereasing text form field
        for (var controller in manualPaymentParameters.values) {
          controller.clear();
        }
        if (data['status'].toLowerCase() == "success") {
          Get.offNamed(FundRequestScreen.routeName);
          CustomAlertDialog.showAlertDialog(
              Get.overlayContext!, data['status'], data['message']);
        } else {
          Get.offNamed(AddFundScreen.routeName);
          CustomAlertDialog.showAlertDialog(
              Get.overlayContext!, data['status'], data['message']);
        }

        update();
        if (kDebugMode) {
          print('Response: $data');
        }
      } else if (response.statusCode == 401) {
        Get.offAllNamed(SignInScreen.routeName);
      } else {
        Get.snackbar(
          colorText: CustomColors.getTextColor(),
          data['status'],
          data['message'],
          duration: const Duration(seconds: 2),
          backgroundColor: CustomColors.getContainerColor(),
        );

        if (kDebugMode) {
          print(
              'Failed to submit manual payment. Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
        throw ("Failed to submit manual payment");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Failed to submit manual payment: $e");
      }
      isLoading = false;
      update();
    } finally {
      isLoading = false;
    }
  }

  // submit automatic payment info (WEBVIEW / ID LESS THAN 1000 & NOT SDK)
  Future<void> submitAutomaticPayment() async {
    final prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString(AppConstants.token);
    isLoading = true;
    update();

    try {
      String apiUrl = '${AppConstants.baseUri}${AppConstants.autoPaymentUri}';
      Map<String, String> request = {};

      // Extract text from additional controllers and add to the request data
      request['billPayId'] = "-1"; // paymentPreview!.id.toString();
      request['gatewayId'] = selectedGateway!.id.toString();
      request['amount'] = totalPayableAmount.toString();

      // Make the HTTP request to the API with the 'Authorization' header
      final response = await http.post(
        Uri.parse(apiUrl),
        body: json.encode(request),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer $authToken', // Add your authorization token here
        },
      );

      final Map<String, dynamic> data = jsonDecode(response.body);
      // Handle the response as needed
      if (response.statusCode == 200) {
        Get.toNamed(CustomWebView.routeName, arguments: data['message']['url']);

        update();
        if (kDebugMode) {
          print('Response: $data');
        }
      } else if (response.statusCode == 401) {
        Get.offAllNamed(SignInScreen.routeName);
      } else {
        Get.snackbar(
          colorText: CustomColors.getTextColor(),
          data['status'],
          data['message'],
          duration: const Duration(seconds: 2),
          backgroundColor: CustomColors.getContainerColor(),
        );

        if (kDebugMode) {
          print(
              'Failed to submit automatic payment. Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
        throw ("Failed to submit automatic payment");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Failed to submit automatic payment: $e");
      }
    } finally {
      isLoading = false;
      update();
    }
  }

  // submit card payment info (AUTHORIZE.NET, SECURIONPAY / HAVE INDIVIDUAL CARD PAYMENT SCREEN)
  Future<void> submitCardPayment() async {
    final prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString(AppConstants.token);
    isLoading = true;
    update();

    try {
      String apiUrl = '${AppConstants.baseUri}${AppConstants.cardPaymentUri}';
      Map<String, String> request = {};

      // split month and year
      List<String> parts = expiryDate.split('/');

      // Extract text from additional controllers and add to the request data
      request['billPayId'] = "-1"; // paymentPreview!.id.toString();
      request['gatewayId'] = selectedGateway!.id.toString();
      request['card_number'] = cardNumber;
      request['card_name'] = cardHolderName;
      request['expiry_month'] = parts[0];
      request['expiry_year'] = parts[1];
      request['card_cvc'] = cvvCode;
      request['amount'] = totalPayableAmount.toString();

      // Make the HTTP request to the API with the 'Authorization' header
      final response = await http.post(
        Uri.parse(apiUrl),
        body: json.encode(request),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer $authToken', // Add your authorization token here
        },
      );

      final Map<String, dynamic> data = jsonDecode(response.body);
      // Handle the response as needed
      if (response.statusCode == 200) {
        if (data['status'].toLowerCase() == "success") {
          Get.offNamed(FundRequestScreen.routeName);
          CustomAlertDialog.showAlertDialog(
              Get.overlayContext!, data['status'], data['message']);
        } else {
          Get.offNamed(AddFundScreen.routeName);
          CustomAlertDialog.showAlertDialog(
              Get.overlayContext!, data['status'], data['message']);
        }
        cardNumber = "";
        cardHolderName = "";
        expiryDate = "";
        cvvCode = "";

        if (kDebugMode) {
          print('Response: $data');
        }
      } else if (response.statusCode == 401) {
        Get.offAllNamed(SignInScreen.routeName);
      } else {
        Get.snackbar(
          colorText: CustomColors.getTextColor(),
          data['status'],
          data['message'],
          duration: const Duration(seconds: 2),
          backgroundColor: CustomColors.getContainerColor(),
        );

        if (kDebugMode) {
          print(
              'Failed to submitCardPayment. Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
        throw ("Failed to submitCardPayment");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Failed to submitCardPayment: $e");
      }
    } finally {
      isLoading = false;
      update();
    }
  }
}
