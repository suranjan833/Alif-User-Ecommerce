import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/config/app_color.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: Stack(
        children: [
          // Background ambient gradient circles
          Positioned(
            top: -60.h,
            right: -60.w,
            child: Container(
              width: 200.w,
              height: 200.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.primaryLight.withValues(alpha: 0.6),
              ),
            ),
          ),
          Positioned(
            bottom: -80.h,
            left: -80.w,
            child: Container(
              width: 220.w,
              height: 220.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.primaryLight.withValues(alpha: 0.4),
              ),
            ),
          ),

          // Center Logo and Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Logo
                FadeTransition(
                  opacity: controller.logoFadeAnimation,
                  child: ScaleTransition(
                    scale: controller.logoScaleAnimation,
                    child: Container(
                      width: 100.w,
                      height: 100.w,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColor.primary, AppColor.primaryDark],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(26.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.primary.withValues(alpha: 0.35),
                            blurRadius: 24,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.shopping_bag_rounded,
                          size: 52.sp,
                          color: AppColor.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),

                // Animated App Name with Lato font
                SlideTransition(
                  position: controller.textSlideAnimation,
                  child: FadeTransition(
                    opacity: controller.textFadeAnimation,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          'ALIF',
                          style: GoogleFonts.lato(
                            fontSize: 34.sp,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 4.w,
                            color: AppColor.textPrimary,
                          ),
                        ),
                        Container(
                          width: 8.w,
                          height: 8.w,
                          margin: EdgeInsets.only(left: 4.w),
                          decoration: const BoxDecoration(
                            color: AppColor.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 8.h),

                // Animated Tagline with Lato font
                FadeTransition(
                  opacity: controller.taglineFadeAnimation,
                  child: Text(
                    'Smart Shopping & Instant Delivery',
                    style: GoogleFonts.lato(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.6,
                      color: AppColor.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Loading / Branding
          Positioned(
            bottom: 40.h,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: controller.taglineFadeAnimation,
              child: Column(
                children: [
                  SizedBox(
                    width: 28.w,
                    height: 28.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColor.primary,
                      ),
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Text(
                    'v1.0.0',
                    style: GoogleFonts.lato(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColor.textHint,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
