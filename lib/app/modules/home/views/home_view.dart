import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../../../data/config/app_color.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: controller.currentCategory['bgColor'] as Color,
        body: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // 1. Location Header (scrolls away)
              SliverToBoxAdapter(
                child: GestureDetector(
                  onTap: () => _showLocationBottomSheet(context),
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 16.w,
                      right: 16.w,
                      top: 10.h,
                      bottom: 8.h,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Iconsax.location5,
                          size: 20.r,
                          color: AppColor.textPrimary,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Obx(
                            () => Text(
                              controller.currentLocation.value,
                              style: GoogleFonts.lato(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColor.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 22.r,
                          color: AppColor.textPrimary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // 2. Sticky Header (Search Bar + Category Tabs Bar)
              SliverPersistentHeader(
                pinned: true,
                delegate: _StickyHeaderDelegate(
                  height: 135.h,
                  child: Obx(
                    () => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      color: controller.currentCategory['bgColor'] as Color,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 6.h),
                          // Search Bar (Dynamic Hint based on Category)
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Container(
                              height: 46.h,
                              padding: EdgeInsets.symmetric(horizontal: 14.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24.r),
                                border: Border.all(
                                  color: const Color(0xFFE2E8F0),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.04),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Iconsax.search_normal_1,
                                    color: AppColor.textSecondary,
                                    size: 20.r,
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Text(
                                      controller.currentCategory['searchHint']
                                          as String,
                                      style: GoogleFonts.lato(
                                        fontSize: 14.sp,
                                        color: AppColor.textSecondary,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Iconsax.edit_2,
                                    color: AppColor.textSecondary,
                                    size: 18.r,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 12.h),

                          // Category Horizontal Filter Tabs
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            physics: const BouncingScrollPhysics(),
                            child: Row(
                              children: List.generate(
                                controller.categories.length,
                                (index) => _buildCategoryTab(index),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // 3. Scrollable Body Content
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 12.h),

                    // 4. Hero Banner Card (Dynamic per Category)
                    Obx(
                      () => Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: double.infinity,
                          height: 225.h,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18.r),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    (controller.currentCategory['accentColor']
                                            as Color)
                                        .withValues(alpha: 0.12),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              // Banner Background Image
                              Image.network(
                                controller.currentCategory['bannerImage']
                                    as String,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      color: const Color(0xFFEADCC9),
                                      child: Center(
                                        child: Icon(
                                          Iconsax.image,
                                          size: 48.r,
                                          color: AppColor.textSecondary,
                                        ),
                                      ),
                                    ),
                              ),
                              // Semi-gradient Overlay for high text readability
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      (controller.currentCategory['bgColor']
                                              as Color)
                                          .withValues(alpha: 0.92),
                                      (controller.currentCategory['bgColor']
                                              as Color)
                                          .withValues(alpha: 0.5),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                              // Text & Call to Action
                              Positioned(
                                left: 20.w,
                                top: 22.h,
                                bottom: 22.h,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      controller.currentCategory['bannerTitle']
                                          as String,
                                      style: GoogleFonts.montserrat(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 0.8,
                                        color:
                                            controller
                                                    .currentCategory['accentColor']
                                                as Color,
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      controller
                                              .currentCategory['bannerSubtitle']
                                          as String,
                                      style: GoogleFonts.playfairDisplay(
                                        fontSize: 16.sp,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w600,
                                        color:
                                            controller
                                                    .currentCategory['subtitleColor']
                                                as Color,
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16.w,
                                        vertical: 8.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            controller
                                                    .currentCategory['buttonColor']
                                                as Color,
                                        borderRadius: BorderRadius.circular(
                                          20.r,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                (controller.currentCategory['buttonColor']
                                                        as Color)
                                                    .withValues(alpha: 0.35),
                                            blurRadius: 8,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Explore Now',
                                            style: GoogleFonts.lato(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(width: 4.w),
                                          Icon(
                                            Icons.chevron_right_rounded,
                                            color: Colors.white,
                                            size: 16.r,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // 5. Suggested for You Section (Product Grid matching Image 2)
                    _buildSuggestedProductsSection(),

                    SizedBox(height: 24.h),

                    // 6. Category Showcase Grid Cards
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: [
                          _buildShowcaseCard(
                            title: 'Bath & Body',
                            subtitle:
                                'Self-care essentials\nfor a fresh routine',
                            bgColor: const Color(0xFFD4EFE8),
                            imageUrl: 'https://images.unsplash.com/photo-1556228720-195a672e8a03?q=80&w=400&auto=format&fit=crop',
                          ),
                          SizedBox(width: 12.w),
                          _buildShowcaseCard(
                            title: 'Makeup',
                            subtitle: 'Beauty essentials\nfor every look',
                            bgColor: const Color(0xFFFDE2E4),
                            imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=400&auto=format&fit=crop',
                          ),
                          SizedBox(width: 12.w),
                          _buildShowcaseCard(
                            title: 'Fragrance &\nDeodorant',
                            subtitle: 'Fresh scents that\nlast all day',
                            bgColor: const Color(0xFFE6E1FA),
                            imageUrl: 'https://images.unsplash.com/photo-1592945403244-b3fbafd7f539?q=80&w=400&auto=format&fit=crop',
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // 7. Level It Up Promo Banner
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFF232936),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.r),
                              child: Image.network(
                                'https://images.unsplash.com/photo-1489987707025-afc232f7ea0f?q=80&w=400&auto=format&fit=crop',
                                width: 100.w,
                                height: 80.h,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      width: 100.w,
                                      height: 80.h,
                                      color: Colors.grey.shade700,
                                      child: const Icon(
                                        Iconsax.shopping_bag,
                                        color: Colors.white,
                                      ),
                                    ),
                              ),
                            ),
                            SizedBox(width: 14.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const SizedBox(),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10.w,
                                          vertical: 4.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFF9900),
                                          borderRadius: BorderRadius.circular(
                                            6.r,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'LEVEL IT UP',
                                              style: GoogleFonts.lato(
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.w900,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(width: 2.w),
                                            Icon(
                                              Icons.north_east_rounded,
                                              size: 12.r,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    'BUY 3\nGET EXTRA\n10% OFF',
                                    style: GoogleFonts.montserrat(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w900,
                                      color: const Color(0xFFFFB800),
                                      height: 1.1,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                      vertical: 3.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.15,
                                      ),
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                    child: Text(
                                      'Offer auto-applies at checkout',
                                      style: GoogleFonts.lato(
                                        fontSize: 9.sp,
                                        color: Colors.white.withValues(
                                          alpha: 0.9,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // 8. Top Brands Section Header
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Top Brands',
                            style: GoogleFonts.lato(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w800,
                              color: AppColor.textPrimary,
                            ),
                          ),
                          Text(
                            'See All',
                            style: GoogleFonts.lato(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColor.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 14.h),

                    // Top Brands Logo Cards Horizontal Scroll
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: controller.topBrands
                            .map((brand) => _buildBrandCard(brand))
                            .toList(),
                      ),
                    ),

                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestedProductsSection() {
    return Obx(() {
      final products =
          controller.currentCategory['products']
              as List<Map<String, dynamic>>? ??
          [];

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Suggested for You',
                  style: GoogleFonts.lato(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColor.textPrimary,
                  ),
                ),
                Text(
                  'See All',
                  style: GoogleFonts.lato(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColor.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 14.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: List.generate(
                products.length,
                (index) => _buildProductCard(products[index], index),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildProductCard(Map<String, dynamic> product, int index) {
    final isFav = product['isFavorite'] as bool? ?? false;

    return Container(
      width: 155.w,
      margin: EdgeInsets.only(right: 14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Favorite Button top right
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () => controller.toggleFavorite(index),
                    child: Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Icon(
                        isFav ? Iconsax.heart5 : Iconsax.heart,
                        size: 16.r,
                        color: isFav ? Colors.red : AppColor.textSecondary,
                      ),
                    ),
                  ),
                ),

                // Product Image
                Center(
                  child: Image.network(
                    product['image'] as String,
                    height: 90.h,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 90.h,
                      color: Colors.grey.shade100,
                      child: Icon(
                        Iconsax.image,
                        size: 32.r,
                        color: AppColor.textSecondary,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10.h),

                // Title
                Text(
                  product['title'] as String,
                  style: GoogleFonts.lato(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColor.textPrimary,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: 4.h),

                // Discount Badge
                Text(
                  product['discount'] as String,
                  style: GoogleFonts.lato(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF15803D),
                  ),
                ),

                SizedBox(height: 4.h),

                // Price and Original Price
                Row(
                  children: [
                    Text(
                      product['price'] as String,
                      style: GoogleFonts.lato(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w900,
                        color: AppColor.textPrimary,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      product['originalPrice'] as String,
                      style: GoogleFonts.lato(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColor.textHint,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Plus Add Button bottom right
          Positioned(
            right: 10.w,
            bottom: 10.h,
            child: Container(
              width: 32.w,
              height: 32.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B),
                borderRadius: BorderRadius.circular(10.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFF59E0B).withValues(alpha: 0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(Icons.add_rounded, color: Colors.white, size: 20.r),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTab(int index) {
    final category = controller.categories[index];
    final isSelected = controller.selectedCategoryIndex.value == index;

    IconData getIcon(String iconName) {
      switch (iconName) {
        case 'all':
          return Iconsax.shopping_bag;
        case 'furniture':
          return Iconsax.lamp;
        case 'electronics':
          return Iconsax.headphone;
        case 'clothing':
          return Iconsax.discount_shape;
        case 'cosmetics':
          return Iconsax.magic_star;
        default:
          return Iconsax.category;
      }
    }

    return GestureDetector(
      onTap: () => controller.selectCategory(index),
      child: Container(
        margin: EdgeInsets.only(right: 20.w),
        child: Column(
          children: [
            Container(
              width: 44.w,
              height: 44.h,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColor.textPrimary.withValues(alpha: 0.05)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  getIcon(category['icon']),
                  size: 22.r,
                  color: isSelected
                      ? AppColor.textPrimary
                      : AppColor.textSecondary,
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              category['name'],
              style: GoogleFonts.lato(
                fontSize: 12.sp,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? AppColor.textPrimary
                    : AppColor.textSecondary,
              ),
            ),
            SizedBox(height: 4.h),
            Container(
              height: 2.h,
              width: 24.w,
              decoration: BoxDecoration(
                color: isSelected ? AppColor.textPrimary : Colors.transparent,
                borderRadius: BorderRadius.circular(1.r),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShowcaseCard({
    required String title,
    required String subtitle,
    required Color bgColor,
    required String imageUrl,
  }) {
    return Container(
      width: 155.w,
      height: 230.h,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.lato(
              fontSize: 18.sp,
              fontWeight: FontWeight.w900,
              color: AppColor.textPrimary,
              height: 1.1,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            subtitle,
            style: GoogleFonts.lato(
              fontSize: 11.sp,
              fontWeight: FontWeight.w400,
              color: AppColor.textSecondary,
              height: 1.2,
            ),
          ),
          const Spacer(),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.network(
                imageUrl,
                height: 100.h,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Iconsax.image,
                  size: 48.r,
                  color: AppColor.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandCard(Map<String, String> brand) {
    return Container(
      width: 120.w,
      height: 90.h,
      margin: EdgeInsets.only(right: 12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Image.network(
            brand['logo']!,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Text(
              brand['name']!,
              style: GoogleFonts.montserrat(
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                color: AppColor.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  void _showLocationBottomSheet(BuildContext context) {
    final textController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            top: 12.h,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: 16.h),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),

              // Title & Close Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Location',
                    style: GoogleFonts.montserrat(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColor.textPrimary,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close_rounded,
                      size: 22.r,
                      color: AppColor.textSecondary,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),

              SizedBox(height: 4.h),
              Text(
                'Select your delivery spot to view available products.',
                style: GoogleFonts.lato(
                  fontSize: 12.sp,
                  color: AppColor.textSecondary,
                ),
              ),

              SizedBox(height: 20.h),

              // Option 1: Fetch GPS Location Button
              GestureDetector(
                onTap: () async {
                  await controller.fetchGPSLocation();
                  if (context.mounted) Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F52BA).withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: const Color(0xFF0F52BA).withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: const BoxDecoration(
                          color: Color(0xFF0F52BA),
                          shape: BoxShape.circle,
                        ),
                        child: Obx(
                          () => controller.isFetchingLocation.value
                              ? SizedBox(
                                  width: 18.r,
                                  height: 18.r,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Icon(
                                  Iconsax.gps,
                                  color: Colors.white,
                                  size: 18.r,
                                ),
                        ),
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Fetch Current Location',
                              style: GoogleFonts.lato(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF0F52BA),
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'Using GPS for precise location',
                              style: GoogleFonts.lato(
                                fontSize: 11.sp,
                                color: AppColor.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: const Color(0xFF0F52BA),
                        size: 20.r,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              // Divider with OR
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Text(
                      'OR',
                      style: GoogleFonts.lato(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColor.textHint,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                ],
              ),

              SizedBox(height: 16.h),

              // Option 2: Type Location Manually
              Text(
                'Type Location Manually',
                style: GoogleFonts.lato(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColor.textPrimary,
                ),
              ),

              SizedBox(height: 8.h),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Iconsax.location,
                      color: AppColor.textSecondary,
                      size: 18.r,
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: TextField(
                        controller: textController,
                        style: GoogleFonts.lato(
                          fontSize: 13.sp,
                          color: AppColor.textPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter area, city or pin code...',
                          hintStyle: GoogleFonts.lato(
                            fontSize: 13.sp,
                            color: AppColor.textHint,
                          ),
                          border: InputBorder.none,
                        ),
                        onSubmitted: (value) {
                          if (value.trim().isNotEmpty) {
                            controller.setLocation(value.trim());
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (textController.text.trim().isNotEmpty) {
                          controller.setLocation(textController.text.trim());
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.textPrimary,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          'Save',
                          style: GoogleFonts.lato(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 18.h),

              // Saved Locations Header
              Text(
                'Saved Addresses',
                style: GoogleFonts.lato(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColor.textPrimary,
                ),
              ),

              SizedBox(height: 10.h),

              // Address 1
              _buildSavedAddressTile(
                icon: Iconsax.home,
                title: 'Home',
                address: 'Bakali coloni, Vijay Nagar, Bhuj, Gujarat',
                onTap: () {
                  controller.setLocation(
                    'Bakali coloni, Vijay Nagar, Bhuj, Gujar...',
                  );
                  Navigator.pop(context);
                },
              ),

              SizedBox(height: 8.h),

              // Address 2
              _buildSavedAddressTile(
                icon: Iconsax.briefcase,
                title: 'Work',
                address: 'Commercial Hub, Ring Road, Bhuj, Gujarat',
                onTap: () {
                  controller.setLocation(
                    'Commercial Hub, Ring Road, Bhuj, Gujar...',
                  );
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSavedAddressTile({
    required IconData icon,
    required String title,
    required String address,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20.r, color: AppColor.textPrimary),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.lato(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColor.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    address,
                    style: GoogleFonts.lato(
                      fontSize: 11.sp,
                      color: AppColor.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 18.r,
              color: AppColor.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  _StickyHeaderDelegate({required this.child, required this.height});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant _StickyHeaderDelegate oldDelegate) {
    return oldDelegate.height != height || oldDelegate.child != child;
  }
}
