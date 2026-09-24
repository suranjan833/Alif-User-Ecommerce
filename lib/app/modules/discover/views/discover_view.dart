import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../../../data/config/app_color.dart';
import '../controllers/discover_controller.dart';

class DiscoverView extends GetView<DiscoverController> {
  const DiscoverView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<DiscoverController>()) {
      Get.put(DiscoverController());
    }

    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Header: Discover Title + Bag Icon
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Discover',
                      style: GoogleFonts.inter(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.textPrimary,
                      ),
                    ),
                    Icon(
                      Iconsax.shopping_bag,
                      size: 24.r,
                      color: AppColor.textPrimary,
                    ),
                  ],
                ),
              ),

              // 2. Top Sellers Horizontal Stories Bar
              Obx(
                () => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: List.generate(
                      controller.sellers.length,
                      (index) =>
                          _buildSellerStoryItem(controller.sellers[index]),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16.h),
              Divider(height: 1.h, color: const Color(0xFFEEEEEE)),
              SizedBox(height: 16.h),

              // 3. Staggered Feed Posts (2 Columns)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Obx(
                  () => Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Column Posts (Index 0, 2...)
                      Expanded(
                        child: Column(
                          children: [
                            if (controller.posts.isNotEmpty)
                              _buildPostCard(controller.posts[0], 0),
                            if (controller.posts.length > 2) ...[
                              SizedBox(height: 16.h),
                              _buildPostCard(controller.posts[2], 2),
                            ],
                          ],
                        ),
                      ),
                      SizedBox(width: 14.w),
                      // Right Column Posts (Index 1, 3...)
                      Expanded(
                        child: Column(
                          children: [
                            if (controller.posts.length > 1)
                              _buildPostCard(controller.posts[1], 1),
                            if (controller.posts.length > 3) ...[
                              SizedBox(height: 16.h),
                              _buildPostCard(controller.posts[3], 3),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSellerStoryItem(Map<String, dynamic> seller) {
    return Container(
      margin: EdgeInsets.only(right: 16.w),
      child: Column(
        children: [
          // Gradient Ring Container
          Container(
            padding: EdgeInsets.all(2.5.w),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFA8C16),
                  Color(0xFFF5222D),
                  Color(0xFF722ED1),
                ],
              ),
            ),
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                radius: 28.r,
                backgroundImage: NetworkImage(seller['avatar'] as String),
                backgroundColor: Colors.grey.shade200,
              ),
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            seller['username'] as String,
            style: GoogleFonts.lato(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: AppColor.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post, int index) {
    final hasOverlayText = (post['overlayText'] as String? ?? '').isNotEmpty;
    final isLiked = post['isLiked'] as bool? ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Media Card
        Container(
          width: double.infinity,
          height: index == 0
              ? 260.h
              : index == 1
              ? 220.h
              : index == 2
              ? 230.h
              : 270.h,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: Colors.black,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Main Image
              Image.network(
                post['image'] as String,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey.shade900,
                  child: Center(
                    child: Icon(
                      Iconsax.image,
                      size: 32.r,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),
              ),

              // Bottom Gradient Overlay for text readability
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 90.h,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.8),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // Center Banner Text (e.g. "NEXT-LEVEL DESIGN.")
              if (hasOverlayText)
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Text(
                      post['overlayText'] as String,
                      style: GoogleFonts.montserrat(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 0.8,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

              // Title at bottom of card
              Positioned(
                left: 12.w,
                right: 12.w,
                bottom: 12.h,
                child: Text(
                  post['title'] as String,
                  style: GoogleFonts.lato(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 8.h),

        // Seller Info & Likes Row under card
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Seller Info (Avatar + Name)
            Expanded(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 10.r,
                    backgroundImage: NetworkImage(
                      post['sellerAvatar'] as String,
                    ),
                    backgroundColor: Colors.grey.shade200,
                  ),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      post['sellerName'] as String,
                      style: GoogleFonts.lato(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColor.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // Likes Button
            GestureDetector(
              onTap: () => controller.toggleLike(index),
              child: Row(
                children: [
                  Icon(
                    isLiked ? Iconsax.heart5 : Iconsax.heart,
                    size: 14.r,
                    color: isLiked ? Colors.red : AppColor.textPrimary,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '${post['likes']}',
                    style: GoogleFonts.lato(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColor.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
