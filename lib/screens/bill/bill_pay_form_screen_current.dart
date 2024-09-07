import 'package:bill_payment/controller/bill_category_controller.dart';
import 'package:bill_payment/controller/language_controller.dart';
import 'package:bill_payment/utils/app_colors.dart';
import 'package:bill_payment/utils/billerInfomation.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';

class BillPayFormScreenCurrent extends StatefulWidget {
  // static const String routeName = "/powerPayFormScreen";
  const BillPayFormScreenCurrent({super.key});

  @override
  State<BillPayFormScreenCurrent> createState() =>
      _BillPayFormScreenCurrentState();
}

class _BillPayFormScreenCurrentState extends State<BillPayFormScreenCurrent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _searchCountryController =
      TextEditingController();
  final TextEditingController _searchServiceController =
      TextEditingController();
  final TextEditingController _searchServiceProviderController =
      TextEditingController();
  // final TextEditingController _searchAmountController = TextEditingController();

  final controller = Get.put(BillPayController());
  var key = Get.arguments as String;

  // language
  final languageController = Get.put(LanguageController());
  Map<String, dynamic> languageData = {};

  String convertCamelCaseToSentence(String input) {
    return input.split('_').map((word) => word.capitalize).join(' ');
  }

  // =========================== t-start ===========================

  String tselectedCountry = '';
  String tselectedServiceProvider = '';
  String tselectedService = '';
  // =========================== t-end ===========================

  String cable = 'cables';

  @override
  void initState() {
    super.initState();
    if (key == cable) {}
    initializeData();
    languageData = languageController.getStoredData();
  }

  initializeData() async {
    await controller.fetchBillForm(key);
    // setState(() {
    //   if (controller.tcountries.isNotEmpty) {
    //     tselectedCountry = controller.tcountries[0];
    //     controller.tfilterServiceProvider(tselectedCountry);
    //     if (controller.tserviceProviders.isNotEmpty) {
    //       tselectedServiceProvider = controller.tserviceProviders[0].code;
    //       controller.tfilterSelecableServicesByServiceProvider(
    //           tselectedServiceProvider);
    //       // if (controller.tselectableServices.isNotEmpty) {
    //       //   tselectedService = controller.tselectableServices[0].type;
    //       // }
    //     }
    //   }
    // });
  }

  @override
  void dispose() {
    Get.delete<BillPayController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BillPayController>(builder: (controller) {
      return Scaffold(
        backgroundColor: CustomColors.getBodyColor(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    child: Image.asset(
                      "assets/background.png",
                      fit: BoxFit.cover,
                      height: 200,
                      width: double.infinity,
                    ),
                  ),
                  Positioned(
                    child: Container(
                      margin: EdgeInsets.only(top: 60.h),
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                hoverColor: CustomColors.primaryColor,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  CupertinoIcons.back,
                                  color: Colors.white,
                                  size: 28.sp,
                                ),
                              ),
                              Text(
                                languageData["Pay Bill"] ?? "Pay Bill",
                                style: GoogleFonts.jost(
                                  color: Colors.white,
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              IconButton(
                                hoverColor: CustomColors.primaryColor,
                                onPressed: () {},
                                icon: Icon(
                                  CupertinoIcons.bell,
                                  color: Colors.white,
                                  size: 0.sp,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          Container(
                            padding: EdgeInsets.all(20.w),
                            decoration: BoxDecoration(
                              color: CustomColors.getContainerColor(),
                              borderRadius: BorderRadius.circular(16.w),
                              boxShadow: [
                                BoxShadow(
                                  color: CustomColors.getShadowColor(),
                                  blurRadius: 4,
                                  spreadRadius: 0,
                                  offset: const Offset(0, 2),
                                )
                              ],
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  DropdownButtonFormField2<String>(
                                    isExpanded: true,
                                    decoration: inputDecoration(
                                        labelText:
                                            languageData["Select Country"] ??
                                                "Select Country"),
                                    items: controller.tcountries
                                        .map((item) => DropdownMenuItem<String>(
                                              value: item,
                                              child: Text(
                                                item,
                                                style: GoogleFonts.jost(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: CustomColors
                                                        .getTextColor()),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ))
                                        .toList(),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return languageData[
                                                'Please select country.'] ??
                                            'Please select country.';
                                      }
                                      return null;
                                    },
                                    value: tselectedCountry.isEmpty
                                        ? null
                                        : tselectedCountry,
                                    onChanged: (value) {
                                      setState(() {
                                        tselectedCountry = value!;
                                        controller.tfilterServiceProvider(
                                            tselectedCountry);
                                        controller
                                            .tfilterSelecableServicesByServiceProvider(
                                                tselectedServiceProvider);
                                        controller.selectedService = null;
                                        tselectedServiceProvider = '';
                                        tselectedService = '';
                                      });
                                    },
                                    buttonStyleData: buttonStyleData(),
                                    iconStyleData: iconStyleData(
                                        CupertinoIcons.chevron_down),
                                    dropdownStyleData: dropDownStyleData(),
                                    menuItemStyleData: menuItemStyleData(),
                                    dropdownSearchData: dropDownSearchData(
                                      textEditingController:
                                          _searchCountryController,
                                      hintText:
                                          languageData["Search for country"] ??
                                              "Search for country",
                                    ),
                                    onMenuStateChange: (isOpen) {
                                      if (!isOpen) {
                                        _searchCountryController.clear();
                                      }
                                    },
                                  ),
                                  SizedBox(height: 16.h),
                                  DropdownButtonFormField2<String>(
                                    isExpanded: true,
                                    decoration: inputDecoration(
                                        labelText: languageData[
                                                "Select Service Provider"] ??
                                            "Select Service Provider"),
                                    items: controller.tserviceProviders
                                        .map((item) => DropdownMenuItem<String>(
                                            value: getBillerNameFromCode(
                                                    item.code)!
                                                .name,
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                    radius: 20,
                                                    backgroundImage: Svg(
                                                        getBillerNameFromCode(
                                                                item.code)!
                                                            .path)),
                                                SizedBox(width: 10),
                                                Expanded(
                                                  child: Text(
                                                    getBillerNameFromCode(
                                                            item.code)!
                                                        .name,
                                                    style: GoogleFonts.jost(
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: CustomColors
                                                            .getTextColor()),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            )))
                                        .toList(),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return languageData[
                                                'Please Select Service Provider'] ??
                                            'Please Select Service Provider';
                                      }
                                      return null;
                                    },
                                    value: tselectedServiceProvider.isEmpty
                                        ? null
                                        : tselectedServiceProvider,
                                    onChanged: (value) {
                                      setState(() {
                                        tselectedServiceProvider = value!;
                                        controller
                                            .tfilterSelecableServicesByServiceProvider(
                                                getBillerCodeFromName(value)!);
                                        tselectedService = '';
                                        // if (controller
                                        //     .tselectableServices.isNotEmpty) {
                                        //   tselectedService = controller
                                        //       .tselectableServices[0].type;
                                        // } else {
                                        // }
                                      });
                                    },
                                    buttonStyleData: buttonStyleData(),
                                    iconStyleData: iconStyleData(
                                        CupertinoIcons.chevron_down),
                                    dropdownStyleData: dropDownStyleData(),
                                    menuItemStyleData: menuItemStyleData(),
                                    dropdownSearchData: dropDownSearchData(
                                        textEditingController:
                                            _searchServiceProviderController,
                                        hintText: languageData[
                                                "Search for Service Provider"] ??
                                            "Search for Service Provider"),
                                    onMenuStateChange: (isOpen) {
                                      if (!isOpen) {
                                        _searchServiceProviderController
                                            .clear();
                                      }
                                    },
                                  ),
                                  SizedBox(height: 16.h),
                                  DropdownButtonFormField2<String>(
                                    isExpanded: true,
                                    decoration: inputDecoration(
                                        labelText:
                                            languageData["Select Service"] ??
                                                "Select Service"),
                                    items: controller.tselectableServices
                                        .map((item) => DropdownMenuItem<String>(
                                              value: item.type.toString(),
                                              child: Text(
                                                item.type,
                                                style: GoogleFonts.jost(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: CustomColors
                                                        .getTextColor()),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ))
                                        .toList(),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return languageData[
                                                'Please select service'] ??
                                            'Please select service';
                                      }
                                      return null;
                                    },
                                    value: tselectedService.isEmpty
                                        ? null
                                        : tselectedService,
                                    onChanged: (value) {
                                      setState(() {
                                        tselectedService = value!;
                                        controller.tfindServiceById(value);
                                        controller.fetchExtraResponse();
                                      });
                                    },
                                    buttonStyleData: buttonStyleData(),
                                    iconStyleData: iconStyleData(
                                        CupertinoIcons.chevron_down),
                                    dropdownStyleData: dropDownStyleData(),
                                    menuItemStyleData: menuItemStyleData(),
                                    dropdownSearchData: dropDownSearchData(
                                        textEditingController:
                                            _searchServiceController,
                                        hintText: languageData[
                                                "Search for Service"] ??
                                            "Search for Service"),
                                    onMenuStateChange: (isOpen) {
                                      if (!isOpen) {
                                        _searchServiceController.clear();
                                      }
                                    },
                                  ),
                                  for (var item in controller.labelList)
                                    buildFormField(item),
                                  controller.selectedService != null
                                      ? Container(
                                          child: controller.selectedService!
                                                          .amount
                                                          .toString() ==
                                                      "0" ||
                                                  controller.selectedService!
                                                          .amount ==
                                                      0
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    TextFormField(
                                                      controller: controller
                                                          .amountController,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return languageData[
                                                                  'Please enter amount'] ??
                                                              'Please enter amount';
                                                        }
                                                        return null;
                                                      },
                                                      style:
                                                          GoogleFonts.getFont(
                                                        'Jost',
                                                        textStyle: TextStyle(
                                                          fontSize: 16.sp,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      decoration:
                                                          InputDecoration(
                                                        labelText: languageData[
                                                                "Enter Amount"] ??
                                                            "Enter Amount",
                                                        labelStyle:
                                                            GoogleFonts.jost(
                                                          color: CustomColors
                                                              .getTextColor(),
                                                        ),
                                                        contentPadding:
                                                            EdgeInsets.all(
                                                                14.w),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.w),
                                                          borderSide:
                                                              BorderSide.none,
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.w),
                                                          borderSide:
                                                              BorderSide(
                                                            color: CustomColors
                                                                .primaryColor,
                                                            width: 1.w,
                                                          ),
                                                        ),
                                                        errorStyle: GoogleFonts.jost(
                                                            color: CustomColors
                                                                .secondaryColor),
                                                        filled: true,
                                                        fillColor: CustomColors
                                                            .getInputColor(),
                                                      ),
                                                    ),
                                                    SizedBox(height: 5.h),
                                                    Text(
                                                      "You can pay min ${controller.selectedService!.minAmount} ${controller.selectedService!.currency} and max ${controller.selectedService!.maxAmount} ${controller.selectedService!.currency}",
                                                      style: GoogleFonts.jost(
                                                        fontSize: 12.sp,
                                                        color: CustomColors
                                                            .infoColor,
                                                      ),
                                                    )
                                                  ],
                                                )
                                              : TextFormField(
                                                  controller: controller
                                                      .amountController,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  readOnly: true,
                                                  style: GoogleFonts.getFont(
                                                    'Jost',
                                                    textStyle: TextStyle(
                                                      fontSize: 16.sp,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  decoration: InputDecoration(
                                                    labelStyle:
                                                        GoogleFonts.jost(
                                                      color: CustomColors
                                                          .getTextColor(),
                                                    ),
                                                    contentPadding:
                                                        EdgeInsets.all(14.w),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.w),
                                                      borderSide:
                                                          BorderSide.none,
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.w),
                                                      borderSide: BorderSide(
                                                        color: CustomColors
                                                            .primaryColor,
                                                        width: 1.w,
                                                      ),
                                                    ),
                                                    suffixText: controller
                                                        .selectedService!
                                                        .currency,
                                                    suffixStyle: TextStyle(
                                                        color: Colors.white),
                                                    errorStyle: GoogleFonts.jost(
                                                        color: CustomColors
                                                            .secondaryColor),
                                                    filled: true,
                                                    fillColor: CustomColors
                                                        .getInputColor(),
                                                  ),
                                                ),
                                        )
                                      : const SizedBox(height: 0, width: 0),
                                  SizedBox(height: 16.h),
                                  InkWell(
                                    onTap: () {
                                      if (_formKey.currentState!.validate()) {
                                        controller.submitBillingInfo();
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 14.h, horizontal: 14.w),
                                      width: 300.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: CustomColors.primaryColor,
                                      ),
                                      child: !controller.isLoading
                                          ? Text(
                                              languageData["Continue"] ??
                                                  "Continue",
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.jost(
                                                color: Colors.white,
                                                fontSize: 16.sp,
                                              ),
                                            )
                                          : Center(
                                              child: SizedBox(
                                                width: 23.w,
                                                height: 23.h,
                                                child:
                                                    const CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                              Color>(
                                                          CustomColors
                                                              .whiteColor),
                                                  strokeWidth: 2.0,
                                                ),
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  MenuItemStyleData menuItemStyleData() {
    return MenuItemStyleData(
      padding: EdgeInsets.only(left: 14.w),
    );
  }

  IconStyleData iconStyleData(IconData icon) {
    return IconStyleData(
      icon: Icon(
        icon,
        color: CustomColors.getTextColor(),
      ),
      iconSize: 18,
    );
  }

  ButtonStyleData buttonStyleData() {
    return ButtonStyleData(
      padding: EdgeInsets.all(0.w),
    );
  }

  DropdownSearchData<String> dropDownSearchData(
      {required TextEditingController textEditingController,
      required String hintText}) {
    return DropdownSearchData(
      searchController: textEditingController,
      searchInnerWidgetHeight: 50,
      searchInnerWidget: Container(
        margin: EdgeInsets.only(top: 12.h, left: 12.w, right: 12.w),
        child: TextFormField(
          controller: textEditingController,
          style: GoogleFonts.getFont(
            'Jost',
            textStyle: TextStyle(
              fontSize: 16.sp,
              color: CustomColors.getTextColor(),
            ),
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.jost(
              color: CustomColors.getTextColor(),
            ),
            contentPadding: EdgeInsets.all(14.w),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.w),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.w),
              borderSide: BorderSide(
                color: CustomColors.primaryColor,
                width: 1.w,
              ),
            ),
            errorStyle: GoogleFonts.jost(color: CustomColors.secondaryColor),
            filled: true,
            fillColor: CustomColors.getInputColor(),
          ),
        ),
      ),
      searchMatchFn: (item, searchValue) {
        return item.value
            .toString()
            .toLowerCase()
            .contains(searchValue.toLowerCase());
      },
    );
  }

  DropdownStyleData dropDownStyleData() {
    return DropdownStyleData(
      maxHeight: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.w),
        color: CustomColors.getContainerColor(),
      ),
      scrollbarTheme: ScrollbarThemeData(
        radius: const Radius.circular(40),
        thickness: WidgetStateProperty.all(3),
        thumbVisibility: WidgetStateProperty.all(true),
        thumbColor: WidgetStatePropertyAll(CustomColors.getBorderColor()),
      ),
    );
  }

  InputDecoration inputDecoration({required String labelText}) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: GoogleFonts.jost(
        color: CustomColors.getTextColor(),
      ),
      contentPadding: EdgeInsets.all(14.w),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.w),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.w),
        borderSide: BorderSide(
          color: CustomColors.primaryColor,
          width: 1.w,
        ),
      ),
      errorStyle: GoogleFonts.jost(color: CustomColors.secondaryColor),
      filled: true,
      fillColor: CustomColors.getInputColor(),
    );
  }

  Widget buildFormField(dynamic fieldName) {
    TextEditingController? inputController =
        controller.textControllers[fieldName];

    bool checkForMultipleWords(String fieldName) {
      List<String> wordsToCheck = [
        "number",
        "phone",
        "telephone",
        "contact",
        "amount"
      ];
      for (String word in wordsToCheck) {
        if (fieldName.toLowerCase().contains(word)) {
          return false;
        }
      }
      return true;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 16.h, top: 16.h),
      child: TextFormField(
        controller: inputController,
        // keyboardType: fieldName.toLowerCase().contains("number") ? TextInputType.number : TextInputType.text,
        keyboardType: checkForMultipleWords(fieldName)
            ? TextInputType.text
            : TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field can not be empty';
          }
          return null;
        },
        style: GoogleFonts.getFont(
          'Jost',
          textStyle: TextStyle(
            fontSize: 16.sp,
            color: Colors.white,
          ),
        ),
        decoration: InputDecoration(
          labelText: convertCamelCaseToSentence(fieldName),
          labelStyle: GoogleFonts.jost(
            color: CustomColors.getTextColor(),
          ),
          contentPadding: EdgeInsets.all(14.w),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.w),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.w),
            borderSide: BorderSide(
              color: CustomColors.primaryColor,
              width: 1.w,
            ),
          ),
          errorStyle: GoogleFonts.jost(color: CustomColors.secondaryColor),
          filled: true,
          fillColor: CustomColors.getInputColor(),
        ),
      ),
    );
  }
}
