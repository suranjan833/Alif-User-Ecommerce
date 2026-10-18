import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/config/functions/dio_function/my_dio.dart';
import '../../../data/mixins/skeleton_loading_mixin.dart';
import '../../../routes/app_pages.dart';
import '../../home/models/showcase_model.dart';

class TopBrandsController extends GetxController with SkeletonLoadingMixin {
  final allBrands = <BrandModel>[].obs;
  final filteredBrands = <BrandModel>[].obs;

  final searchController = TextEditingController();
  final searchQuery = ''.obs;

  static final List<BrandModel> fallbackBrands = [
    BrandModel(
      id: 'b1',
      name: 'Acer',
      slug: 'acer',
      logoUrl: '/brand-logos/acer.svg',
    ),
    BrandModel(
      id: 'b2',
      name: 'Adidas',
      slug: 'adidas',
      logoUrl: '/brand-logos/adidas.svg',
    ),
    BrandModel(
      id: 'b3',
      name: 'Apple',
      slug: 'apple',
      logoUrl: '/brand-logos/apple.svg',
    ),
    BrandModel(
      id: 'b4',
      name: 'Asus',
      slug: 'asus',
      logoUrl: '/brand-logos/asus.svg',
    ),
    BrandModel(
      id: 'b5',
      name: 'Dell',
      slug: 'dell',
      logoUrl: '/brand-logos/dell.svg',
    ),
    BrandModel(
      id: 'b6',
      name: 'HP',
      slug: 'hp',
      logoUrl: '/brand-logos/hp.svg',
    ),
    BrandModel(
      id: 'b7',
      name: 'Huawei',
      slug: 'huawei',
      logoUrl: '/brand-logos/huawei.svg',
    ),
    BrandModel(
      id: 'b8',
      name: 'IKEA',
      slug: 'ikea',
      logoUrl: '/brand-logos/ikea.svg',
    ),
    BrandModel(
      id: 'b9',
      name: 'JBL',
      slug: 'jbl',
      logoUrl: '/brand-logos/jbl.svg',
    ),
    BrandModel(
      id: 'b10',
      name: 'LG',
      slug: 'lg',
      logoUrl: '/brand-logos/lg.svg',
    ),
    BrandModel(
      id: 'b11',
      name: 'Nike',
      slug: 'nike',
      logoUrl: '/brand-logos/nike.svg',
    ),
    BrandModel(
      id: 'b12',
      name: 'Samsung',
      slug: 'samsung',
      logoUrl: '/brand-logos/samsung.svg',
    ),
    BrandModel(
      id: 'b13',
      name: 'Sony',
      slug: 'sony',
      logoUrl: '/brand-logos/sony.svg',
    ),
    BrandModel(
      id: 'b14',
      name: 'Xiaomi',
      slug: 'xiaomi',
      logoUrl: '/brand-logos/xiaomi.svg',
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchBrands();
    });
  }

  void _onSearchChanged() {
    searchQuery.value = searchController.text.trim();
    _applyFilter();
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    _applyFilter();
  }

  void _applyFilter() {
    final query = searchQuery.value.toLowerCase();
    if (query.isEmpty) {
      filteredBrands.assignAll(allBrands);
    } else {
      filteredBrands.assignAll(
        allBrands.where((brand) => brand.name.toLowerCase().contains(query)),
      );
    }
  }

  /// GET /catalog/brands
  Future<void> fetchBrands() async {
    initSkeletonLoading();
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

        if (brandList != null && brandList.isNotEmpty) {
          final parsed = <BrandModel>[];
          for (var item in brandList) {
            if (item is Map<String, dynamic>) {
              parsed.add(BrandModel.fromJson(item));
            }
          }
          allBrands.assignAll(parsed);
          _applyFilter();
          return;
        }
      }
      allBrands.assignAll(fallbackBrands);
      _applyFilter();
    } catch (_) {
      allBrands.assignAll(fallbackBrands);
      _applyFilter();
    } finally {
      isLoading.value = false;
    }
  }

  void onBrandTap(BrandModel brand) {
    Get.toNamed(
      Routes.CATEGORY_PRODUCTS,
      arguments: {
        'name': brand.name,
        'brand': brand.name,
        'slug': brand.slug,
        'brandSlug': brand.slug,
        'image': brand.fullLogoUrl,
      },
    );
  }

  @override
  void onClose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.onClose();
  }
}
