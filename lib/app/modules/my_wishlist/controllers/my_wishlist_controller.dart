import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/config/app_color.dart';

class MyWishlistController extends GetxController {
  final wishlistItems = <Map<String, dynamic>>[
    {
      'id': 'w1',
      'title': 'Wireless Noise Headphones',
      'price': '₹199.99',
      'originalPrice': '₹249.99',
      'discount': '20% OFF',
      'image': 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=400&auto=format&fit=crop',
    },
    {
      'id': 'w2',
      'title': 'Smart Sports Watch',
      'price': '₹169.99',
      'originalPrice': '₹199.99',
      'discount': '15% OFF',
      'image': 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?q=80&w=400&auto=format&fit=crop',
    },
    {
      'id': 'w3',
      'title': 'Modern L-Shaped Sofa',
      'price': '₹599.99',
      'originalPrice': '₹699.99',
      'discount': '14% OFF',
      'image': 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?q=80&w=400&auto=format&fit=crop',
    },
  ].obs;

  void removeItem(String id) {
    wishlistItems.removeWhere((item) => item['id'] == id);
    Get.snackbar(
      'Removed',
      'Item removed from wishlist',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColor.textPrimary,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void addToBag(Map<String, dynamic> item) {
    Get.snackbar(
      'Added to Bag',
      '${item['title']} moved to bag',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColor.primary,
      colorText: Colors.black,
      duration: const Duration(seconds: 2),
    );
  }
}
