import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/config/app_color.dart';

class MyProfileController extends GetxController {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController dobController;

  final selectedGender = 'Male'.obs;
  final isLoading = false.obs;

  final userName = 'User'.obs;
  final userEmail = 'user@example.com'.obs;
  final userPhone = '+91 98765 43210'.obs;
  final userDob = '15 June 1998'.obs;

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController(text: userName.value);
    emailController = TextEditingController(text: userEmail.value);
    phoneController = TextEditingController(text: userPhone.value);
    dobController = TextEditingController(text: userDob.value);
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    dobController.dispose();
    super.onClose();
  }

  void setGender(String gender) {
    selectedGender.value = gender;
  }

  Future<void> selectDateOfBirth(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1998, 6, 15),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColor.primary,
              onPrimary: Colors.black,
              onSurface: AppColor.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formattedDate =
          "${picked.day} ${_getMonthName(picked.month)} ${picked.year}";
      dobController.text = formattedDate;
      userDob.value = formattedDate;
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  void saveProfile() {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar(
        'Required',
        'Please enter your full name',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColor.error,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    Future.delayed(const Duration(milliseconds: 600), () {
      isLoading.value = false;
      userName.value = nameController.text.trim();
      userEmail.value = emailController.text.trim();
      userPhone.value = phoneController.text.trim();

      Get.snackbar(
        'Success',
        'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColor.textPrimary,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    });
  }
}
