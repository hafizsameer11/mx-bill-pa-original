import 'package:bill_payment/screens/auth/signin_screen.dart';
import 'package:bill_payment/screens/profile/email_verification.dart';
import 'package:bill_payment/screens/profile/sms_verification.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

final box = GetStorage();

void checkVerificationStatus() {
  if (kDebugMode) {
    print("checking verification status");
  }
  // Check values from GetStorage
  dynamic storedEmail = box.read('isEmailVerified');
  dynamic storedSms = box.read('isSmsVerified');
  dynamic storedStatus = box.read('isStatusVerified');

  if (storedEmail != 1) {
    Get.offAllNamed(EmailVerification.routeName);
  } else if (storedSms != 1) {
    Get.offAllNamed(SmsVerification.routeName);
  } else if (storedStatus != 1) {
    Get.offAllNamed(SignInScreen.routeName);
  }
}
