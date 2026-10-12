import 'package:get/get.dart';

import '../../../data/config/functions/dio_function/my_dio.dart';
import '../models/product_model.dart';

class CategoryProductsController extends GetxController {
  final categoryName = 'Electronics'.obs;
  final categoryImage = ''.obs;
  final categorySlug = ''.obs;

  final selectedSubCategoryIndex = 0.obs;
  final wishlistedProductIds = <String>{}.obs;

  final subCategories = <Map<String, dynamic>>[
    {
      'id': 'all',
      'name': 'All',
      'icon': 'https://cdn-icons-png.flaticon.com/512/3081/3081986.png',
    },
    {
      'id': 'cameras',
      'name': 'Cameras &\nSecurity',
      'icon': 'https://cdn-icons-png.flaticon.com/512/2950/2950711.png',
    },
    {
      'id': 'computers',
      'name': 'Computers\n& Audio',
      'icon': 'https://cdn-icons-png.flaticon.com/512/3067/3067257.png',
    },
    {
      'id': 'gaming',
      'name': 'Gaming\nConsoles',
      'icon': 'https://cdn-icons-png.flaticon.com/512/1410/1410332.png',
    },
    {
      'id': 'mobile',
      'name': 'Mobile &\nAccessories',
      'icon': 'https://cdn-icons-png.flaticon.com/512/644/644458.png',
    },
    {
      'id': 'appliances',
      'name': 'Small Home\nAppliances',
      'icon': 'https://cdn-icons-png.flaticon.com/512/3076/3076042.png',
    },
    {
      'id': 'smart_home',
      'name': 'Smart Home\nDevices',
      'icon': 'https://cdn-icons-png.flaticon.com/512/2933/2933245.png',
    },
  ].obs;

  final allProducts = <ProductModel>[].obs;

  static final List<ProductModel> fallbackProducts = [
    ProductModel(
      id: 'p1',
      brand: 'Amazon',
      title: 'Smart Color Bulb 2 Pack',
      discount: '20.01% OFF',
      price: 19.99,
      originalPrice: 24.99,
      image: 'https://images.unsplash.com/photo-1550525811-e5869dd03032?q=80&w=400&auto=format&fit=crop',
      badge: '2 Pack',
      subCategoryId: 'smart_home',
    ),
    ProductModel(
      id: 'p2',
      brand: 'Logitech',
      title: 'Gaming Mouse 16000 DPI',
      discount: '14.29% OFF',
      price: 29.99,
      originalPrice: 34.99,
      image: 'https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?q=80&w=400&auto=format&fit=crop',
      subCategoryId: 'computers',
    ),
    ProductModel(
      id: 'p3',
      brand: 'Amazon',
      title: 'Wi-Fi Security Camera 2K',
      discount: '25.01% OFF',
      price: 29.99,
      originalPrice: 39.99,
      image: 'https://images.unsplash.com/photo-1557862921-37829c790f19?q=80&w=400&auto=format&fit=crop',
      subCategoryId: 'cameras',
    ),
    ProductModel(
      id: 'p4',
      brand: 'Microsoft',
      title: 'Gaming Controller Wireless',
      discount: '18.19% OFF',
      price: 44.99,
      originalPrice: 54.99,
      image: 'https://images.unsplash.com/photo-1600080972464-8e5f35f63d08?q=80&w=400&auto=format&fit=crop',
      subCategoryId: 'gaming',
    ),
    ProductModel(
      id: 'p5',
      brand: 'Ninja',
      title: 'Air Fryer Max XL 5.5L',
      discount: '15.00% OFF',
      price: 79.99,
      originalPrice: 94.99,
      image: 'https://images.unsplash.com/photo-1585515320310-259814833e62?q=80&w=400&auto=format&fit=crop',
      subCategoryId: 'appliances',
    ),
    ProductModel(
      id: 'p6',
      brand: 'JBL',
      title: 'Flip 6 Portable Speaker',
      discount: '10.00% OFF',
      price: 89.99,
      originalPrice: 99.99,
      image: 'https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?q=80&w=400&auto=format&fit=crop',
      subCategoryId: 'computers',
    ),
  ];

  final isLoading = true.obs;
  bool _hasLoadedOnce = false;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is Map) {
      if (args.containsKey('name')) {
        categoryName.value = args['name'].toString();
      }
      if (args.containsKey('image')) {
        categoryImage.value = args['image'].toString();
      }
      if (args.containsKey('slug')) {
        categorySlug.value = args['slug'].toString();
      }
      if (args.containsKey('children') && args['children'] is List) {
        final childrenList = args['children'] as List;
        if (childrenList.isNotEmpty) {
          final dynSubCats = <Map<String, dynamic>>[
            {
              'id': 'all',
              'name': 'All',
              'icon': 'https://cdn-icons-png.flaticon.com/512/3081/3081986.png',
            },
          ];
          for (var c in childrenList) {
            if (c is Map) {
              dynSubCats.add({
                'id': c['id']?.toString() ?? '',
                'name': c['name']?.toString() ?? '',
                'icon': 'https://cdn-icons-png.flaticon.com/512/3081/3081986.png',
              });
            }
          }
          subCategories.assignAll(dynSubCats);
        }
      }
    }
    if (categoryImage.isEmpty) {
      categoryImage.value =
          'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?q=80&w=400&auto=format&fit=crop';
    }
    _loadProducts();
  }

  /// API Function code placed directly in Controller
  Future<void> _loadProducts() async {
    isLoading.value = true;
    try {
      final slug = categorySlug.value.isNotEmpty
          ? categorySlug.value
          : categoryName.value.toLowerCase();
      final response = await dioGet('catalog/search?category=$slug');
      if (response.statusCode == 200 && response.data != null) {
        dynamic rawData = response.data;
        if (rawData is Map<String, dynamic> && rawData.containsKey('data')) {
          rawData = rawData['data'];
        }
        List? productList;
        if (rawData is Map<String, dynamic> && rawData.containsKey('products')) {
          productList = rawData['products'] as List?;
        } else if (rawData is List) {
          productList = rawData;
        }

        if (productList != null && productList.isNotEmpty) {
          allProducts.value = productList
              .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
              .toList();
        } else {
          allProducts.value = fallbackProducts;
        }
      } else {
        allProducts.value = fallbackProducts;
      }
    } catch (_) {
      allProducts.value = fallbackProducts;
    } finally {
      isLoading.value = false;
      _hasLoadedOnce = true;
    }
  }

  Future<void> refreshProducts() async {
    await _loadProducts();
  }

  bool get hasLoadedOnce => _hasLoadedOnce;

  List<ProductModel> get filteredProducts {
    if (selectedSubCategoryIndex.value == 0) {
      return allProducts;
    }
    final selectedId = subCategories[selectedSubCategoryIndex.value]['id'];
    final matching =
        allProducts.where((p) => p.subCategoryId == selectedId).toList();
    return matching.isNotEmpty ? matching : allProducts;
  }

  int get visibleItemCount => filteredProducts.length;

  int get totalItemCount => allProducts.length;

  void selectSubCategory(int index) {
    selectedSubCategoryIndex.value = index;
  }

  void toggleWishlist(String productId) {
    if (wishlistedProductIds.contains(productId)) {
      wishlistedProductIds.remove(productId);
    } else {
      wishlistedProductIds.add(productId);
    }
  }

  void addToCart(ProductModel product) {
    Get.snackbar(
      'Added to Bag',
      '${product.title ?? "Item"} added to bag',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }
}
