import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/config/app_color.dart';
import '../../../data/config/functions/dio_function/my_dio.dart';
import '../../../data/mixins/skeleton_loading_mixin.dart';
import '../../bag/controllers/bag_controller.dart';

class MyWishlistController extends GetxController with SkeletonLoadingMixin {
  final wishlistItems = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchWishlist();
  }

  Future<void> fetchWishlist() async {
    initSkeletonLoading();
    try {
      final response = await dioGet('wishlist');
      if (response.statusCode == 200 && response.data != null) {
        dynamic rawData = response.data;
        if (rawData is Map<String, dynamic> && rawData.containsKey('data')) {
          rawData = rawData['data'];
        }
        if (rawData is List) {
          final items = rawData.map<Map<String, dynamic>>((e) {
            final p = (e is Map<String, dynamic> && e.containsKey('product'))
                ? e['product']
                : e;
            final priceMinor = p['priceMinor'] ?? 0;
            final price = (priceMinor / 100.0).toStringAsFixed(2);
            final images = p['images'] as List?;
            final img = (images != null && images.isNotEmpty)
                ? images.first.toString()
                : '';
            return {
              'id': p['id']?.toString() ?? '',
              'title': p['title']?.toString() ?? p['name']?.toString() ?? '',
              'price': '৳$price',
              'originalPrice': '',
              'discount': '',
              'image': img,
              'slug': p['slug']?.toString() ?? '',
              'raw': p,
            };
          }).toList();
          wishlistItems.assignAll(items);
        } else {
          wishlistItems.clear();
        }
      } else {
        wishlistItems.clear();
      }
    } catch (_) {
      wishlistItems.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> removeItem(String id) async {
    wishlistItems.removeWhere((item) => item['id'] == id);
    try {
      await dioDelete('wishlist?productId=$id');
    } catch (_) {}
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
    if (Get.isRegistered<BagController>()) {
      Get.find<BagController>().addItemToBag(item);
    }
    Get.snackbar(
      'Added to Bag',
      '${item['title']} moved to bag',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColor.primary,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }
}
