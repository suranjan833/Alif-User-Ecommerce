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
  final isCategoryProductsLoading = false.obs;

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
              liveProducts.add(prod.toDetailsMap());
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
      products: const [],
    ),
  ].obs;

  final RxList<Map<String, String>> topBrands = <Map<String, String>>[].obs;

  HomeCategoryModel get currentCategory =>
      categories[selectedCategoryIndex.value];

  void changeTab(int index) {
    currentIndex.value = index;
  }

  void selectCategory(int index) {
    selectedCategoryIndex.value = index;
    if (index > 0 && index < categories.length && categories[index].products.isEmpty) {
      fetchCategoryProducts(index);
    }
  }

  Future<void> fetchCategoryProducts(int index) async {
    final cat = categories[index];
    if (cat.slug.isEmpty || cat.slug == 'all') return;
    isCategoryProductsLoading.value = true;
    try {
      final response = await dioGet('catalog/search?category=${cat.slug}');
      if (response.statusCode == 200 && response.data != null) {
        dynamic rawData = response.data;
        if (rawData is Map<String, dynamic> && rawData.containsKey('data')) {
          rawData = rawData['data'];
        }
        List? prods;
        if (rawData is Map<String, dynamic> && rawData.containsKey('products')) {
          prods = rawData['products'] as List?;
        } else if (rawData is List) {
          prods = rawData;
        }
        if (prods != null) {
          final liveList = <Map<String, dynamic>>[];
          for (var p in prods) {
            if (p is Map<String, dynamic>) {
              final prodModel = ShowcaseProductModel.fromJson(p);
              liveList.add(prodModel.toDetailsMap());
            }
          }
          categories[index].products = liveList;
        } else {
          categories[index].products = [];
        }
      } else {
        categories[index].products = [];
      }
    } catch (_) {
      categories[index].products = [];
    } finally {
      isCategoryProductsLoading.value = false;
      categories.refresh();
      selectedCategoryIndex.refresh();
    }
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
