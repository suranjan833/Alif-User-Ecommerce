import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../../../data/config/app_color.dart';
import '../controllers/category_products_controller.dart';

class CategoryProductsView extends GetView<CategoryProductsController> {
  const CategoryProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<CategoryProductsController>()) {
      Get.put(CategoryProductsController());
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: AppColor.textPrimary,
            size: 24.r,
          ),
          onPressed: () => Get.back(),
        ),
        titleSpacing: 0,
        title: Obx(
          () => Row(
            children: [
              Container(
                width: 36.r,
                height: 36.r,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: const Color(0xFFF1F5F9),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.network(
                  controller.categoryImage.value,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Iconsax.image,
                    size: 20.r,
                    color: AppColor.textSecondary,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.categoryName.value,
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColor.textPrimary,
                    ),
                  ),
                  Text(
                    '${controller.itemCount.value} items',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColor.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Iconsax.search_normal_1,
              color: AppColor.textPrimary,
              size: 22.r,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Iconsax.shopping_bag,
              color: AppColor.textPrimary,
              size: 22.r,
            ),
            onPressed: () {},
          ),
          SizedBox(width: 4.w),
        ],
      ),
      body: Row(
        children: [
          // 1. Left Vertical Sub-category Navigation Sidebar
          Container(
            width: 82.w,
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                right: BorderSide(color: Color(0xFFF1F5F9), width: 1),
              ),
            ),
            child: Obx(
              () => ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                itemCount: controller.subCategories.length,
                itemBuilder: (context, index) {
                  final subCategory = controller.subCategories[index];
                  final isSelected =
                      index == controller.selectedSubCategoryIndex.value;

                  return GestureDetector(
                    onTap: () => controller.selectSubCategory(index),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 12.h,
                        horizontal: 4.w,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFFFF7E6)
                            : Colors.transparent,
                        border: Border(
                          left: BorderSide(
                            color: isSelected
                                ? const Color(0xFFFBAF18)
                                : Colors.transparent,
                            width: 3.5.w,
                          ),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (index == 0)
                            Icon(
                              Icons.shopping_basket_outlined,
                              size: 26.r,
                              color: isSelected
                                  ? const Color(0xFFFBAF18)
                                  : AppColor.textSecondary,
                            )
                          else
                            Image.network(
                              subCategory['icon'] as String,
                              width: 26.r,
                              height: 26.r,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(
                                    Iconsax.grid_5,
                                    size: 24.r,
                                    color: isSelected
                                        ? const Color(0xFFFBAF18)
                                        : AppColor.textSecondary,
                                  ),
                            ),
                          SizedBox(height: 6.h),
                          Text(
                            subCategory['name'] as String,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 10.sp,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isSelected
                                  ? const Color(0xFFD98200)
                                  : AppColor.textSecondary,
                              height: 1.2,
                            ),
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // 2. Right Main Products Listing Content Area
          Expanded(
            child: Container(
              color: const Color(0xFFF8F9FA),
              child: Column(
                children: [
                  // Filter & Sort Control Pills Bar
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 10.h,
                    ),
                    child: Row(
                      children: [
                        // Filter Pill Button
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 7.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Iconsax.setting_4,
                                size: 15.r,
                                color: AppColor.textPrimary,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                'Filter',
                                style: GoogleFonts.inter(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.textPrimary,
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 16.r,
                                color: AppColor.textPrimary,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8.w),
                        // Sort Pill Button
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 7.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.swap_vert_rounded,
                                size: 17.r,
                                color: AppColor.textPrimary,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                'Sort',
                                style: GoogleFonts.inter(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.textPrimary,
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 16.r,
                                color: AppColor.textPrimary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Product Cards Grid
                  Expanded(
                    child: Obx(() {
                      final products = controller.filteredProducts;

                      if (products.isEmpty) {
                        return Center(
                          child: Text(
                            'No products available',
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              color: AppColor.textSecondary,
                            ),
                          ),
                        );
                      }

                      return GridView.builder(
                        padding: EdgeInsets.only(
                          left: 10.w,
                          right: 10.w,
                          bottom: 20.h,
                        ),
                        physics: const BouncingScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.51,
                          crossAxisSpacing: 10.w,
                          mainAxisSpacing: 12.h,
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return _buildProductCard(context, product);
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Map<String, dynamic> product) {
    final productId = product['id'] as String;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Container with Badge, Wishlist Heart, and Add Floating Button
          Stack(
            children: [
              Container(
                height: 110.h,
                width: double.infinity,
                padding: EdgeInsets.all(8.r),
                child: Center(
                  child: Image.network(
                    product['image'] as String,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Iconsax.image,
                      size: 32.r,
                      color: AppColor.textSecondary,
                    ),
                  ),
                ),
              ),

              // Top Left Badge (e.g. "2 Pack")
              if (product['badge'] != null)
                Positioned(
                  left: 8.w,
                  top: 8.h,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 7.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFBAE6FD),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      product['badge'] as String,
                      style: GoogleFonts.inter(
                        fontSize: 9.5.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0284C7),
                      ),
                    ),
                  ),
                ),

              // Top Right Wishlist Heart
              Positioned(
                right: 8.w,
                top: 8.h,
                child: Obx(() {
                  final isWishlisted = controller.wishlistedProductIds.contains(
                    productId,
                  );
                  return GestureDetector(
                    onTap: () => controller.toggleWishlist(productId),
                    child: Icon(
                      isWishlisted ? Iconsax.heart5 : Iconsax.heart,
                      size: 18.r,
                      color: isWishlisted
                          ? const Color(0xFFFBAF18)
                          : const Color(0xFF9E9E9E),
                    ),
                  );
                }),
              ),

              // Bottom Right Add Button (+)
              Positioned(
                right: 6.w,
                bottom: 6.h,
                child: GestureDetector(
                  onTap: () => controller.addToCart(product),
                  child: Container(
                    width: 32.r,
                    height: 32.r,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBAF18),
                      borderRadius: BorderRadius.circular(10.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.add_rounded,
                        size: 22.r,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Product Info Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Brand Name
                Text(
                  product['brand'] as String,
                  style: GoogleFonts.inter(
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColor.textPrimary,
                  ),
                ),
                SizedBox(height: 2.h),

                // Product Title
                Text(
                  product['title'] as String,
                  style: GoogleFonts.inter(
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColor.textSecondary,
                    height: 1.25,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6.h),

                // Discount Text
                Text(
                  product['discount'] as String,
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF16A34A),
                  ),
                ),
                SizedBox(height: 4.h),

                // Dashed / Light Line Separator
                Container(
                  height: 1.h,
                  width: double.infinity,
                  color: const Color(0xFFF1F5F9),
                ),
                SizedBox(height: 6.h),

                // Price Row
                Row(
                  children: [
                    Text(
                      '₹${product['price']}',
                      style: GoogleFonts.inter(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColor.textPrimary,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      '₹${product['originalPrice']}',
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColor.textHint,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
