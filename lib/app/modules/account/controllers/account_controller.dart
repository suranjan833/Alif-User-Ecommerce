import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../../../data/config/app_color.dart';
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

  List<AccountSectionData> get sections => [
    AccountSectionData(
      title: 'Manage',
      items: [
        AccountMenuItem(
          title: 'My Profile',
          icon: Iconsax.user_edit,
          onTap: () => openMyProfileSheet(),
        ),
        AccountMenuItem(
          title: 'My Orders',
          icon: Iconsax.shopping_bag,
          onTap: () => onMenuItemTap('My Orders'),
        ),
        AccountMenuItem(
          title: 'Manage addresses',
          icon: Iconsax.location,
          onTap: () => onMenuItemTap('Manage addresses'),
        ),
        AccountMenuItem(
          title: 'My transactions',
          icon: Iconsax.card,
          onTap: () => onMenuItemTap('My transactions'),
        ),
        AccountMenuItem(
          title: 'My Wishlist',
          icon: Iconsax.heart,
          onTap: () => onMenuItemTap('My Wishlist'),
        ),
        AccountMenuItem(
          title: 'Wallet',
          icon: Iconsax.wallet_2,
          onTap: () => onMenuItemTap('Wallet'),
        ),
        AccountMenuItem(
          title: 'Shopping List',
          icon: Iconsax.clipboard_text,
          onTap: () => onMenuItemTap('Shopping List'),
        ),
        AccountMenuItem(
          title: 'Saved for later',
          icon: Iconsax.bookmark,
          onTap: () => onMenuItemTap('Saved for later'),
        ),
        AccountMenuItem(
          title: 'Refer and Earn',
          icon: Iconsax.profile_add,
          onTap: () => onMenuItemTap('Refer and Earn'),
        ),
      ],
    ),
    AccountSectionData(
      title: 'Settings',
      items: [
        AccountMenuItem(
          title: 'Account settings',
          icon: Iconsax.user,
          onTap: () => onMenuItemTap('Account settings'),
        ),
        AccountMenuItem(
          title: 'Notifications',
          icon: Iconsax.notification,
          onTap: () => onMenuItemTap('Notifications'),
        ),
        AccountMenuItem(
          title: 'Support',
          icon: Iconsax.message_question,
          onTap: () => onMenuItemTap('Support'),
        ),
        AccountMenuItem(
          title: 'Language',
          subtitle: 'Current Language: ${currentLanguage.value}',
          icon: Iconsax.translate,
          onTap: () => onMenuItemTap('Language'),
        ),
        AccountMenuItem(
          title: 'Stores',
          icon: Iconsax.shop,
          onTap: () => onMenuItemTap('Stores'),
        ),
      ],
    ),
    AccountSectionData(
      title: 'Others',
      items: [
        AccountMenuItem(
          title: 'About us',
          icon: Iconsax.info_circle,
          onTap: () => onMenuItemTap('About us'),
        ),
        AccountMenuItem(
          title: 'Terms & Condition',
          icon: Iconsax.document_text,
          onTap: () => onMenuItemTap('Terms & Condition'),
        ),
        AccountMenuItem(
          title: 'Privacy Policy',
          icon: Iconsax.lock,
          onTap: () => onMenuItemTap('Privacy Policy'),
        ),
        AccountMenuItem(
          title: 'Refund Policy',
          icon: Iconsax.refresh_circle,
          onTap: () => onMenuItemTap('Refund Policy'),
        ),
        AccountMenuItem(
          title: 'Shipping Policy',
          icon: Iconsax.truck_fast,
          onTap: () => onMenuItemTap('Shipping Policy'),
        ),
      ],
    ),
  ];

  void onMenuItemTap(String title) {
    // Menu item action handler
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
