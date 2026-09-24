import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../../../data/config/app_color.dart';
import '../../../data/widgets/country_picker_dialog.dart';
import '../controllers/signup_controller.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 44.h,
        leading: IconButton(
          icon: Icon(
            Iconsax.arrow_left_2,
            color: AppColor.textPrimary,
            size: 20.r,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4.h),

                // Header Title
                Text(
                  'Create Account',
                  style: GoogleFonts.lato(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColor.textPrimary,
                    letterSpacing: -0.4,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Sign up now to get started with your account.',
                  style: GoogleFonts.lato(
                    fontSize: 13.sp,
                    color: AppColor.textSecondary,
                  ),
                ),

                SizedBox(height: 20.h),

                // 1. Full Name
                _buildFieldLabel('Full Name'),
                SizedBox(height: 4.h),
                TextFormField(
                  controller: controller.nameController,
                  validator: controller.validateName,
                  textCapitalization: TextCapitalization.words,
                  style: _inputTextStyle,
                  decoration: _buildInputDecoration(
                    hintText: 'Enter your full name',
                    prefixIcon: Iconsax.user,
                  ),
                ),

                SizedBox(height: 12.h),

                // 2. Email Address
                _buildFieldLabel('Email Address'),
                SizedBox(height: 4.h),
                TextFormField(
                  controller: controller.emailController,
                  validator: controller.validateEmail,
                  keyboardType: TextInputType.emailAddress,
                  style: _inputTextStyle,
                  decoration: _buildInputDecoration(
                    hintText: 'Enter your email address',
                    prefixIcon: Iconsax.sms,
                  ),
                ),

                SizedBox(height: 12.h),

                // 3. Phone Number with Country Code
                _buildFieldLabel('Phone Number'),
                SizedBox(height: 4.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => Material(
                        color: AppColor.surface,
                        borderRadius: BorderRadius.circular(12.r),
                        child: InkWell(
                          onTap: () => CountryPickerDialog.show(
                            context,
                            controller.selectedCountry.value,
                            controller.selectCountry,
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                          child: Container(
                            height: 48.h,
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(color: AppColor.border),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  controller.selectedCountry.value.flag,
                                  style: TextStyle(fontSize: 18.sp),
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  controller.selectedCountry.value.dialCode,
                                  style: GoogleFonts.lato(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.textPrimary,
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                Icon(
                                  Iconsax.arrow_down_1,
                                  color: AppColor.textSecondary,
                                  size: 16.r,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: TextFormField(
                        controller: controller.phoneController,
                        validator: controller.validatePhone,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(15),
                        ],
                        style: _inputTextStyle,
                        decoration: _buildInputDecoration(
                          hintText: 'Enter phone number',
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12.h),

                // 4. Password
                _buildFieldLabel('Password'),
                SizedBox(height: 4.h),
                Obx(
                  () => TextFormField(
                    controller: controller.passwordController,
                    validator: controller.validatePassword,
                    obscureText: !controller.isPasswordVisible.value,
                    style: _inputTextStyle,
                    decoration: _buildInputDecoration(
                      hintText: 'Enter password (min 6 chars)',
                      prefixIcon: Iconsax.lock,
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isPasswordVisible.value
                              ? Iconsax.eye
                              : Iconsax.eye_slash,
                          color: AppColor.textSecondary,
                          size: 18.r,
                        ),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 12.h),

                // 5. Confirm Password
                _buildFieldLabel('Confirm Password'),
                SizedBox(height: 4.h),
                Obx(
                  () => TextFormField(
                    controller: controller.confirmPasswordController,
                    validator: controller.validateConfirmPassword,
                    obscureText: !controller.isConfirmPasswordVisible.value,
                    style: _inputTextStyle,
                    decoration: _buildInputDecoration(
                      hintText: 'Re-enter your password',
                      prefixIcon: Iconsax.lock,
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isConfirmPasswordVisible.value
                              ? Iconsax.eye
                              : Iconsax.eye_slash,
                          color: AppColor.textSecondary,
                          size: 18.r,
                        ),
                        onPressed: controller.toggleConfirmPasswordVisibility,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 12.h),

                // 6. Referral Code (Optional)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildFieldLabel('Referral Code'),
                    Text(
                      '(Optional)',
                      style: GoogleFonts.lato(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                TextFormField(
                  controller: controller.referralCodeController,
                  textCapitalization: TextCapitalization.characters,
                  style: _inputTextStyle,
                  decoration: _buildInputDecoration(
                    hintText: 'Enter referral code (if any)',
                    prefixIcon: Iconsax.gift,
                  ),
                ),

                SizedBox(height: 24.h),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: Obx(
                    () => ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.signup,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: controller.isLoading.value
                          ? SizedBox(
                              width: 20.r,
                              height: 20.r,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.2,
                              ),
                            )
                          : Text(
                              'Create Account',
                              style: GoogleFonts.lato(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),

                SizedBox(height: 20.h),

                // Footer: Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: GoogleFonts.lato(
                        fontSize: 13.sp,
                        color: AppColor.textSecondary,
                      ),
                    ),
                    GestureDetector(
                      onTap: controller.goToLogin,
                      child: Text(
                        'Log In',
                        style: GoogleFonts.lato(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColor.primary,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.lato(
        fontSize: 13.sp,
        fontWeight: FontWeight.bold,
        color: AppColor.textPrimary,
      ),
    );
  }

  TextStyle get _inputTextStyle => GoogleFonts.lato(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: AppColor.textPrimary,
  );

  InputDecoration _buildInputDecoration({
    required String hintText,
    IconData? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: GoogleFonts.lato(fontSize: 13.sp, color: AppColor.textHint),
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, color: AppColor.textSecondary, size: 18.r)
          : null,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: AppColor.surface,
      contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: AppColor.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: AppColor.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: AppColor.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: AppColor.error, width: 1.2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: AppColor.error, width: 1.5),
      ),
    );
  }
}
