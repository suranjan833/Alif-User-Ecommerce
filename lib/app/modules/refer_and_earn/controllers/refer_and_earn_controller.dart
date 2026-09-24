import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../data/config/app_color.dart';

class ReferAndEarnController extends GetxController {
  final referralCode = 'ALIF2026'.obs;
  final totalEarned = '₹500.00'.obs;
  final friendsReferred = 5.obs;

  void copyCode() {
    Clipboard.setData(ClipboardData(text: referralCode.value));
    Get.snackbar(
      'Copied!',
      'Referral code copied to clipboard',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColor.textPrimary,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }
}
