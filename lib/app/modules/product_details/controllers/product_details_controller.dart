import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/config/app_color.dart';
import '../../../routes/app_pages.dart';

import '../../bag/controllers/bag_controller.dart';

class ProductDetailsController extends GetxController {
  final product = <String, dynamic>{}.obs;
  final isWishlisted = false.obs;
  final selectedQuantity = 1.obs;

  final seller = <String, dynamic>{
    'name': 'Alif Official Store',
    'rating': 4.9,
    'reviewsCount': '1.8k',
    'joinedDate': 'Member since 2022',
    'location': 'Mumbai, Maharashtra',
    'responseRate': '99%',
    'isVerified': true,
    'avatar': 'https://images.unsplash.com/photo-1560250097-0b93528c311a?q=80&w=200&auto=format&fit=crop',
    'bio': 'Official retailer offering 100% authentic products with brand warranty and fast delivery across India.',
  }.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      product.value = Map<String, dynamic>.from(args);
    } else {
      product.value = {
        'id': 'p101',
        'brand': 'Logitech',
        'title': 'Gaming Mouse 16000 DPI High Precision Sensor',
        'price': '₹2,999',
        'originalPrice': '₹3,499',
        'discount': '14.29% OFF',
        'rating': 4.8,
        'reviews': 342,
        'image': 'https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?q=80&w=400&auto=format&fit=crop',
        'description': 'Experience ultra-fast gaming accuracy with 16000 DPI high-precision optical sensor. Ergonomic grip designed for long gaming sessions, customizable RGB lighting, and programmable macro buttons.',
      };
    }
  }

  void incrementQuantity() {
    selectedQuantity.value++;
  }

  void decrementQuantity() {
    if (selectedQuantity.value > 1) {
      selectedQuantity.value--;
    }
  }

  void toggleWishlist() {
    isWishlisted.value = !isWishlisted.value;
    Get.snackbar(
      isWishlisted.value ? 'Added to Wishlist' : 'Removed from Wishlist',
      isWishlisted.value
          ? '${product['title']} saved to your wishlist'
          : 'Item removed from wishlist',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColor.textPrimary,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void addToBag() {
    if (!Get.isRegistered<BagController>()) {
      Get.put(BagController());
    }
    final bagCtrl = Get.find<BagController>();
    for (int i = 0; i < selectedQuantity.value; i++) {
      bagCtrl.addItemToBag(product);
    }

    Get.snackbar(
      'Added to Bag',
      '${selectedQuantity.value}x ${product['title']} added to your shopping bag',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColor.primary,
      colorText: Colors.black,
      duration: const Duration(seconds: 2),
    );
  }

  void buyNow() {
    double priceVal = 0.0;
    final rawPrice = product['price'];
    if (rawPrice is num) {
      priceVal = rawPrice.toDouble();
    } else if (rawPrice is String) {
      priceVal =
          double.tryParse(
            rawPrice
                .replaceAll('₹', '')
                .replaceAll('\$', '')
                .replaceAll(',', '')
                .trim(),
          ) ??
          0.0;
    }
    if (priceVal <= 0) priceVal = 999.0;

    final qty = selectedQuantity.value;
    final subtotal = priceVal * qty;
    final deliveryFee = subtotal > 499 ? 0.0 : 49.0;
    final tax = subtotal * 0.05;
    final totalAmount = subtotal + deliveryFee + tax;

    final directItem = {
      'id': product['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      'brand': product['brand'] ?? 'Brand',
      'title': product['title'] ?? 'Product',
      'price': priceVal,
      'quantity': qty,
      'image': product['image'] ?? '',
    };

    Get.toNamed(
      Routes.CHECKOUT,
      arguments: {
        'items': [directItem],
        'subtotal': subtotal,
        'deliveryFee': deliveryFee,
        'tax': tax,
        'totalAmount': totalAmount,
        'isDirectBuy': true,
      },
    );
  }

  void openSellerDetails() {
    Get.toNamed(Routes.SELLER_DETAILS, arguments: seller);
  }
}
