import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/config/app_color.dart';
import '../../../data/config/functions/dio_function/my_dio.dart';
import '../../../data/mixins/skeleton_loading_mixin.dart';
import '../../../routes/app_pages.dart';
import '../../bag/controllers/bag_controller.dart';
import '../../home/models/showcase_model.dart';
import '../models/product_details_model.dart';

class ProductDetailsController extends GetxController with SkeletonLoadingMixin {
  final product = Rxn<ProductDetailsModel>();
  final variants = <ProductVariantModel>[].obs;
  final seller = Rxn<ProductSellerModel>();

  final selectedVariantIndex = 0.obs;
  final selectedImageIndex = 0.obs;
  final isWishlisted = false.obs;
  final selectedQuantity = 1.obs;
  final isLoadingDetails = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    _initializeData(args);
  }

  void _initializeData(dynamic args) {
    if (args == null) return;

    if (args is String) {
      fetchProductBySlug(args);
      return;
    }

    if (args is ProductDetailsModel) {
      _setProduct(args);
    } else if (args is ShowcaseProductModel) {
      _setProduct(ProductDetailsModel.fromShowcase(args));
    } else if (args is Map<String, dynamic>) {
      _setProduct(ProductDetailsModel.fromJson(args));
    } else {
      try {
        final map = (args as dynamic).toJson() as Map<String, dynamic>;
        _setProduct(ProductDetailsModel.fromJson(map));
      } catch (_) {
        return;
      }
    }

    final currentSlug = product.value?.slug;
    if (currentSlug != null && currentSlug.isNotEmpty) {
      fetchProductBySlug(currentSlug);
    }
  }

  void _setProduct(ProductDetailsModel model) {
    product.value = model;
    variants.assignAll(model.variants);
    seller.value = model.seller;
    isWishlisted.value = model.isFavorite;

    if (selectedVariantIndex.value >= model.variants.length) {
      selectedVariantIndex.value = 0;
    }
  }

  Future<void> fetchProductBySlug(String slug) async {
    try {
      isLoadingDetails.value = true;
      // 1. Try GET /catalog/products/{slug}
      final response = await dioGet('catalog/products/$slug');
      if (response.statusCode == 200 && response.data != null) {
        dynamic rawData = response.data;
        if (rawData is Map<String, dynamic> && rawData.containsKey('data')) {
          rawData = rawData['data'];
        }
        if (rawData is Map<String, dynamic>) {
          _setProduct(ProductDetailsModel.fromJson(rawData));
          return;
        }
      }

      // 2. Fallback to GET /catalog/search if slug route is unreachable
      final searchResponse = await dioGet('catalog/search');
      if (searchResponse.statusCode == 200 && searchResponse.data != null) {
        dynamic rawData = searchResponse.data;
        if (rawData is Map<String, dynamic> && rawData.containsKey('data')) {
          rawData = rawData['data'];
        }
        List? prods;
        if (rawData is Map<String, dynamic> && rawData.containsKey('products')) {
          prods = rawData['products'] as List?;
        }
        if (prods != null) {
          final found = prods.firstWhereOrNull(
            (p) => p is Map && (p['slug'] == slug || p['id'] == slug),
          );
          if (found != null && found is Map<String, dynamic>) {
            _setProduct(ProductDetailsModel.fromJson(found));
          }
        }
      }
    } catch (_) {
    } finally {
      isLoadingDetails.value = false;
    }
  }

  ProductVariantModel? get selectedVariant {
    if (variants.isNotEmpty && selectedVariantIndex.value < variants.length) {
      return variants[selectedVariantIndex.value];
    }
    return null;
  }

  List<String> get imagesList {
    final sv = selectedVariant;
    if (sv != null && sv.images.isNotEmpty) {
      return sv.images;
    }
    final p = product.value;
    if (p != null && p.images.isNotEmpty) {
      return p.images;
    }
    return [
      'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?q=80&w=400&auto=format&fit=crop',
    ];
  }

  double get activePriceValue {
    final sv = selectedVariant;
    if (sv != null && sv.price > 0) {
      return sv.price;
    }
    return product.value?.price ?? 0.0;
  }

  String get activePriceFormatted {
    final sv = selectedVariant;
    if (sv != null && sv.price > 0) {
      return sv.priceFormatted;
    }
    return product.value?.priceFormatted ?? '৳0.00';
  }

  String? get activeOriginalPriceFormatted {
    final sv = selectedVariant;
    if (sv != null && sv.originalPriceFormatted != null) {
      return sv.originalPriceFormatted;
    }
    return product.value?.originalPriceFormatted;
  }

  String get activeDiscount {
    final sv = selectedVariant;
    if (sv != null && sv.discount.isNotEmpty) {
      return sv.discount;
    }
    return product.value?.discount ?? '';
  }

  int? get activeStock {
    final sv = selectedVariant;
    if (sv != null && sv.stockQty != null) {
      return sv.stockQty;
    }
    return product.value?.stockQty;
  }

  String? get activeSku => selectedVariant?.sku;

  bool get isOpenBoxDelivery => product.value?.openBoxDelivery ?? false;

  void selectVariant(int index) {
    if (index >= 0 && index < variants.length) {
      selectedVariantIndex.value = index;
      selectedQuantity.value = 1;
      selectedImageIndex.value = 0;
    }
  }

  void incrementQuantity() {
    final maxStock = activeStock ?? 99;
    if (selectedQuantity.value < maxStock) {
      selectedQuantity.value++;
    } else {
      Get.snackbar(
        'Maximum Stock Reached',
        'Only $maxStock units available',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black87,
        colorText: Colors.white,
      );
    }
  }

  void decrementQuantity() {
    if (selectedQuantity.value > 1) {
      selectedQuantity.value--;
    }
  }

  Future<void> toggleWishlist() async {
    isWishlisted.value = !isWishlisted.value;
    final p = product.value;
    final productId = p?.id ?? '';

    Get.snackbar(
      isWishlisted.value ? 'Added to Wishlist' : 'Removed from Wishlist',
      isWishlisted.value
          ? '${p?.name ?? 'Item'} saved to your wishlist'
          : 'Item removed from wishlist',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColor.textPrimary,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );

    if (productId.isNotEmpty) {
      try {
        if (isWishlisted.value) {
          await dioPost(
            endUrl: 'wishlist',
            data: {'productId': productId},
            isJson: true,
          );
        } else {
          await dioDelete('wishlist?productId=$productId');
        }
      } catch (_) {}
    }
  }

  void addToBag() {
    final p = product.value;
    if (p == null) return;

    if (!Get.isRegistered<BagController>()) {
      Get.put(BagController());
    }
    final bagCtrl = Get.find<BagController>();

    final sv = selectedVariant;
    final itemPayload = <String, dynamic>{
      'id': p.id,
      'productId': p.id,
      'variantId': sv?.id,
      'variantLabel': sv?.label,
      'brand': p.displayBrand,
      'title': p.name,
      'price': activePriceValue,
      'image': imagesList.first,
    };

    for (int i = 0; i < selectedQuantity.value; i++) {
      bagCtrl.addItemToBag(itemPayload);
    }

    Get.snackbar(
      'Added to Bag',
      '${selectedQuantity.value}x ${p.name} added to your shopping bag',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColor.primary,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void buyNow() {
    final p = product.value;
    if (p == null) return;

    final priceVal = activePriceValue;
    final qty = selectedQuantity.value;
    final subtotal = priceVal * qty;
    final deliveryFee = subtotal > 499 ? 0.0 : 49.0;
    final tax = subtotal * 0.05;
    final totalAmount = subtotal + deliveryFee + tax;

    final sv = selectedVariant;
    final directItem = {
      'id': p.id.isNotEmpty
          ? p.id
          : DateTime.now().millisecondsSinceEpoch.toString(),
      'productId': p.id,
      'variantId': sv?.id,
      'variantLabel': sv?.label,
      'brand': p.displayBrand,
      'title': p.name,
      'price': priceVal,
      'quantity': qty,
      'image': imagesList.first,
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
    final s = seller.value;
    if (s != null) {
      Get.toNamed(Routes.SELLER_DETAILS, arguments: s.toJson());
    } else {
      Get.toNamed(Routes.SELLER_DETAILS);
    }
  }
}

