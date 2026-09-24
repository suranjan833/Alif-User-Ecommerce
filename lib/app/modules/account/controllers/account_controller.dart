import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../../../data/config/app_color.dart';
import '../../../data/services/app_translations.dart';
import '../../../routes/app_pages.dart';

class AccountMenuItem {
  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback? onTap;

  AccountMenuItem({
    required this.title,
    this.subtitle,
    required this.icon,
    this.onTap,
  });
}

class AccountSectionData {
  final String title;
  final List<AccountMenuItem> items;

  AccountSectionData({required this.title, required this.items});
}

class AccountController extends GetxController {
  final userName = 'User'.obs;
  final userEmail = 'user@example.com'.obs;
  final userPhone = '+91 98765 43210'.obs;
  final memberSince = 'Member since Jun-2026'.obs;
  final currentLanguage = 'English'.obs;
  final currentLangCode = 'en'.obs;

  List<AccountSectionData> get sections => [
    AccountSectionData(
      title: 'manage'.tr,
      items: [
        AccountMenuItem(
          title: 'my_profile'.tr,
          icon: Iconsax.user_edit,
          onTap: () => openMyProfile(),
        ),
        AccountMenuItem(
          title: 'my_orders'.tr,
          icon: Iconsax.shopping_bag,
          onTap: () => openMyOrders(),
        ),
        AccountMenuItem(
          title: 'manage_addresses'.tr,
          icon: Iconsax.location,
          onTap: () => openManageAddresses(),
        ),
        AccountMenuItem(
          title: 'my_transactions'.tr,
          icon: Iconsax.card,
          onTap: () => Get.toNamed(Routes.MY_TRANSACTIONS),
        ),
        AccountMenuItem(
          title: 'my_wishlist'.tr,
          icon: Iconsax.heart,
          onTap: () => Get.toNamed(Routes.MY_WISHLIST),
        ),
        AccountMenuItem(
          title: 'wallet'.tr,
          icon: Iconsax.wallet_2,
          onTap: () => Get.toNamed(Routes.WALLET),
        ),
        AccountMenuItem(
          title: 'shopping_list'.tr,
          icon: Iconsax.clipboard_text,
          onTap: () => Get.toNamed(Routes.SHOPPING_LIST),
        ),
        AccountMenuItem(
          title: 'refer_and_earn'.tr,
          icon: Iconsax.profile_add,
          onTap: () => Get.toNamed(Routes.REFER_AND_EARN),
        ),
      ],
    ),
    AccountSectionData(
      title: 'settings'.tr,
      items: [
        AccountMenuItem(
          title: 'account_settings'.tr,
          icon: Iconsax.user,
          onTap: () => openMyProfile(),
        ),
        AccountMenuItem(
          title: 'notifications'.tr,
          icon: Iconsax.notification,
          onTap: () => Get.toNamed(Routes.NOTIFICATIONS),
        ),
        AccountMenuItem(
          title: 'support'.tr,
          icon: Iconsax.message_question,
          onTap: () => Get.toNamed(Routes.SUPPORT),
        ),
        AccountMenuItem(
          title: 'language'.tr,
          subtitle: '${"language".tr}: ${currentLanguage.value}',
          icon: Iconsax.translate,
          onTap: () => openLanguageSelectionSheet(),
        ),
      ],
    ),
    AccountSectionData(
      title: 'others'.tr,
      items: [
        AccountMenuItem(
          title: 'about_us'.tr,
          icon: Iconsax.info_circle,
          onTap: () => Get.toNamed(Routes.ABOUT_US),
        ),
        AccountMenuItem(
          title: 'terms_and_conditions'.tr,
          icon: Iconsax.document_text,
          onTap: () => Get.toNamed(Routes.TERMS_AND_CONDITIONS),
        ),
        AccountMenuItem(
          title: 'privacy_policy'.tr,
          icon: Iconsax.lock,
          onTap: () => Get.toNamed(Routes.PRIVACY_POLICY),
        ),
        AccountMenuItem(
          title: 'refund_policy'.tr,
          icon: Iconsax.refresh_circle,
          onTap: () => Get.toNamed(Routes.REFUND_POLICY),
        ),
        AccountMenuItem(
          title: 'shipping_policy'.tr,
          icon: Iconsax.truck_fast,
          onTap: () => Get.toNamed(Routes.SHIPPING_POLICY),
        ),
      ],
    ),
  ];

  void onMenuItemTap(String title) {
    // Menu item action handler
  }

  void openMyProfile() {
    Get.toNamed(Routes.MY_PROFILE);
  }

  void openMyOrders() {
    Get.toNamed(Routes.MY_ORDERS);
  }

  void openManageAddresses() {
    Get.toNamed(Routes.MANAGE_ADDRESSES);
  }

