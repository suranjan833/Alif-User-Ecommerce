import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/config/app_color.dart';
import '../../../routes/app_pages.dart';

class SellerDetailsController extends GetxController {
  final seller = <String, dynamic>{}.obs;
  final isFollowing = false.obs;

  final sellerProducts = <Map<String, dynamic>>[
    {
      'id': 'sp1',
      'brand': 'Logitech',
      'title': 'Gaming Mouse 16000 DPI',
      'price': '₹2,999',
      'originalPrice': '₹3,499',
      'image': 'https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?q=80&w=400&auto=format&fit=crop',
    },
    {
      'id': 'sp2',
      'brand': 'JBL',
      'title': 'Flip 6 Portable Speaker',
      'price': '₹8,999',
      'originalPrice': '₹9,999',
      'image': 'https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?q=80&w=400&auto=format&fit=crop',
    },
    {
      'id': 'sp3',
      'brand': 'Amazon',
      'title': 'Smart Color Bulb 2 Pack',
      'price': '₹1,499',
      'originalPrice': '₹1,999',
      'image': 'https://images.unsplash.com/photo-1550525811-e5869dd03032?q=80&w=400&auto=format&fit=crop',
    },
    {
      'id': 'sp4',
      'brand': 'Microsoft',
      'title': 'Wireless Xbox Controller',
      'price': '₹4,499',
      'originalPrice': '₹5,499',
      'image': 'https://images.unsplash.com/photo-1600080972464-8e5f35f63d08?q=80&w=400&auto=format&fit=crop',
    },
  ].obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      seller.value = Map<String, dynamic>.from(args);
    } else {
      seller.value = {
        'name': 'Alif Official Store',
        'rating': 4.9,
        'reviewsCount': '1.8k',
        'joinedDate': 'Member since 2022',
        'location': 'Mumbai, Maharashtra',
        'responseRate': '99%',
        'isVerified': true,
        'avatar': 'https://images.unsplash.com/photo-1560250097-0b93528c311a?q=80&w=200&auto=format&fit=crop',
        'bio': 'Official retailer offering 100% authentic products with brand warranty and fast delivery across India.',
      };
    }
  }

  void toggleFollow() {
    isFollowing.value = !isFollowing.value;
    Get.snackbar(
      isFollowing.value ? 'Following Store' : 'Unfollowed Store',
      isFollowing.value
          ? 'You are now following ${seller['name']}'
          : 'You unfollowed ${seller['name']}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColor.textPrimary,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void openProductDetails(Map<String, dynamic> product) {
    Get.toNamed(Routes.PRODUCT_DETAILS, arguments: product);
  }
}
