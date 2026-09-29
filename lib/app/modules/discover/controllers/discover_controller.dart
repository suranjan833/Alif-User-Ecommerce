import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../data/mixins/skeleton_loading_mixin.dart';

class DiscoverController extends GetxController
    with SkeletonLoadingMixin {
  /// Categories shown in the top bar of the Discover page.
  final discoverCategories = <Map<String, dynamic>>[
    {
      'name': 'All',
      'image': 'https://cdn-icons-png.flaticon.com/512/3081/3081986.png',
      'accent': const Color(0xFFFDF0DC),
    },
    {
      'name': 'Clothing',
      'image': 'https://images.unsplash.com/photo-1489987707025-afc232f7ea0f?q=80&w=200&auto=format&fit=crop',
      'accent': const Color(0xFFE9E2F7),
    },
    {
      'name': 'Electronics',
      'image': 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?q=80&w=200&auto=format&fit=crop',
      'accent': const Color(0xFFDDEBFA),
    },
    {
      'name': 'Cosmetics',
      'image': 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=200&auto=format&fit=crop',
      'accent': const Color(0xFFFCE1E7),
    },
    {
      'name': 'Shoes',
      'image': 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=200&auto=format&fit=crop',
      'accent': const Color(0xFFE0F0F5),
    },
    {
      'name': 'Furniture',
      'image': 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?q=80&w=200&auto=format&fit=crop',
      'accent': const Color(0xFFEAE6DC),
    },
    {
      'name': 'Accessories',
      'image': 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=200&auto=format&fit=crop',
      'accent': const Color(0xFFE8EDF5),
    },
  ].obs;

  /// Index of the category currently selected in the top bar.
  final selectedCategoryIndex = 0.obs;

  void selectCategory(int index) {
    selectedCategoryIndex.value = index;
  }

  final posts = <Map<String, dynamic>>[
    {
      'id': 1,
      'title': 'Analog Watch Unisex',
      'overlayText': '',
      'image': 'https://images.unsplash.com/photo-1524805444758-089113d48a6d?q=80&w=800&auto=format&fit=crop',
      'sellerName': 'homeandliving',
      'sellerAvatar': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=200&auto=format&fit=crop',
      'likes': 2,
      'isLiked': false,
      'aspectRatio': 0.75,
    },
    {
      'id': 2,
      'title': 'Hiking Boots - Waterproof',
      'overlayText': 'NEXT-LEVEL DESIGN.',
      'image': 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=800&auto=format&fit=crop',
      'sellerName': 'demoseller',
      'sellerAvatar': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=200&auto=format&fit=crop',
      'likes': 1,
      'isLiked': false,
      'aspectRatio': 0.85,
    },
    {
      'id': 3,
      'title': 'Digital Air Fryer Pro',
      'overlayText': '',
      'image': 'https://images.unsplash.com/photo-1585238342024-78d387f4a707?q=80&w=800&auto=format&fit=crop',
      'sellerName': 'homeandliving',
      'sellerAvatar': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=200&auto=format&fit=crop',
      'likes': 5,
      'isLiked': false,
      'aspectRatio': 0.8,
    },
    {
      'id': 4,
      'title': 'Minimalist Street Hoodie',
      'overlayText': '',
      'image': 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?q=80&w=800&auto=format&fit=crop',
      'sellerName': 'fashionseller',
      'sellerAvatar': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=200&auto=format&fit=crop',
      'likes': 12,
      'isLiked': false,
      'aspectRatio': 0.68,
    },
  ].obs;

  @override
  void onInit() {
    super.onInit();
    // Defer so the shimmer is visible when the tab is first opened.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initSkeletonLoading();
    });
  }

  void toggleLike(int index) {
    if (index >= 0 && index < posts.length) {
      final isLiked = posts[index]['isLiked'] as bool;
      posts[index]['isLiked'] = !isLiked;
      posts[index]['likes'] =
          (posts[index]['likes'] as int) + (isLiked ? -1 : 1);
      posts.refresh();
    }
  }
}
