import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/config/functions/dio_function/my_dio.dart';
import '../models/category_model.dart';

class CategoriesController extends GetxController {
  final categories = <CategoryModel>[].obs;
  final isLoading = true.obs;

  bool _hasLoadedOnce = false;

  static final List<CategoryModel> fallbackCategories = [
    CategoryModel(
      name: 'Accessories',
      image:
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=400&auto=format&fit=crop',
      accent: const Color(0xFFE8EDF5),
      count: 128,
    ),
    CategoryModel(
      name: 'Breakfast & Cereals',
      image:
          'https://images.unsplash.com/photo-1517673400267-0251440c45dc?q=80&w=400&auto=format&fit=crop',
      accent: const Color(0xFFFDF0DC),
      count: 64,
    ),
    CategoryModel(
      name: 'Clothing',
      image:
          'https://images.unsplash.com/photo-1489987707025-afc232f7ea0f?q=80&w=400&auto=format&fit=crop',
      accent: const Color(0xFFE9E2F7),
      count: 212,
    ),
    CategoryModel(
      name: 'Cosmetics',
      image:
          'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=400&auto=format&fit=crop',
      accent: const Color(0xFFFCE1E7),
      count: 96,
    ),
    CategoryModel(
      name: 'Drugstore & Health',
      image:
          'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?q=80&w=400&auto=format&fit=crop',
      accent: const Color(0xFFDFF2EA),
      count: 85,
    ),
    CategoryModel(
      name: 'Electronics',
      image:
          'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?q=80&w=400&auto=format&fit=crop',
      accent: const Color(0xFFDDEBFA),
      count: 143,
    ),
    CategoryModel(
      name: 'Food & Beverages',
      image:
          'https://images.unsplash.com/photo-1563227812-0ea4c22e6cc8?q=80&w=400&auto=format&fit=crop',
      accent: const Color(0xFFFCE8D8),
      count: 177,
    ),
    CategoryModel(
      name: 'Furniture',
      image:
          'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?q=80&w=400&auto=format&fit=crop',
      accent: const Color(0xFFEAE6DC),
      count: 58,
    ),
    CategoryModel(
      name: 'Shoes',
      image:
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=400&auto=format&fit=crop',
      accent: const Color(0xFFE0F0F5),
      count: 89,
    ),
    CategoryModel(
      name: 'Skin & Hair Care',
      image:
          'https://images.unsplash.com/photo-1556228720-195a672e8a03?q=80&w=400&auto=format&fit=crop',
      accent: const Color(0xFFF4E4DC),
      count: 134,
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCategories();
    });
  }

  /// API Function code placed directly in Controller
  Future<void> _loadCategories() async {
    isLoading.value = true;
    try {
      final response = await dioGet('catalog/categories');
      if (response.statusCode == 200 && response.data != null) {
        dynamic rawData = response.data;
        if (rawData is Map<String, dynamic> && rawData.containsKey('data')) {
          rawData = rawData['data'];
        }
        List? categoryList;
        if (rawData is Map<String, dynamic> && rawData.containsKey('categories')) {
          categoryList = rawData['categories'] as List?;
        } else if (rawData is List) {
          categoryList = rawData;
        }

        if (categoryList != null && categoryList.isNotEmpty) {
          final pastelColors = [
            const Color(0xFFE8EDF5),
            const Color(0xFFFDF0DC),
            const Color(0xFFE9E2F7),
            const Color(0xFFFCE1E7),
            const Color(0xFFDFF2EA),
            const Color(0xFFDDEBFA),
            const Color(0xFFFCE8D8),
            const Color(0xFFEAE6DC),
            const Color(0xFFE0F0F5),
            const Color(0xFFF4E4DC),
          ];

          final parsed = <CategoryModel>[];
          for (int i = 0; i < categoryList.length; i++) {
            final item = categoryList[i];
            if (item is Map<String, dynamic>) {
              final cat = CategoryModel.fromJson(item);
              parsed.add(CategoryModel(
                id: cat.id,
                name: cat.name,
                slug: cat.slug,
                description: cat.description,
                image: cat.image,
                icon: cat.icon,
                parentId: cat.parentId,
                count: cat.count,
                accent: pastelColors[i % pastelColors.length],
                children: cat.children,
              ));
            }
          }
          categories.assignAll(parsed);
        } else {
          categories.assignAll(fallbackCategories);
        }
      } else {
        categories.assignAll(fallbackCategories);
      }
    } catch (_) {
      categories.assignAll(fallbackCategories);
    } finally {
      isLoading.value = false;
      _hasLoadedOnce = true;
    }
  }

  Future<void> refreshCategories() async {
    await _loadCategories();
  }

  bool get hasLoadedOnce => _hasLoadedOnce;
}
