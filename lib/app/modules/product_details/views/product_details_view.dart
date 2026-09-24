import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../../../data/config/app_color.dart';
import '../../../routes/app_pages.dart';
import '../controllers/product_details_controller.dart';

class ProductDetailsView extends GetView<ProductDetailsController> {
  const ProductDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
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
        title: Text(
          'Product Details',
          style: GoogleFonts.lato(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColor.textPrimary,
          ),
        ),
        centerTitle: false,
        actions: [
          Obx(
            () => IconButton(
              icon: Icon(
                controller.isWishlisted.value ? Iconsax.heart5 : Iconsax.heart,
                color: controller.isWishlisted.value
                    ? AppColor.primary
                    : AppColor.textPrimary,
                size: 22.r,
              ),
              onPressed: () => controller.toggleWishlist(),
            ),
          ),
          IconButton(
            icon: Icon(
              Iconsax.shopping_bag,
              color: AppColor.textPrimary,
              size: 22.r,
            ),
            onPressed: () => Get.toNamed(Routes.BAG),
          ),
          SizedBox(width: 4.w),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Product Image Card
                  Obx(() {
                    final item = controller.product;
                    final imageUrl = item['image'] as String? ?? '';
                    final discount = item['discount'] as String? ?? '';

                    return Container(
                      width: double.infinity,
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 16.h,
                      ),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                height: 220.h,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8F9FA),
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Center(
                                  child: Image.network(
                                    imageUrl,
                                    height: 180.h,
                                    fit: BoxFit.contain,
                                    errorBuilder:
                                        (context, error, stackTrace) => Icon(
                                          Iconsax.image,
                                          size: 54.r,
                                          color: AppColor.textSecondary,
                                        ),
                                  ),
                                ),
                              ),
                              if (discount.isNotEmpty)
                                Positioned(
                                  top: 12.h,
                                  left: 12.w,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                      vertical: 5.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFDCFCE7),
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: Text(
                                      discount,
                                      style: GoogleFonts.lato(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF16A34A),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                  SizedBox(height: 10.h),

                  // 2. Product Information Card
                  Obx(() {
                    final item = controller.product;
                    final title = item['title'] as String? ?? 'Product Title';
                    final brand = item['brand'] as String? ?? 'Brand';
                    final rawPrice = item['price'];
                    final rawOriginalPrice = item['originalPrice'];
                    final rating = item['rating']?.toString() ?? '4.8';
                    final reviews = item['reviews']?.toString() ?? '245';

                    String formatPrice(dynamic raw) {
                      if (raw == null) return '₹0';
                      final str = raw.toString();
                      if (str.startsWith('₹')) return str;
                      if (str.startsWith('\$')) return '₹${str.substring(1)}';
                      return '₹$str';
                    }

                    final priceStr = formatPrice(rawPrice);
                    final originalPriceStr = rawOriginalPrice != null
                        ? formatPrice(rawOriginalPrice)
                        : '';

                    return Container(
                      width: double.infinity,
                      color: Colors.white,
                      padding: EdgeInsets.all(20.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            brand.toUpperCase(),
                            style: GoogleFonts.lato(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColor.primaryDark,
                              letterSpacing: 1,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            title,
                            style: GoogleFonts.lato(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColor.textPrimary,
                              height: 1.3,
                            ),
                          ),
                          SizedBox(height: 10.h),

                          // Rating Row
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF7E6),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.star_rounded,
                                      size: 16.r,
                                      color: AppColor.primaryDark,
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      rating,
                                      style: GoogleFonts.lato(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                '($reviews reviews)',
                                style: GoogleFonts.lato(
                                  fontSize: 13.sp,
                                  color: AppColor.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 14.h),

                          // Price Row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                priceStr,
                                style: GoogleFonts.lato(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w800,
                                  color: AppColor.textPrimary,
                                ),
                              ),
                              if (originalPriceStr.isNotEmpty) ...[
                                SizedBox(width: 8.w),
                                Text(
                                  originalPriceStr,
                                  style: GoogleFonts.lato(
                                    fontSize: 14.sp,
                                    color: AppColor.textHint,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                  SizedBox(height: 10.h),

                  // 3. Description Card
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: EdgeInsets.all(20.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Description',
                          style: GoogleFonts.lato(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColor.textPrimary,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Obx(
                          () => Text(
                            controller.product['description'] as String? ?? 'High-quality premium product featuring sleek modern design, durable build, and advanced technology. Perfect for everyday usage with industry-leading performance and customer warranty.',
                            style: GoogleFonts.lato(
                              fontSize: 14.sp,
                              color: AppColor.textSecondary,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),

                  // 4. Seller Details Card (Clickable to Seller Details Page)
                  Obx(() {
                    final seller = controller.seller;

                    return Container(
                      width: double.infinity,
                      color: Colors.white,
                      padding: EdgeInsets.all(20.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Seller Information',
                                style: GoogleFonts.lato(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.textPrimary,
                                ),
                              ),
                              TextButton(
                                onPressed: () => controller.openSellerDetails(),
                                child: Text(
                                  'View Store',
                                  style: GoogleFonts.lato(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.primaryDark,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),

                          // Interactive Seller Box
                          Material(
                            color: const Color(0xFFF8F9FA),
                            borderRadius: BorderRadius.circular(16.r),
                            child: InkWell(
                              onTap: () => controller.openSellerDetails(),
                              borderRadius: BorderRadius.circular(16.r),
                              child: Padding(
                                padding: EdgeInsets.all(14.r),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 48.r,
                                      height: 48.r,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: const Color(0xFFE2E8F0),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            seller['avatar'] as String,
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                seller['name'] as String,
                                                style: GoogleFonts.lato(
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColor.textPrimary,
                                                ),
                                              ),
                                              SizedBox(width: 4.w),
                                              Icon(
                                                Icons.verified_rounded,
                                                size: 16.r,
                                                color: const Color(0xFF0284C7),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 3.h),
                                          Text(
                                            '${seller['rating']} ★ • ${seller['reviewsCount']} ratings',
                                            style: GoogleFonts.lato(
                                              fontSize: 12.5.sp,
                                              color: AppColor.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right_rounded,
                                      size: 22.r,
                                      color: const Color(0xFFA0A7B5),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),

          // Bottom Bar (Add to Bag & Buy Now)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: const Color(0xFFE2E8F0), width: 1.w),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => controller.addToBag(),
                      icon: Icon(
                        Iconsax.shopping_bag,
                        size: 18.r,
                        color: AppColor.textPrimary,
                      ),
                      label: Text(
                        'Add to Bag',
                        style: GoogleFonts.lato(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColor.textPrimary,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        side: const BorderSide(
                          color: AppColor.border,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => controller.buyNow(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primary,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                      child: Text(
                        'Buy Now',
                        style: GoogleFonts.lato(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColor.textPrimary,
                        ),
                      ),
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
