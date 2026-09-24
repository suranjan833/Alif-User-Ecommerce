import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/country_model.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();

  final selectedCountry =
      CountryModel.defaultCountries.first.obs; // Default +91
  final phoneError = RxnString();
  final isLoading = false.obs;

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }

  void selectCountry(CountryModel country) {
    selectedCountry.value = country;
    validatePhone();
  }

  String? validatePhoneInput(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your phone number';
    }
    final cleanDigits = value.replaceAll(RegExp(r'\D'), '');
    if (cleanDigits.length < 7 || cleanDigits.length > 15) {
      return 'Please enter a valid phone number (7-15 digits)';
    }
    return null;
  }

  void validatePhone() {
    phoneError.value = validatePhoneInput(phoneController.text);
  }

  void login() async {
    final error = validatePhoneInput(phoneController.text);
    phoneError.value = error;

    if (error != null) return;

    if (formKey.currentState?.validate() ?? false) {
      isLoading.value = true;

      // Simulate API network request
      await Future.delayed(const Duration(seconds: 1));
      isLoading.value = false;

      final fullPhoneNumber =
          '${selectedCountry.value.dialCode} ${phoneController.text.trim()}';

      Get.snackbar(
        'Success',
        'Logged in successfully with $fullPhoneNumber',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.black87,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      );

      Get.offAllNamed(Routes.MAIN_NAVIGATION);
    }
  }

  void goToSignup() {
    Get.toNamed(Routes.SIGNUP);
  }
}