  void openLanguageSelectionSheet() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'select_language'.tr,
              style: GoogleFonts.lato(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColor.textPrimary,
              ),
            ),
            SizedBox(height: 16.h),
            Obx(
              () => Column(
                children: [
                  _buildLanguageOption(
                    code: 'en',
                    title: 'english'.tr,
                    isSelected: currentLangCode.value == 'en',
                    onTap: () {
                      currentLangCode.value = 'en';
                      currentLanguage.value = 'English';
                      AppTranslations.changeLanguage('en');
                      update();
                      Get.back();
                    },
                  ),
                  SizedBox(height: 10.h),
                  _buildLanguageOption(
                    code: 'bn',
                    title: 'bangla'.tr,
                    isSelected: currentLangCode.value == 'bn',
                    onTap: () {
                      currentLangCode.value = 'bn';
                      currentLanguage.value = 'Bangla (বাংলা)';
                      AppTranslations.changeLanguage('bn');
                      update();
                      Get.back();
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption({
    required String code,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF7E6) : const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? AppColor.primary : const Color(0xFFE2E8F0),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.lato(
                fontSize: 15.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? AppColor.primaryDark : AppColor.textPrimary,
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: AppColor.primaryDark, size: 20.r),
          ],
        ),
      ),
    );
  }

  void openMyProfileSheet() {
    final nameController = TextEditingController(text: userName.value);
    final emailController = TextEditingController(text: userEmail.value);
    final phoneController = TextEditingController(text: userPhone.value);

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Profile',
                    style: GoogleFonts.lato(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColor.textPrimary,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(
                      Icons.close,
                      size: 22.r,
                      color: AppColor.textSecondary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              // Avatar
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 74.r,
                      height: 74.r,
                      decoration: const BoxDecoration(
                        color: Color(0xFF0F172A),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 40.r,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(6.r),
                        decoration: BoxDecoration(
                          color: AppColor.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2.w),
                        ),
                        child: Icon(
                          Iconsax.camera,
                          size: 14.r,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              // Full Name
              Text(
                'Full Name',
                style: GoogleFonts.lato(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColor.textPrimary,
                ),
              ),
              SizedBox(height: 6.h),
              TextField(
                controller: nameController,
                style: GoogleFonts.lato(
                  fontSize: 14.sp,
                  color: AppColor.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter full name',
                  prefixIcon: Icon(
                    Iconsax.user,
                    size: 20.r,
                    color: AppColor.textSecondary,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 12.h,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                ),
              ),
              SizedBox(height: 14.h),
              // Email
              Text(
                'Email Address',
                style: GoogleFonts.lato(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColor.textPrimary,
                ),
              ),
              SizedBox(height: 6.h),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                style: GoogleFonts.lato(
                  fontSize: 14.sp,
                  color: AppColor.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter email address',
                  prefixIcon: Icon(
                    Iconsax.sms,
                    size: 20.r,
                    color: AppColor.textSecondary,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 12.h,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                ),
              ),
              SizedBox(height: 14.h),
              // Phone Number
              Text(
                'Phone Number',
                style: GoogleFonts.lato(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColor.textPrimary,
                ),
              ),
              SizedBox(height: 6.h),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                style: GoogleFonts.lato(
                  fontSize: 14.sp,
                  color: AppColor.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter phone number',
                  prefixIcon: Icon(
                    Iconsax.call,
                    size: 20.r,
                    color: AppColor.textSecondary,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 12.h,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              // Save Button
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: () {
                    if (nameController.text.trim().isNotEmpty) {
                      userName.value = nameController.text.trim();
                    }
                    if (emailController.text.trim().isNotEmpty) {
                      userEmail.value = emailController.text.trim();
                    }
                    if (phoneController.text.trim().isNotEmpty) {
                      userPhone.value = phoneController.text.trim();
                    }
                    Get.back();
                    Get.snackbar(
                      'Success',
                      'Profile updated successfully',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: AppColor.textPrimary,
                      colorText: Colors.white,
                      duration: const Duration(seconds: 2),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Save Changes',
                    style: GoogleFonts.lato(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColor.textPrimary,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  void logout() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56.r,
                height: 56.r,
                decoration: const BoxDecoration(
                  color: Color(0xFFFEE2E2),
                  shape: BoxShape.circle,
                ),
                child: Icon(Iconsax.logout, color: AppColor.error, size: 26.r),
              ),
              SizedBox(height: 16.h),
              Text(
                'Logout',
                style: GoogleFonts.lato(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColor.textPrimary,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Are you sure you want to log out from your account?',
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  fontSize: 14.sp,
                  color: AppColor.textSecondary,
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        side: const BorderSide(color: AppColor.border),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.lato(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColor.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        Get.offAllNamed(Routes.LOGIN);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.error,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'Logout',
                        style: GoogleFonts.lato(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
