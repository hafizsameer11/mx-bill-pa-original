
import 'package:bill_payment/controller/bill_category_controller.dart';
import 'package:bill_payment/controller/language_controller.dart';
import 'package:bill_payment/controller/profile_controller.dart';
import 'package:bill_payment/controller/pusher_controller.dart';
import 'package:bill_payment/controller/transaction_controller.dart';
import 'package:bill_payment/screens/bill/bill_pay_form_screen_current.dart';
import 'package:bill_payment/screens/fund/add_fund_screen.dart';
import 'package:bill_payment/screens/notification/notification_screen.dart';
import 'package:bill_payment/screens/profile/profile_setting_screen.dart';
import 'package:bill_payment/screens/transaction_screen.dart';
import 'package:bill_payment/utils/app_colors.dart';
import 'package:bill_payment/widgets/bill_statistics.dart';
import 'package:bill_payment/widgets/shimmer_preloader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/homeScreen";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final profileController = Get.put(ProfileController());
  final transactionController = Get.put(TransactionController());
  final notificationController = Get.put(PusherController());
  final billpaycontroller = Get.put(BillPayController());
  // language
  final languageController = Get.put(LanguageController());

  @override
  void initState() {
    fetchInitialData();
    super.initState();
  }

  void fetchInitialData() async {
    final userInfoResponse = await profileController.fetchUserInfo();

    if (userInfoResponse != "Email Verification Required") {
      await profileController.fetchDashboardData();
      await billpaycontroller.fetchBillingCategories();
      await transactionController.fetchData();
      await notificationController.loadNotificationVisibility();
      await notificationController.fetchPusherConfig();
      notificationController.onConnectPressed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(builder: (profileController) {
      return GetBuilder<BillPayController>(builder: (billpaycontroller) {
        return GetBuilder<TransactionController>(
            builder: (transactionController) {
          return GetBuilder<PusherController>(
              builder: (notificationController) {
            return GetBuilder<LanguageController>(
                builder: (languageController) {
              return RefreshIndicator(
                onRefresh: profileController.fetchDashboardData,
                color: CustomColors.primaryColor,
                child: Scaffold(
                  key: _scaffoldKey,
                  backgroundColor: CustomColors.getBodyColor(),
                  body: profileController.userData != null &&
                          profileController.dashboardData != null
                      ? SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20.r),
                                      bottomRight: Radius.circular(20.r),
                                    ),
                                    child: Image.asset(
                                      "assets/background.png",
                                      
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 20.h),
                                        ListTile(
                                          contentPadding: EdgeInsets.all(20.w),
                                          leading: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(16.r),
                                            child: GestureDetector(
                                              onTap: () {
                                                Get.toNamed(ProfileSettingScreen
                                                    .routeName);
                                              },
                                              child: Image.network(
                                                profileController
                                                    .userData!.userImage,
                                                width: 50,
                                                height: 50,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          trailing: Stack(
                                            children: [
                                              notificationController
                                                      .isNotificationVisible
                                                  ? Positioned(
                                                      top: 9,
                                                      right: 12,
                                                      child: Container(
                                                        width: 10.w,
                                                        height: 10.h,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: CustomColors
                                                              .whiteColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                            100.r,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                              IconButton(
                                                hoverColor:
                                                    CustomColors.primaryColor,
                                                onPressed: () async {
                                                  setState(() {
                                                    notificationController
                                                            .isNotificationVisible =
                                                        false; // Hide the notification count
                                                  });
                                                  await notificationController
                                                      .saveNotificationVisibility(
                                                          false);
                                                  Get.toNamed(NotificationScreen
                                                      .routeName);
                                                },
                                                icon: Icon(
                                                  CupertinoIcons.bell,
                                                  color:
                                                      CustomColors.whiteColor,
                                                  size: 28.sp,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20.w),
                                          child: Text(
                                            "${languageController.getStoredData()['Hello'] ?? 'Hello'} ${profileController.userData!.name}",
                                            style: TextStyle(
                                              color: CustomColors.titleColor,
                                              fontSize: 24.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10.h),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20.w),
                                          child: Text(
                                            languageController.getStoredData()[
                                                    "Welcome Back"] ??
                                                "Welcome Back",
                                            style: TextStyle(
                                              color: CustomColors.titleColor,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 20.h),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 20.w),
                                          child: profileController
                                                      .maximumHeight >
                                                  0
                                              ? Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        height: 280.h,
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 10.h),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: CustomColors
                                                              .getContainerColor(),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      16.r),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: CustomColors
                                                                  .getShadowColor(),
                                                              blurRadius: 4,
                                                              spreadRadius: 0,
                                                              offset:
                                                                  const Offset(
                                                                      0, 2),
                                                            ),
                                                          ],
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            const Expanded(
                                                              child:
                                                                  BillStatistics(),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          10.h),
                                                              child: Text(
                                                                "Completed Bills",
                                                                style:
                                                                    TextStyle(
                                                                  color: CustomColors
                                                                      .getTitleColor(),
                                                                  fontSize:
                                                                      16.sp,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 10.w),
                                                    Expanded(
                                                      child: Column(
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              // moving to add fund screen
                                                              Get.toNamed(
                                                                  AddFundScreen
                                                                      .routeName);
                                                            },
                                                            child: Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                vertical: 13.h,
                                                                horizontal:
                                                                    16.w,
                                                              ),
                                                              // height: 130.h,
                                                              width: 160.w,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            16.r),
                                                                color: CustomColors
                                                                    .getContainerColor(),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: CustomColors
                                                                        .getShadowColor(),
                                                                    blurRadius:
                                                                        4,
                                                                    spreadRadius:
                                                                        0,
                                                                    offset:
                                                                        const Offset(
                                                                            0,
                                                                            2),
                                                                  )
                                                                ],
                                                              ),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Stack(
                                                                    children: [
                                                                      Container(
                                                                        width:
                                                                            40.w,
                                                                        height:
                                                                            40.h,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              CustomColors.infoColor,
                                                                          borderRadius:
                                                                              BorderRadius.circular(10.r),
                                                                        ),
                                                                      ),
                                                                      Positioned(
                                                                        top:
                                                                            8.h,
                                                                        left:
                                                                            8.w,
                                                                        child:
                                                                            const Icon(
                                                                          CupertinoIcons
                                                                              .creditcard,
                                                                          color:
                                                                              CustomColors.whiteColor,
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          12.h),
                                                                  Text(
                                                                    languageController
                                                                            .getStoredData()["Wallet Balance"] ??
                                                                        "Wallet Balance",
                                                                    style:
                                                                        TextStyle(
                                                                      color: CustomColors
                                                                          .getTitleColor(),
                                                                      fontSize:
                                                                          16.sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                    ),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    maxLines: 1,
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          4.h),
                                                                  Text(
                                                                    "₦ ${profileController.dashboardData!.walletBalance}",
                                                                    style:
                                                                        TextStyle(
                                                                      color: CustomColors
                                                                          .getTitleColor(),
                                                                      fontSize:
                                                                          18.sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    maxLines: 1,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                              height: 16.h),
                                                          Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                              vertical: 13.h,
                                                              horizontal: 16.w,
                                                            ),
                                                            // height: 130.h,
                                                            width: 160.w,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          16.r),
                                                              color: CustomColors
                                                                  .getContainerColor(),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: CustomColors
                                                                      .getShadowColor(),
                                                                  blurRadius: 4,
                                                                  spreadRadius:
                                                                      0,
                                                                  offset:
                                                                      const Offset(
                                                                          0, 2),
                                                                )
                                                              ],
                                                            ),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Stack(
                                                                  children: [
                                                                    Container(
                                                                      width:
                                                                          40.w,
                                                                      height:
                                                                          40.h,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: CustomColors
                                                                            .secondaryColor,
                                                                        borderRadius:
                                                                            BorderRadius.circular(10.r),
                                                                      ),
                                                                    ),
                                                                    Positioned(
                                                                      top: 8.h,
                                                                      left: 8.w,
                                                                      child:
                                                                          const Icon(
                                                                        CupertinoIcons
                                                                            .refresh_thick,
                                                                        color: CustomColors
                                                                            .whiteColor,
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                    height:
                                                                        12.h),
                                                                Text(
                                                                  languageController
                                                                              .getStoredData()[
                                                                          "Pending Bills"] ??
                                                                      "Pending Bills",
                                                                  style:
                                                                      TextStyle(
                                                                    color: CustomColors
                                                                        .getTitleColor(),
                                                                    fontSize:
                                                                        16.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  maxLines: 1,
                                                                ),
                                                                SizedBox(
                                                                    height:
                                                                        4.h),
                                                                Text(
                                                                  "${profileController.dashboardData!.pendingBills}",
                                                                  style:
                                                                      TextStyle(
                                                                    color: CustomColors
                                                                        .getTitleColor(),
                                                                    fontSize:
                                                                        18.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  maxLines: 1,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                )
                                              : Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Get.toNamed(
                                                              AddFundScreen
                                                                  .routeName);
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                            vertical: 13.h,
                                                            horizontal: 16.w,
                                                          ),
                                                          // height: 130.h,
                                                          // width: 160.w,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16.r),
                                                            color: CustomColors
                                                                .getContainerColor(),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: CustomColors
                                                                    .getShadowColor(),
                                                                blurRadius: 4,
                                                                spreadRadius: 0,
                                                                offset:
                                                                    const Offset(
                                                                        0, 2),
                                                              )
                                                            ],
                                                          ),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Stack(
                                                                children: [
                                                                  Container(
                                                                    width: 40.w,
                                                                    height:
                                                                        40.h,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: CustomColors
                                                                          .infoColor,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10.r),
                                                                    ),
                                                                  ),
                                                                  Positioned(
                                                                    top: 8.h,
                                                                    left: 8.w,
                                                                    child:
                                                                        const Icon(
                                                                      CupertinoIcons
                                                                          .creditcard,
                                                                      color: CustomColors
                                                                          .whiteColor,
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                  height: 12.h),
                                                              Text(
                                                                languageController
                                                                            .getStoredData()[
                                                                        "Wallet Balance"] ??
                                                                    "Wallet Balance",
                                                                style:
                                                                    TextStyle(
                                                                  color: CustomColors
                                                                      .getTitleColor(),
                                                                  fontSize:
                                                                      16.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                ),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 1,
                                                              ),
                                                              SizedBox(
                                                                  height: 4.h),
                                                              Text(
                                                                "₦ ${profileController.dashboardData!.walletBalance}",
                                                                style:
                                                                    TextStyle(
                                                                  color: CustomColors
                                                                      .getTitleColor(),
                                                                  fontSize:
                                                                      18.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 1,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 16.h),
                                                    Expanded(
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          vertical: 13.h,
                                                          horizontal: 16.w,
                                                        ),
                                                        // height: 130.h,
                                                        width: 160.w,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      16.r),
                                                          color: CustomColors
                                                              .getContainerColor(),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: CustomColors
                                                                  .getShadowColor(),
                                                              blurRadius: 4,
                                                              spreadRadius: 0,
                                                              offset:
                                                                  const Offset(
                                                                      0, 2),
                                                            )
                                                          ],
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Stack(
                                                              children: [
                                                                Container(
                                                                  width: 40.w,
                                                                  height: 40.h,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: CustomColors
                                                                        .secondaryColor,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.r),
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                  top: 8.h,
                                                                  left: 8.w,
                                                                  child:
                                                                      const Icon(
                                                                    CupertinoIcons
                                                                        .refresh_thick,
                                                                    color: CustomColors
                                                                        .whiteColor,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            SizedBox(
                                                                height: 12.h),
                                                            Text(
                                                              languageController
                                                                          .getStoredData()[
                                                                      "Pending Bills"] ??
                                                                  "Pending Bills",
                                                              style: TextStyle(
                                                                color: CustomColors
                                                                    .getTitleColor(),
                                                                fontSize: 16.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 1,
                                                            ),
                                                            SizedBox(
                                                                height: 4.h),
                                                            Text(
                                                              "${profileController.dashboardData!.pendingBills}",
                                                              style: TextStyle(
                                                                color: CustomColors
                                                                    .getTitleColor(),
                                                                fontSize: 18.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 1,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              billpaycontroller.billingCategories != null
                                  ? GridView.builder(
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.all(20),
                                      physics: NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        mainAxisSpacing: 12.0,
                                        crossAxisSpacing: 12.0,
                                      ),
                                      itemCount: billpaycontroller
                                          .billingCategories!.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final item = billpaycontroller
                                            .billingCategories![index];
                                        return GestureDetector(
                                          onTap: () {
                                            Get.to(
                                                () =>
                                                    BillPayFormScreenCurrent(),
                                                arguments: item.key.toString());
                                            // log(item.key);
                                            // if (item.key == 'cables' ||
                                            //     item.key == 'data_bundle' ||
                                            //     item.key == 'internet' ||
                                            //     item.key == 'airtime' ||
                                            //     item.key == 'toll' ||
                                            //     item.key == 'power') {
                                            // } else {
                                            //   Get.toNamed(
                                            //       BillPayFormScreen.routeName,
                                            //       arguments:
                                            //           item.key.toString());
                                            // }
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(10.w),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16.w),
                                              color: CustomColors
                                                  .getContainerColor(),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: CustomColors
                                                      .getShadowColor(),
                                                  blurRadius: 4,
                                                  spreadRadius: 0,
                                                  offset: const Offset(0, 2),
                                                )
                                              ],
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Stack(
                                                  children: [
                                                    Container(
                                                      width: 48.w,
                                                      height: 48.h,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12.w),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      child: Image.network(
                                                        item.image,
                                                        width: 48,
                                                        height: 48,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(height: 12.h),
                                                Text(
                                                  item.name,
                                                  style: TextStyle(
                                                    color: CustomColors
                                                        .getTitleColor(),
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : SizedBox.shrink(),

                              // SizedBox(height: 20.h),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 20.w),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        languageController.getStoredData()[
                                                "Recent Transactions"] ??
                                            "Recent Transactions",
                                        style: TextStyle(
                                          // color: CustomColors.getTitleColor(),
                                          color: Get.isDarkMode
                                              ? CustomColors.titleColorDark
                                              : CustomColors.titleColor,
                                          fontSize: 22.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Get.toNamed(
                                            TransactionScreen.routeName);
                                      },
                                      child: Text(
                                        languageController
                                                .getStoredData()["See All"] ??
                                            "See All",
                                        style: TextStyle(
                                          color: CustomColors.primaryColor,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              transactionController.isLoading
                                  ? Shimmer.fromColors(
                                      baseColor:
                                          CustomColors.getContainerColor(),
                                      highlightColor:
                                          CustomColors.getShimmerColor(),
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: 3, // Number of shimmer items
                                        itemBuilder: (context, index) {
                                          return const ShimmerPreloader(); // Define ShimmerTransactionItem
                                        },
                                      ),
                                    )
                                  : transactionController
                                          .transactionLists.isNotEmpty
                                      ? ListView.builder(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5.h),
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: transactionController
                                              .transactionLists.length,
                                          itemBuilder: (context, index) {
                                            final item = transactionController
                                                .transactionLists[index];
                                            if (item.status.toLowerCase() ==
                                                "success") {
                                              transactionController.statusIcon =
                                                  CupertinoIcons
                                                      .check_mark_circled;
                                              transactionController
                                                      .statusColor =
                                                  CustomColors.primaryColor;
                                              transactionController
                                                      .statusBgColor =
                                                  CustomColors.primaryLight2;
                                            } else if (item.status
                                                    .toLowerCase() ==
                                                "pending") {
                                              transactionController.statusIcon =
                                                  Icons.restore_rounded;
                                              transactionController
                                                      .statusColor =
                                                  CustomColors.warningColor;
                                              transactionController
                                                      .statusBgColor =
                                                  CustomColors.warningLight;
                                            } else {
                                              transactionController.statusIcon =
                                                  Icons.close;
                                              transactionController
                                                      .statusColor =
                                                  CustomColors.secondaryColor;
                                              transactionController
                                                      .statusBgColor =
                                                  CustomColors.secondaryLight;
                                            }
                                            return GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.r),
                                                      ),
                                                      titlePadding:
                                                          EdgeInsets.all(0.w),
                                                      backgroundColor: CustomColors
                                                          .getContainerColor(),
                                                      surfaceTintColor:
                                                          Colors.transparent,
                                                      title: Stack(
                                                        children: [
                                                          Positioned.fill(
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        10.r),
                                                                topRight: Radius
                                                                    .circular(
                                                                        10.r),
                                                              ),
                                                              child:
                                                                  Image.asset(
                                                                "assets/background.png",
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    20.w),
                                                            child: Center(
                                                              child: Text(
                                                                languageController
                                                                            .getStoredData()[
                                                                        "Details"] ??
                                                                    "Details",
                                                                style:
                                                                    TextStyle(
                                                                  color: CustomColors
                                                                      .whiteColor,
                                                                  fontSize:
                                                                      20.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      content: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          RichText(
                                                            textAlign: TextAlign
                                                                .center,
                                                            text: TextSpan(
                                                              text: languageController
                                                                          .getStoredData()[
                                                                      "Transaction ID"] ??
                                                                  "Transaction ID",
                                                              style: TextStyle(
                                                                color: CustomColors
                                                                    .getTextColor(),
                                                                fontSize: 16.sp,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(height: 5.h),
                                                          RichText(
                                                            textAlign: TextAlign
                                                                .center,
                                                            text: TextSpan(
                                                              text: item
                                                                  .transactionId,
                                                              style: TextStyle(
                                                                color: CustomColors
                                                                    .getTitleColor(),
                                                                fontSize: 16.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                              height: 16.h),
                                                          RichText(
                                                            textAlign: TextAlign
                                                                .center,
                                                            text: TextSpan(
                                                              text: languageController
                                                                          .getStoredData()[
                                                                      "Remarks"] ??
                                                                  "Remarks",
                                                              style: TextStyle(
                                                                color: CustomColors
                                                                    .getTextColor(),
                                                                fontSize: 16.sp,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(height: 5.h),
                                                          RichText(
                                                            textAlign: TextAlign
                                                                .center,
                                                            text: TextSpan(
                                                              text:
                                                                  item.remarks,
                                                              style: TextStyle(
                                                                color: CustomColors
                                                                    .getTitleColor(),
                                                                fontSize: 16.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                              height: 16.h),
                                                          RichText(
                                                            textAlign: TextAlign
                                                                .center,
                                                            text: TextSpan(
                                                              text: languageController
                                                                          .getStoredData()[
                                                                      "Status"] ??
                                                                  "Status",
                                                              style: TextStyle(
                                                                color: CustomColors
                                                                    .getTextColor(),
                                                                fontSize: 16.sp,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(height: 5.h),
                                                          RichText(
                                                            textAlign: TextAlign
                                                                .center,
                                                            text: TextSpan(
                                                              text: item.status,
                                                              style: TextStyle(
                                                                color: CustomColors
                                                                    .getTitleColor(),
                                                                fontSize: 16.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    left: 20.w,
                                                    right: 20.w,
                                                    top: 0.h,
                                                    bottom: 15.h),
                                                decoration: BoxDecoration(
                                                  color: CustomColors
                                                      .getContainerColor(),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: CustomColors
                                                          .getShadowColor(),
                                                      blurRadius: 4,
                                                      spreadRadius: 0,
                                                      offset:
                                                          const Offset(0, 2),
                                                    )
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          16.r),
                                                ),
                                                child: ListTile(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 20.w,
                                                          vertical: 5.h),
                                                  leading: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16.r),
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          width: 45.w,
                                                          height: 45.h,
                                                          color:
                                                              transactionController
                                                                  .statusBgColor,
                                                        ),
                                                        Positioned(
                                                            top: 11.h,
                                                            left: 11.w,
                                                            child: Icon(
                                                                transactionController
                                                                    .statusIcon,
                                                                color: transactionController
                                                                    .statusColor)),
                                                      ],
                                                    ),
                                                  ),
                                                  title: Text(
                                                    item.remarks,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      color: CustomColors
                                                          .getTitleColor(),
                                                      fontSize: 16.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  subtitle: Text(
                                                    item.type,
                                                    style: TextStyle(
                                                      color: CustomColors
                                                          .getTextColor(),
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                  trailing: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        "${item.symbol}${item.amount}",
                                                        style: TextStyle(
                                                          color:
                                                              transactionController
                                                                  .statusColor,
                                                          fontSize: 16.sp,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      SizedBox(height: 8.h),
                                                      Text(
                                                        item.time
                                                            .substring(0, 10),
                                                        style: TextStyle(
                                                          color: CustomColors
                                                              .getTextColor(),
                                                          fontSize: 12.sp,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      : Padding(
                                          padding: EdgeInsets.only(
                                              top: 20.h, bottom: 60.h),
                                          child: Center(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  "assets/not_found.png",
                                                  fit: BoxFit.contain,
                                                  width: 180.w,
                                                  height: 180.h,
                                                ),
                                                Text(
                                                  languageController
                                                              .getStoredData()[
                                                          "No Transactions Available"] ??
                                                      "No Transactions Available",
                                                  style: TextStyle(
                                                    fontSize: 18.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                            ],
                          ),
                        )
                      : Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                CustomColors.primaryColor),
                            strokeWidth: 2.0,
                          ),
                        ),
                ),
              );
            });
          });
        });
      });
    });
  }
}
