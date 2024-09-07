import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class TestApiController extends GetxController {
  final _SECERET_KEY = 'FLWSECK_TEST-b70a9860fbef51834a9b96981b45c16b-X';

  @override
  void onInit() {
    initialzeValue();
    super.onInit();
  }

  void initialzeValue() async {
    await fetchCategories();
  }

  /*====================== Country Codes To Name ======================*/

  final Map<String, String> _countryCodeToName = {
    'NG': 'Nigeria',
    'GH': 'Ghana',
    'US': 'United States',
    'UG': 'Uganda',
    'KE': 'Kenya',
    'ZM': 'Zambia',
  };

  /*====================== Values ======================*/

  var selectableServices = <Category>[].obs;
  var categories = <Category>[].obs;
  var countries = <String>[].obs;
  var billers = <Biller>[].obs;
  var subscriptionPlans = <SubscriptionPlan>[].obs;
  var uniqueCategories = [].obs;

  var selectedCountry = ''.obs;
  var selectedBillerCode = ''.obs;
  var amount = ''.obs;
  var selectedPlan = Category(
    id: -1,
    name: '',
    code: '',
    description: '',
    countryCode: '',
  ).obs;

  /*====================== Loading... ======================*/

  var _isLoading = false.obs;
  void _setLoading(bool value) {
    _isLoading.value = value;
  }

  bool get isLoading => _isLoading.value; // getting loading value

  /*====================== Fetching Categories ======================*/

  Future<void> fetchCategories() async {
    try {
      _setLoading(true); // setting loading to true
      final Uri uri =
          Uri.parse('https://api.flutterwave.com/v3/top-bill-categories');
      final response = await _getRequest(uri);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> data = jsonData['data'];
        categories.value = data.map((item) {
          final fetchedCategory = Category.fromJson(item);
          fetchedCategory.country =
              _countryCodeToName[fetchedCategory.countryCode] ?? 'Unknown';
          return fetchedCategory;
        }).toList();

        final Set<String> uniqueNames = {};
        final List<Category> uniqueCategories = [];

        for (var category in categories) {
          if (uniqueNames.add(category.name)) {
            uniqueCategories.add(category);
          }
        }

        // Update the categories with unique ones
        categories.value = uniqueCategories;

        // Logging unique categories
        for (var category in uniqueCategories) {
          log(category.code);
        }

        _getCoutries();
      } else {
        throw 'Something went wrong';
      }
    } catch (error) {
      print('Error fetching categories: $error');
    } finally {
      _setLoading(false);
    }
  }

  void _getCoutries() {
    final uniqueCountries =
        categories.map((category) => category.country).toSet().toList();
    countries.assignAll(uniqueCountries);
  }

  String getCountryCode(String countryName) {
    return selectedCountry.value = _countryCodeToName.entries
        .firstWhere((element) => element.value == countryName)
        .key;
  }

  /*====================== Fetch Bill Types ======================*/

  Future<void> fetchBilltypes(String countrycode, String billerCategory) async {
    // final billerCategory = 'CABLEBILLS'; // this needs to be dynamic
    final Uri uri = Uri.parse(
        "https://api.flutterwave.com/v3/bills/$billerCategory/billers?country=$countrycode");
    try {
      final response = await _getRequest(uri);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> data = jsonData['data'];
        billers.value = data.map((item) => Biller.fromJson(item)).toList();
        print(
            'Fetched ${billers.length} billers'); // Log the number of billers fetched
      } else {
        throw 'Error Fetching Billers';
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void getbillerCode(String value) {
    final selectedBiller = billers.where(
      (element) {
        return element.name.toLowerCase() == value.toLowerCase();
      },
    );
    if (selectedBiller.isNotEmpty) {
      selectedBillerCode.value = selectedBiller.first.billerCode;
      print(
          'Selected Biller Code: ${selectedBillerCode.value}'); // Log the selected biller code
    } else {
      print('No biller found with name: $value');
    }
  }

  /*====================== Fetch Subscription Plans ======================*/

  Future<void> fetchSelectedSubscriptionsPlans(String billerCode) async {
    final Uri uri =
        Uri.parse("https://api.flutterwave.com/v3/billers/$billerCode/items");
    try {
      final response = await _getRequest(uri);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> data = jsonData['data'];
        subscriptionPlans.value =
            data.map((item) => SubscriptionPlan.fromJson(item)).toList();
        print(
            'Fetched ${subscriptionPlans.length} subscription plans'); // Log the number of plans fetched
      } else {
        throw 'Error Fetching Subscription Plans';
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void getSelectedSubscriptionPlan(String value) {
    final selectedSubscriptionPlan = subscriptionPlans.where(
      (element) {
        return element.name == value;
      },
    );
    if (selectedSubscriptionPlan.isNotEmpty) {
      amount.value = (selectedSubscriptionPlan.first.fee +
              selectedSubscriptionPlan.first.amount)
          .toString();
      print(
          'Selected Subscription Plan Amount: ${amount.value}'); // Log the selected plan amount
    } else {
      print('No subscription plan found with name: $value');
    }
  }

  /*====================== Get Request Utility ======================*/
  Future<http.Response> _getRequest(Uri uri) async {
    return await http.get(
      uri,
      headers: {
        'Authorization': _SECERET_KEY,
      },
    );
  }
}

// Define the Category model
class Category {
  final int id;
  final String name;
  final String code;
  final String description;
  final String countryCode;
  late String country;

  Category({
    required this.id,
    required this.name,
    required this.code,
    required this.description,
    required this.countryCode,
  });

  // Factory method to create a Category from JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      description: json['description'],
      countryCode: json['country_code'],
    );
  }
}

class Biller {
  final int id;
  final String name;
  final String? logo;
  final String description;
  final String shortName;
  final String billerCode;
  final String countryCode;

  Biller({
    required this.id,
    required this.name,
    this.logo,
    required this.description,
    required this.shortName,
    required this.billerCode,
    required this.countryCode,
  });

  factory Biller.fromJson(Map<String, dynamic> json) {
    return Biller(
      id: json['id'],
      name: json['name'],
      logo: json['logo'],
      description: json['description'],
      shortName: json['short_name'],
      billerCode: json['biller_code'],
      countryCode: json['country_code'],
    );
  }
}

class SubscriptionPlan {
  final int id;
  final String billerCode;
  final String name;
  final double defaultCommission;
  final String dateAdded;
  final String country;
  final bool isAirtime;
  final String billerName;
  final String itemCode;
  final String shortName;
  final int fee;
  final bool commissionOnFee;
  final String regExpression;
  final String labelName;
  final int amount;
  final bool isResolvable;
  final String groupName;
  final String categoryName;
  final bool? isData;
  final double? defaultCommissionOnAmount;
  final int commissionOnFeeOrAmount;
  final String? validityPeriod;

  SubscriptionPlan({
    required this.id,
    required this.billerCode,
    required this.name,
    required this.defaultCommission,
    required this.dateAdded,
    required this.country,
    required this.isAirtime,
    required this.billerName,
    required this.itemCode,
    required this.shortName,
    required this.fee,
    required this.commissionOnFee,
    required this.regExpression,
    required this.labelName,
    required this.amount,
    required this.isResolvable,
    required this.groupName,
    required this.categoryName,
    this.isData,
    this.defaultCommissionOnAmount,
    required this.commissionOnFeeOrAmount,
    this.validityPeriod,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['id'] ?? 0,
      billerCode: json['biller_code'] ?? '',
      name: json['name'] ?? '',
      defaultCommission:
          (json['default_commission'] as num?)?.toDouble() ?? 0.0,
      dateAdded: json['date_added'] ?? '',
      country: json['country'] ?? '',
      isAirtime: json['is_airtime'] ?? false,
      billerName: json['biller_name'] ?? '',
      itemCode: json['item_code'] ?? '',
      shortName: json['short_name'] ?? '',
      fee: json['fee'] ?? 0,
      commissionOnFee: json['commission_on_fee'] ?? false,
      regExpression: json['reg_expression'] ?? '',
      labelName: json['label_name'] ?? '',
      amount: json['amount'] ?? 0,
      isResolvable: json['is_resolvable'] ?? false,
      groupName: json['group_name'] ?? '',
      categoryName: json['category_name'] ?? '',
      isData: json['is_data'],
      defaultCommissionOnAmount:
          (json['default_commission_on_amount'] as num?)?.toDouble(),
      commissionOnFeeOrAmount: json['commission_on_fee_or_amount'] ?? 0,
      validityPeriod: json['validity_period'],
    );
  }
}
