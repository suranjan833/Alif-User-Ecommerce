import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/config/app_color.dart';

class WalletController extends GetxController {
  final balance = 1899.00.obs;

  void addMoney(double amount) {
    balance.value += amount;
    Get.snackbar(
      'Money Added',
      '₹${amount.toStringAsFixed(0)} added to your Alif Wallet',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColor.textPrimary,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }
}
