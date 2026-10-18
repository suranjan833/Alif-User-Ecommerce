import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/config/app_color.dart';
import '../../../data/config/functions/dio_function/my_dio.dart';
import '../../../data/mixins/skeleton_loading_mixin.dart';
import '../../../routes/app_pages.dart';
import '../models/cart_model.dart';

class BagController extends GetxController with SkeletonLoadingMixin {
  final cartItems = <CartItemModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchCart();
    });
  }

  /// 1. GET /cart - Fetch user's cart from API
  Future<void> fetchCart() async {
    initSkeletonLoading();
    try {
      final response = await dioGet('cart');
      if (response.statusCode == 200 && response.data != null) {
        dynamic rawData = response.data;
        if (rawData is Map<String, dynamic> && rawData.containsKey('data')) {
          rawData = rawData['data'];
        }
        if (rawData is Map<String, dynamic>) {
          final cartModel = CartModel.fromJson(rawData);
          cartItems.assignAll(cartModel.items);
        } else if (rawData is List) {
          cartItems.assignAll(
            rawData
                .whereType<Map<String, dynamic>>()
                .map((e) => CartItemModel.fromJson(e))
                .toList(),
          );
        } else {
          cartItems.clear();
        }
      } else {
        cartItems.clear();
      }
    } catch (_) {
      cartItems.clear();
    } finally {
      isLoading.value = false;
    }
  }

  double get subtotal {
    double total = 0;
    for (var item in cartItems) {
      total += item.price * item.quantity;
    }
    return total;
  }

  double get deliveryFee => subtotal > 499 || subtotal == 0 ? 0.0 : 49.0;
  double get tax => subtotal * 0.05;
  double get totalAmount => subtotal + deliveryFee + tax;

  /// 2. PATCH /cart/items/{id} - Increment quantity
  Future<void> incrementQuantity(int index) async {
    final item = cartItems[index];
    final newQty = item.quantity + 1;
    item.quantity = newQty;
    cartItems.refresh();

    try {
      await dioPatch(
        endUrl: 'cart/items/${item.id}',
        data: {'qty': newQty},
        isJson: true,
      );
    } catch (_) {}
  }

  /// 3. PATCH /cart/items/{id} - Decrement quantity
  Future<void> decrementQuantity(int index) async {
    final item = cartItems[index];
    final currentQty = item.quantity;
    if (currentQty > 1) {
      final newQty = currentQty - 1;
      item.quantity = newQty;
      cartItems.refresh();

      try {
        await dioPatch(
          endUrl: 'cart/items/${item.id}',
          data: {'qty': newQty},
          isJson: true,
        );
      } catch (_) {}
    } else {
      removeItem(index);
    }
  }

  /// 4. DELETE /cart/items/{id} - Remove single item
  Future<void> removeItem(int index) async {
    final removed = cartItems.removeAt(index);
    Get.snackbar(
      'Removed',
      '${removed.title} removed from bag',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColor.textPrimary,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );

    try {
      await dioDelete('cart/items/${removed.id}');
    } catch (_) {}
  }

  /// 5. POST /cart - Add item to bag
  Future<void> addItemToBag(Map<String, dynamic> item) async {
    final prodId = item['productId']?.toString() ??
        item['id']?.toString() ??
        DateTime.now().millisecondsSinceEpoch.toString();
    final variantId = item['variantId']?.toString();
    final existingIndex = cartItems.indexWhere(
      (element) =>
          (element.productId == prodId || element.id == prodId) &&
          (variantId == null || element.variantId == variantId),
    );

    if (existingIndex != -1) {
      incrementQuantity(existingIndex);
    } else {
      double priceVal = 0.0;
      final rawPriceMinor = item['priceMinor'];
      if (rawPriceMinor is num) {
        priceVal = rawPriceMinor / 100.0;
      } else {
        final rawPrice = item['price'];
        if (rawPrice is num) {
          priceVal = rawPrice.toDouble();
        } else if (rawPrice is String) {
          priceVal =
              double.tryParse(
                rawPrice
                    .replaceAll('৳', '')
                    .replaceAll('₹', '')
                    .replaceAll('\$', '')
                    .replaceAll(',', '')
                    .trim(),
              ) ??
              0.0;
        }
      }

      final newItem = CartItemModel(
        id: prodId,
        productId: prodId,
        variantId: variantId,
        brand: item['brand']?.toString() ?? 'Alif',
        title: item['title']?.toString() ?? item['name']?.toString() ?? 'Product',
        price: priceVal,
        quantity: 1,
        image: item['image']?.toString() ?? '',
      );

      cartItems.add(newItem);

      try {
        await dioPost(
          endUrl: 'cart',
          data: {
            'productId': prodId,
            if (newItem.variantId != null) 'variantId': newItem.variantId,
            'qty': 1,
          },
          isJson: true,
        );
      } catch (_) {}
    }
  }

  /// 6. DELETE /cart - Clear whole cart
  Future<void> clearCart() async {
    cartItems.clear();
    try {
      await dioDelete('cart');
    } catch (_) {}
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
        'items': cartItems.map((e) => e.toJson()).toList(),
        'subtotal': subtotal,
        'deliveryFee': deliveryFee,
        'tax': tax,
        'totalAmount': totalAmount,
        'isDirectBuy': false,
      },
    );
  }
}
