import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/config/app_color.dart';
import '../../../routes/app_pages.dart';

class BagController extends GetxController {
  final cartItems = <Map<String, dynamic>>[
    {
      'id': 'c1',
      'brand': 'Logitech',
      'title': 'Gaming Mouse 16000 DPI',
      'price': 2999.0,
      'quantity': 1,
      'image': 'https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?q=80&w=400&auto=format&fit=crop',
    },
    {
      'id': 'c2',
      'brand': 'Amazon',
      'title': 'Smart Color Bulb 2 Pack',
      'price': 1499.0,
      'quantity': 2,
      'image': 'https://images.unsplash.com/photo-1550525811-e5869dd03032?q=80&w=400&auto=format&fit=crop',
    },
  ].obs;

  double get subtotal {
    double total = 0;
    for (var item in cartItems) {
      total += (item['price'] as double) * (item['quantity'] as int);
    }
    return total;
  }

  double get deliveryFee => subtotal > 499 || subtotal == 0 ? 0.0 : 49.0;
  double get tax => subtotal * 0.05;
  double get totalAmount => subtotal + deliveryFee + tax;

  void incrementQuantity(int index) {
    cartItems[index]['quantity'] = (cartItems[index]['quantity'] as int) + 1;
    cartItems.refresh();
  }

  void decrementQuantity(int index) {
    final currentQty = cartItems[index]['quantity'] as int;
    if (currentQty > 1) {
      cartItems[index]['quantity'] = currentQty - 1;
      cartItems.refresh();
    } else {
      removeItem(index);
    }
  }

  void removeItem(int index) {
    final removed = cartItems.removeAt(index);
    Get.snackbar(
      'Removed',
      '${removed['title']} removed from bag',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColor.textPrimary,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void addItemToBag(Map<String, dynamic> item) {
    final existingIndex = cartItems.indexWhere(
      (element) => element['id'] == item['id'],
    );
    if (existingIndex != -1) {
      cartItems[existingIndex]['quantity'] =
          (cartItems[existingIndex]['quantity'] as int) + 1;
      cartItems.refresh();
    } else {
      double priceVal = 0.0;
      final rawPrice = item['price'];
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

      cartItems.add({
        'id': item['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
        'brand': item['brand'] ?? 'Brand',
        'title': item['title'] ?? 'Product',
        'price': priceVal > 0 ? priceVal : 999.0,
        'quantity': 1,
        'image': item['image'] ?? '',
      });
    }
  }

  void clearCart() {
    cartItems.clear();
  }

  void proceedToCheckout() {
    if (cartItems.isEmpty) {
      Get.snackbar(
        'Empty Bag',
        'Please add items to your bag before checking out',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColor.error,
        colorText: Colors.white,
      );
      return;
    }

    Get.toNamed(
      Routes.CHECKOUT,
      arguments: {
        'items': List<Map<String, dynamic>>.from(cartItems),
        'subtotal': subtotal,
        'deliveryFee': deliveryFee,
        'tax': tax,
        'totalAmount': totalAmount,
        'isDirectBuy': false,
      },
    );
  }
}
