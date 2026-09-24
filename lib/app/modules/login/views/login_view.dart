import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/config/app_color.dart';
import '../../../data/widgets/country_picker_dialog.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 32.h),

                // Brand Header Badge / Icon
                Container(
                  width: 48.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: AppColor.primaryLight,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.phone_android_rounded,
                      color: AppColor.primary,
                      size: 24.r,
                    ),
                  ),
                ),

                SizedBox(height: 20.h),

                // Header Titles
                Text(
                  'Welcome Back!',
                  style: GoogleFonts.lato(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColor.textPrimary,
                    letterSpacing: -0.4,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'Enter your phone number to sign in or continue.',
                  style: GoogleFonts.lato(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.normal,
                    color: AppColor.textSecondary,
                    height: 1.4,
                  ),
                ),

                SizedBox(height: 28.h),

                // Phone Number Field Label
                Text(
                  'Phone Number',
                  style: GoogleFonts.lato(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColor.textPrimary,
                  ),
                ),
                SizedBox(height: 6.h),

                // Phone Input with Country Code Selector
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Country Code Picker Button
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
                                  Icons.arrow_drop_down_rounded,
                                  color: AppColor.textSecondary,
                                  size: 20.r,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 8.w),

                    // Phone Number TextFormField
                    Expanded(
                      child: TextFormField(
                        controller: controller.phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(15),
                        ],
                        onChanged: (_) => controller.validatePhone(),
                        validator: controller.validatePhoneInput,
                        style: GoogleFonts.lato(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColor.textPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter phone number',
                          hintStyle: GoogleFonts.lato(
                            fontSize: 14.sp,
                            color: AppColor.textHint,
                          ),
                          filled: true,
                          fillColor: AppColor.surface,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 12.h,
                          ),
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
                            borderSide: const BorderSide(
                              color: AppColor.primary,
                              width: 1.5,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: const BorderSide(
                              color: AppColor.error,
                              width: 1.2,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: const BorderSide(
                              color: AppColor.error,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
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
                          : controller.login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        disabledBackgroundColor: AppColor.primary.withValues(
                          alpha: 0.6,
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
                              'Continue',
                              style: GoogleFonts.lato(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),

                SizedBox(height: 28.h),

                // Footer: Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: GoogleFonts.lato(
                        fontSize: 13.sp,
                        color: AppColor.textSecondary,
                      ),
                    ),
                    GestureDetector(
                      onTap: controller.goToSignup,
                      child: Text(
                        'Sign Up',
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
}
