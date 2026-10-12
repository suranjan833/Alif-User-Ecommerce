import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/config/functions/dio_function/my_dio.dart';
import '../../../data/mixins/skeleton_loading_mixin.dart';
import '../models/home_category_model.dart';
import '../models/showcase_model.dart';

class HomeController extends GetxController with SkeletonLoadingMixin {
  final currentIndex = 0.obs;
  final selectedCategoryIndex = 0.obs;
  final currentBannerIndex = 0.obs;
  final currentLocation = 'Bakali coloni, Vijay Nagar, Bhuj, Gujar...'.obs;
  final isFetchingLocation = false.obs;

  final showcase = Rxn<ShowcaseModel>();

  @override
  void onInit() {
    super.onInit();
    // Defer so the shimmer is visible when the tab is first opened.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadHomeData();
    });
  }

  Future<void> loadHomeData() async {
    isLoading.value = true;
    try {
      await Future.wait([
        fetchCategories(),
        fetchShowcase(),
        fetchBrands(),
      ]);
    } finally {
      isLoading.value = false;
    }
  }

  /// 1. GET /catalog/categories
  Future<void> fetchCategories() async {
    try {
      final response = await dioGet('catalog/categories');
      if (response.statusCode == 200 && response.data != null) {
        dynamic rawData = response.data;
        if (rawData is Map<String, dynamic> && rawData.containsKey('data')) {
          rawData = rawData['data'];
        }
        List? categoryList;
        if (rawData is Map<String, dynamic> &&
            rawData.containsKey('categories')) {
          categoryList = rawData['categories'] as List?;
        } else if (rawData is List) {
          categoryList = rawData;
        }

        if (categoryList != null && categoryList.isNotEmpty) {
          final dynCats = <HomeCategoryModel>[
            categories.first, // Keep "All" at index 0
          ];

          for (int i = 0; i < categoryList.length; i++) {
            final item = categoryList[i];
            if (item is Map<String, dynamic>) {
              final catId = item['id']?.toString() ?? '';
              final catName = item['name']?.toString() ?? '';
              final catSlug = item['slug']?.toString() ?? '';
              final headerBgMobile = item['headerBgMobileUrl']?.toString();
              final imgUrl = item['imageUrl']?.toString();
              if (catName.isNotEmpty) {
                dynCats.add(HomeCategoryModel.fromApiCategory(
                  id: catId,
                  name: catName,
                  slug: catSlug,
                  headerBgMobile: headerBgMobile,
                  imageUrl: imgUrl,
                  index: i + 1,
                ));
              }
            }
          }
          categories.assignAll(dynCats);
        }
      }
    } catch (_) {}
  }

  /// 2. GET /catalog/showcase
  Future<void> fetchShowcase() async {
    try {
      final response = await dioGet('catalog/showcase');
      if (response.statusCode == 200 && response.data != null) {
        dynamic rawData = response.data;
        if (rawData is Map<String, dynamic> && rawData.containsKey('data')) {
          rawData = rawData['data'];
        }
        if (rawData is Map<String, dynamic>) {
          final model = ShowcaseModel.fromJson(rawData);
          showcase.value = model;

          // Merge live brands
          if (model.brands.isNotEmpty) {
            for (var b in model.brands) {
              if (b.name.isNotEmpty) {
                final logoUrl = b.logoUrl.startsWith('http')
                    ? b.logoUrl
                    : 'https://alifworld.vercel.app${b.logoUrl}';
                final alreadyHas =
                    topBrands.any((element) => element['name'] == b.name);
                if (!alreadyHas) {
                  topBrands.insert(0, {'name': b.name, 'logo': logoUrl});
                }
              }
            }
          }

          // Update "All" category mobile header background if provided by showcase
          if (rawData['allCategoryHeaderBg'] is Map) {
            final allBg = rawData['allCategoryHeaderBg'] as Map;
            final mob = allBg['mobileUrl']?.toString();
            if (mob != null && mob.isNotEmpty) {
              final fullMob = mob.startsWith('http')
                  ? mob
                  : 'https://alifworld.vercel.app$mob';
              if (categories.isNotEmpty && categories.first.id == 'all') {
                categories[0] = HomeCategoryModel(
                  id: categories[0].id,
                  name: categories[0].name,
                  slug: categories[0].slug,
                  icon: categories[0].icon,
                  searchHint: categories[0].searchHint,
                  bannerTitle: categories[0].bannerTitle,
                  bannerSubtitle: categories[0].bannerSubtitle,
                  bannerImage: categories[0].bannerImage,
                  headerBgMobileUrl: fullMob,
                  imageUrl: categories[0].imageUrl,
                  bgColor: categories[0].bgColor,
                  accentColor: categories[0].accentColor,
                  buttonColor: categories[0].buttonColor,
                  subtitleColor: categories[0].subtitleColor,
                  isScriptSubtitle: categories[0].isScriptSubtitle,
                  products: categories[0].products,
                );
              }
            }
          }

          // Populate live products into "All" category
          final liveProducts = <Map<String, dynamic>>[];
          for (var rail in model.rails) {
            for (var prod in rail.products) {
              liveProducts.add({
                'id': prod.id,
                'title': prod.name,
                'brand': prod.brandName ?? 'Alif',
                'discount': prod.discount,
                'price': '₹${prod.price.toStringAsFixed(2)}',
                'originalPrice': prod.originalPrice != null
                    ? '₹${prod.originalPrice!.toStringAsFixed(2)}'
                    : '₹${(prod.price * 1.15).toStringAsFixed(2)}',
                'image': prod.displayImage.isNotEmpty
                    ? prod.displayImage
                    : 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?q=80&w=400&auto=format&fit=crop',
                'isFavorite': false,
              });
            }
          }
          if (liveProducts.isNotEmpty) {
            categories[0].products = liveProducts;
            categories.refresh();
          }
        }
      }
    } catch (_) {}
  }

  /// 3. GET /catalog/brands
  Future<void> fetchBrands() async {
    try {
      final response = await dioGet('catalog/brands');
      if (response.statusCode == 200 && response.data != null) {
        dynamic rawData = response.data;
        if (rawData is Map<String, dynamic> && rawData.containsKey('data')) {
          rawData = rawData['data'];
        }
        List? brandList;
        if (rawData is Map<String, dynamic> && rawData.containsKey('brands')) {
          brandList = rawData['brands'] as List?;
        } else if (rawData is List) {
          brandList = rawData;
        }

        if (brandList != null) {
          for (var item in brandList) {
            if (item is Map<String, dynamic>) {
              final b = BrandModel.fromJson(item);
              if (b.name.isNotEmpty) {
                final logoUrl = b.logoUrl.startsWith('http')
                    ? b.logoUrl
                    : 'https://alifworld.vercel.app${b.logoUrl}';
                final alreadyHas =
                    topBrands.any((element) => element['name'] == b.name);
                if (!alreadyHas) {
                  topBrands.add({'name': b.name, 'logo': logoUrl});
                }
              }
            }
          }
        }
      }
    } catch (_) {}
  }

  @override
  Future<void> refreshData() async {
    await loadHomeData();
  }

  final searchHints = const [
    'Search "Sofa Sets"',
    'Search "Smartphones"',
    'Search "Headphones"',
    'Search "Gaming Mouse"',
    'Search "Air Fryers"',
    'Search "Wireless Earbuds"',
    'Search "Dining Chairs"',
  ];

  final RxList<HomeCategoryModel> categories = <HomeCategoryModel>[
    HomeCategoryModel(
      id: 'all',
      name: 'All',
      slug: 'all',
      icon: 'all',
      searchHint: 'Search "Sofa Sets"',
      bannerTitle: 'TIMELESS ELEGANCE',
      bannerSubtitle: 'Crafted For You',
      bannerImage:
          'https://images.unsplash.com/photo-1511556532299-8f662fc26c06?q=80&w=1200&auto=format&fit=crop',
      bgColor: const Color(0xFFFAF9F6),
      accentColor: const Color(0xFF3760A5),
      buttonColor: const Color(0xFF3760A5),
      subtitleColor: const Color(0xFF5A6578),
      isScriptSubtitle: true,
      products: [
        {
          'title': 'Modern L-Shaped Sofa',
          'discount': '14.29% OFF',
          'price': '₹599.99',
          'originalPrice': '₹699.99',
          'image':
              'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?q=80&w=400&auto=format&fit=crop',
          'isFavorite': false,
        },
        {
          'title': 'Upholstered Dining Chair',
          'discount': '15.39% OFF',
          'price': '₹109.99',
          'originalPrice': '₹129.99',
          'image':
              'https://images.unsplash.com/photo-1580481072645-022f9a6d8310?q=80&w=400&auto=format&fit=crop',
          'isFavorite': false,
        },
        {
          'title': 'Twin Size Bunk Bed',
          'discount': '9.09% OFF',
          'price': '₹499.99',
          'originalPrice': '₹549.99',
          'image':
              'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?q=80&w=400&auto=format&fit=crop',
          'isFavorite': false,
        },
      ],
    ),
  ].obs;

  final RxList<Map<String, String>> topBrands = <Map<String, String>>[
    {'name': 'Adidas', 'logo': 'https://pngimg.com/d/adidas_PNG8.png'},
    {'name': 'Amazon', 'logo': 'https://pngimg.com/d/amazon_PNG27.png'},
    {
      'name': 'American Tourister',
      'logo':
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e3/American_Tourister_logo.svg/1200px-American_Tourister_logo.svg.png',
    },
  ].obs;

  HomeCategoryModel get currentCategory =>
      categories[selectedCategoryIndex.value];

  void changeTab(int index) {
    currentIndex.value = index;
  }

  void selectCategory(int index) {
    selectedCategoryIndex.value = index;
  }

  void toggleFavorite(int productIndex) {
    final products = currentCategory.products;
    if (productIndex >= 0 && productIndex < products.length) {
      products[productIndex]['isFavorite'] =
          !(products[productIndex]['isFavorite'] as bool);
      selectedCategoryIndex.refresh();
    }
  }

  void setLocation(String newLocation) {
    currentLocation.value = newLocation;
  }

  Future<void> fetchGPSLocation() async {
    isFetchingLocation.value = true;
    await Future.delayed(const Duration(seconds: 1));
    currentLocation.value = 'Vijay Nagar, Sector 4, Bhuj';
    isFetchingLocation.value = false;
  }
}
