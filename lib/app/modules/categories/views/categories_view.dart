import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../../../data/config/app_color.dart';
import '../controllers/categories_controller.dart';

class CategoriesView extends GetView<CategoriesController> {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<CategoriesController>()) {
      Get.put(CategoriesController());
    }

    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Header: Categories Title + Search Icon
            Padding(
              padding: EdgeInsets.only(
                left: 16.w,
                right: 16.w,
                top: 14.h,
                bottom: 12.h,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Categories',
                    style: GoogleFonts.inter(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColor.textPrimary,
                    ),
                  ),
                  Icon(
                    Iconsax.search_normal_1,
                    size: 24.r,
                    color: AppColor.textPrimary,
                  ),
                ],
              ),
            ),

            // Categories Grid (Matching reference screenshot)
            Expanded(
              child: Obx(
                () => GridView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.4,
                    crossAxisSpacing: 14.w,
                    mainAxisSpacing: 14.h,
                  ),
                  itemCount: controller.categories.length,
                  itemBuilder: (context, index) {
                    final item = controller.categories[index];
                    return _buildCategoryCard(item);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> item) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFFEFF1F5),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Stack(
        children: [
          // Category Image on Right
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: 85.w,
            child: ClipRRect(
              borderRadius: BorderRadius.horizontal(
                right: Radius.circular(18.r),
              ),
              child: Image.network(
                item['image'] as String,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey.shade300,
                  child: Icon(
                    Iconsax.image,
                    size: 24.r,
                    color: AppColor.textSecondary,
                  ),
                ),
              ),
            ),
          ),

          // Gradient transition overlay to blend image smoothly with card background
          Positioned(
            right: 50.w,
            top: 0,
            bottom: 0,
            width: 40.w,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xFFEFF1F5), Colors.transparent],
                ),
              ),
            ),
          ),

          // Category Name on Left (Clean word wrapping)
          Positioned(
            left: 14.w,
            top: 14.h,
            right: 72.w,
            child: Text(
              item['name'] as String,
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: AppColor.textPrimary,
                height: 1.25,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
