// ignore_for_file: library_prefixes

import 'package:dio/dio.dart' as DIO;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/config/app_color.dart';
import '../../../data/config/functions/dio_function/app_config.dart';
import '../../../data/config/functions/dio_function/my_dio.dart';
import '../../../data/mixins/skeleton_loading_mixin.dart';
import '../../../routes/app_pages.dart';
import '../models/cart_model.dart';

class BagController extends GetxController with SkeletonLoadingMixin {
  final cartItems = <CartItemModel>[].obs;

  bool get _hasAuth {
    final token = getBox.read(USER_TOKEN);
    final sessionCookie = getBox.read('SESSION_COOKIE');
    return (token != null && token.toString().trim().isNotEmpty) ||
        (sessionCookie != null && sessionCookie.toString().trim().isNotEmpty);
  }

  @override
  void onInit() {
    super.onInit();
    if (!_hasAuth) {
      isLoading.value = false;
    } else {
      isLoading.value = true;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchCart();
    });
  }

  /// 1. GET /cart - Fetch user's cart from API
  Future<void> fetchCart({bool showLoading = true}) async {
    if (showLoading && cartItems.isEmpty) {
      isLoading.value = true;
    }

    if (!_hasAuth) {
      isLoading.value = false;
      return;
    }

    try {
      final response = await dioGet('cart').timeout(
        const Duration(seconds: 8),
        onTimeout: () => DIO.Response(
          requestOptions: DIO.RequestOptions(path: 'cart'),
          statusCode: 408,
          data: {'message': 'Request timed out'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        dynamic rawData = response.data;
        if (rawData is Map && rawData.containsKey('data')) {
          rawData = rawData['data'];
        }
        if (rawData is Map) {
          final cartModel =
              CartModel.fromJson(Map<String, dynamic>.from(rawData));
          cartItems.assignAll(cartModel.items);
        } else if (rawData is List) {
          final items = <CartItemModel>[];
          for (var e in rawData) {
            if (e is Map) {
              items.add(CartItemModel.fromJson(Map<String, dynamic>.from(e)));
            }
          }
          cartItems.assignAll(items);
        }
      }
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  int get totalItemCount {
    int total = 0;
    for (var item in cartItems) {
      total += item.quantity;
    }
    return total;
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

    if (_hasAuth) {
      try {
        await dioPatch(
          endUrl: 'cart/items/${item.id}',
          data: {'qty': newQty},
          isJson: true,
        );
      } catch (_) {}
    }
  }

  /// 3. PATCH /cart/items/{id} - Decrement quantity
  Future<void> decrementQuantity(int index) async {
    final item = cartItems[index];
    final currentQty = item.quantity;
    if (currentQty > 1) {
      final newQty = currentQty - 1;
      item.quantity = newQty;
      cartItems.refresh();

      if (_hasAuth) {
        try {
          await dioPatch(
            endUrl: 'cart/items/${item.id}',
            data: {'qty': newQty},
            isJson: true,
          );
        } catch (_) {}
      }
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

    if (_hasAuth) {
      try {
        await dioDelete('cart/items/${removed.id}');
      } catch (_) {}
    }
  }

  /// 5. POST /cart - Add item to bag
  Future<void> addItemToBag(Map<String, dynamic> item) async {
    final prodId = item['productId']?.toString() ??
        item['id']?.toString() ??
        DateTime.now().millisecondsSinceEpoch.toString();

    String? variantId = item['variantId']?.toString();
    if (variantId == null || variantId.isEmpty) {
      if (item['variants'] is List && (item['variants'] as List).isNotEmpty) {
        final fv = (item['variants'] as List).first;
        if (fv is Map && fv['id'] != null) {
          variantId = fv['id'].toString();
        }
      }
    }
    variantId ??= prodId;

    final existingIndex = cartItems.indexWhere(
      (element) =>
          (element.productId == prodId || element.id == prodId) &&
          (element.variantId == variantId),
    );

    if (existingIndex != -1) {
      incrementQuantity(existingIndex);
    } else {
      double priceVal = 0.0;
      final rawPriceMinor = item['priceMinor'];
      if (rawPriceMinor is num) {
        priceVal = rawPriceMinor / 100.0;
      } else {
        final rawPrice = item['rawPrice'] ?? item['price'];
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
        brand: item['brand']?.toString() ??
            item['brandName']?.toString() ??
            'Alif',
        title:
            item['title']?.toString() ?? item['name']?.toString() ?? 'Product',
        price: priceVal,
        quantity: 1,
        image: item['image']?.toString() ?? '',
      );

      cartItems.add(newItem);

      if (_hasAuth) {
        try {
          final response = await dioPost(
            endUrl: 'cart',
            data: {
              'variantId': variantId,
              'qty': 1,
            },
            isJson: true,
          );
          if (response.statusCode == 200 || response.statusCode == 201) {
            await fetchCart();
          }
        } catch (_) {}
      }
    }
  }

  /// 6. DELETE /cart - Clear whole cart
  Future<void> clearCart() async {
    cartItems.clear();
    if (_hasAuth) {
      try {
        await dioDelete('cart');
      } catch (_) {}
    }
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

    if (!_hasAuth) {
      Get.snackbar(
        'Sign In Required',
        'Please sign in to proceed to checkout',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColor.primary,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      Get.toNamed(Routes.LOGIN);
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
