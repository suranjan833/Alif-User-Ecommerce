import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoriesController extends GetxController {
  final categories = <Map<String, dynamic>>[
    {
      'name': 'Accessories',
      'image':
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=400&auto=format&fit=crop',
      'accent': const Color(0xFFE8EDF5),
      'count': 128,
    },
    {
      'name': 'Breakfast & Cereals',
      'image':
          'https://images.unsplash.com/photo-1517673400267-0251440c45dc?q=80&w=400&auto=format&fit=crop',
      'accent': const Color(0xFFFDF0DC),
      'count': 64,
    },
    {
      'name': 'Clothing',
      'image':
          'https://images.unsplash.com/photo-1489987707025-afc232f7ea0f?q=80&w=400&auto=format&fit=crop',
      'accent': const Color(0xFFE9E2F7),
      'count': 212,
    },
    {
      'name': 'Cosmetics',
      'image':
          'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=400&auto=format&fit=crop',
      'accent': const Color(0xFFFCE1E7),
      'count': 96,
    },
    {
      'name': 'Drugstore & Health',
      'image':
          'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?q=80&w=400&auto=format&fit=crop',
      'accent': const Color(0xFFDFF2EA),
      'count': 85,
    },
    {
      'name': 'Electronics',
      'image':
          'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?q=80&w=400&auto=format&fit=crop',
      'accent': const Color(0xFFDDEBFA),
      'count': 143,
    },
    {
      'name': 'Food & Beverages',
      'image':
          'https://images.unsplash.com/photo-1563227812-0ea4c22e6cc8?q=80&w=400&auto=format&fit=crop',
      'accent': const Color(0xFFFCE8D8),
      'count': 177,
    },
    {
      'name': 'Furniture',
      'image':
          'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?q=80&w=400&auto=format&fit=crop',
      'accent': const Color(0xFFEAE6DC),
      'count': 58,
    },
    {
      'name': 'Shoes',
      'image':
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=400&auto=format&fit=crop',
      'accent': const Color(0xFFE0F0F5),
      'count': 89,
    },
    {
      'name': 'Skin & Hair Care',
      'image':
          'https://images.unsplash.com/photo-1556228720-195a672e8a03?q=80&w=400&auto=format&fit=crop',
      'accent': const Color(0xFFF4E4DC),
      'count': 134,
    },
  ].obs;

  /// Whether the initial load has finished. While false, the shimmer
  /// skeleton is shown instead of the category grid.
  final isLoading = true.obs;

  bool _hasLoadedOnce = false;

  @override
  void onInit() {
    super.onInit();
    // Defer the simulated fetch until the Categories tab is actually shown,
    // so the shimmer is visible on first open instead of instantly completing.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 900), _loadCategories);
    });
  }

  Future<void> _loadCategories() async {
    // TODO: replace with a real API call when the backend is wired up.
    await Future.delayed(const Duration(milliseconds: 600));

    isLoading.value = false;
    _hasLoadedOnce = true;
  }

  /// Re-runs the skeleton briefly on pull-to-refresh.
  Future<void> refreshCategories() async {
    if (isLoading.value) return;
    isLoading.value = true;
    await _loadCategories();
  }

  bool get hasLoadedOnce => _hasLoadedOnce;
}
