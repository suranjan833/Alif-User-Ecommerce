import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final currentIndex = 0.obs;
  final selectedCategoryIndex = 0.obs;
  final currentBannerIndex = 0.obs;
  final currentLocation = 'Bakali coloni, Vijay Nagar, Bhuj, Gujar...'.obs;
  final isFetchingLocation = false.obs;

  final List<Map<String, dynamic>> categories = [
    {
      'name': 'All',
      'icon': 'all',
      'searchHint': 'Search "Sofa Sets"',
      'bannerTitle': 'TIMELESS ELEGANCE',
      'bannerSubtitle': 'Crafted For You',
      'bannerImage': 'https://images.unsplash.com/photo-1511556532299-8f662fc26c06?q=80&w=1200&auto=format&fit=crop',
      'bgColor': const Color(0xFFFAF9F6),
      'accentColor': const Color(0xFF0F52BA),
      'buttonColor': const Color(0xFF0F52BA),
      'subtitleColor': const Color(0xFF5A6578),
      'isScriptSubtitle': true,
      'products': [
        {
          'title': 'Modern L-Shaped Sofa',
          'discount': '14.29% OFF',
          'price': '\$599.99',
          'originalPrice': '\$699.99',
          'image': 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?q=80&w=400&auto=format&fit=crop',
          'isFavorite': false,
        },
        {
          'title': 'Upholstered Dining Chair',
          'discount': '15.39% OFF',
          'price': '\$109.99',
          'originalPrice': '\$129.99',
          'image': 'https://images.unsplash.com/photo-1580481072645-022f9a6d8310?q=80&w=400&auto=format&fit=crop',
          'isFavorite': false,
        },
        {
          'title': 'Twin Size Bunk Bed',
          'discount': '9.09% OFF',
          'price': '\$499.99',
          'originalPrice': '\$549.99',
          'image': 'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?q=80&w=400&auto=format&fit=crop',
          'isFavorite': false,
        },
      ],
    },
    {
      'name': 'Furniture',
      'icon': 'furniture',
      'searchHint': 'Search "Chair"',
      'bannerTitle': 'REIMAGINE',
      'bannerSubtitle': 'Your Space',
      'bannerImage': 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?q=80&w=1200&auto=format&fit=crop',
      'bgColor': const Color(0xFFFBF6EE),
      'accentColor': const Color(0xFF8A3814),
      'buttonColor': const Color(0xFF8A3814),
      'subtitleColor': const Color(0xFF8A3814),
      'isScriptSubtitle': true,
      'products': [
        {
          'title': 'Modern L-Shaped Sofa',
          'discount': '14.29% OFF',
          'price': '\$599.99',
          'originalPrice': '\$699.99',
          'image': 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?q=80&w=400&auto=format&fit=crop',
          'isFavorite': false,
        },
        {
          'title': 'Upholstered Dining Chair',
          'discount': '15.39% OFF',
          'price': '\$109.99',
          'originalPrice': '\$129.99',
          'image': 'https://images.unsplash.com/photo-1580481072645-022f9a6d8310?q=80&w=400&auto=format&fit=crop',
          'isFavorite': false,
        },
        {
          'title': 'Twin Size Bunk Bed',
          'discount': '9.09% OFF',
          'price': '\$499.99',
          'originalPrice': '\$549.99',
          'image': 'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?q=80&w=400&auto=format&fit=crop',
          'isFavorite': false,
        },
      ],
    },
    {
      'name': 'Electronics',
      'icon': 'electronics',
      'searchHint': 'Search "Headphones"',
      'bannerTitle': 'NEXT-GEN TECH',
      'bannerSubtitle': 'Sound & Vision',
      'bannerImage': 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=1200&auto=format&fit=crop',
      'bgColor': const Color(0xFFF3F6FA),
      'accentColor': const Color(0xFF102A43),
      'buttonColor': const Color(0xFF102A43),
      'subtitleColor': const Color(0xFF334E68),
      'isScriptSubtitle': false,
      'products': [
        {
          'title': 'Wireless Noise Headphones',
          'discount': '20.00% OFF',
          'price': '\$199.99',
          'originalPrice': '\$249.99',
          'image': 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=400&auto=format&fit=crop',
          'isFavorite': false,
        },
        {
          'title': 'Smart Sports Watch',
          'discount': '15.00% OFF',
          'price': '\$169.99',
          'originalPrice': '\$199.99',
          'image': 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?q=80&w=400&auto=format&fit=crop',
          'isFavorite': false,
        },
        {
          'title': 'Portable Bluetooth Speaker',
          'discount': '10.00% OFF',
          'price': '\$89.99',
          'originalPrice': '\$99.99',
          'image': 'https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?q=80&w=400&auto=format&fit=crop',
          'isFavorite': false,
        },
      ],
    },
    {
      'name': 'Clothing',
      'icon': 'clothing',
      'searchHint': 'Search "Jackets"',
      'bannerTitle': 'TRENDING STYLES',
      'bannerSubtitle': 'Elevate Your Look',
      'bannerImage': 'https://images.unsplash.com/photo-1489987707025-afc232f7ea0f?q=80&w=1200&auto=format&fit=crop',
      'bgColor': const Color(0xFFFAF3F3),
      'accentColor': const Color(0xFF9E2A2B),
      'buttonColor': const Color(0xFF9E2A2B),
      'subtitleColor': const Color(0xFFB04142),
      'isScriptSubtitle': false,
      'products': [
        {
          'title': 'Classic Denim Jacket',
          'discount': '25.00% OFF',
          'price': '\$79.99',
          'originalPrice': '\$99.99',
          'image': 'https://images.unsplash.com/photo-1543076447-215ad9ba6923?q=80&w=400&auto=format&fit=crop',
          'isFavorite': false,
        },
        {
          'title': 'Casual Cotton Hoodie',
          'discount': '18.00% OFF',
          'price': '\$49.99',
          'originalPrice': '\$59.99',
          'image': 'https://images.unsplash.com/photo-1556905055-8f358a7a47b2?q=80&w=400&auto=format&fit=crop',
          'isFavorite': false,
        },
        {
          'title': 'Minimalist Urban Sneakers',
          'discount': '12.50% OFF',
          'price': '\$119.99',
          'originalPrice': '\$139.99',
          'image': 'https://images.unsplash.com/photo-1549298916-b41d501d3772?q=80&w=400&auto=format&fit=crop',
          'isFavorite': false,
        },
      ],
    },
    {
      'name': 'Cosmetics',
      'icon': 'cosmetics',
      'searchHint': 'Search "Lipstick"',
      'bannerTitle': 'GLOW & SHINE',
      'bannerSubtitle': 'Beauty Essentials',
      'bannerImage': 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=1200&auto=format&fit=crop',
      'bgColor': const Color(0xFFFAF2F5),
      'accentColor': const Color(0xFFA4133C),
      'buttonColor': const Color(0xFFA4133C),
      'subtitleColor': const Color(0xFFC9184A),
      'isScriptSubtitle': true,
      'products': [
        {
          'title': 'Velvet Matte Lipstick',
          'discount': '30.00% OFF',
          'price': '\$24.99',
          'originalPrice': '\$34.99',
          'image': 'https://images.unsplash.com/photo-1586495777744-4413f21062fa?q=80&w=400&auto=format&fit=crop',
          'isFavorite': false,
        },
        {
          'title': 'Hydrating Facial Serum',
          'discount': '15.00% OFF',
          'price': '\$39.99',
          'originalPrice': '\$46.99',
          'image': 'https://images.unsplash.com/photo-1608248597261-833258657640?q=80&w=400&auto=format&fit=crop',
          'isFavorite': false,
        },
        {
          'title': 'Organic Rose Face Oil',
          'discount': '20.00% OFF',
          'price': '\$29.99',
          'originalPrice': '\$37.99',
          'image': 'https://images.unsplash.com/photo-1601049541289-9b1b7bbbfe19?q=80&w=400&auto=format&fit=crop',
          'isFavorite': false,
        },
      ],
    },
  ];

  final List<Map<String, String>> topBrands = [
    {'name': 'Adidas', 'logo': 'https://pngimg.com/d/adidas_PNG8.png'},
    {'name': 'Amazon', 'logo': 'https://pngimg.com/d/amazon_PNG27.png'},
    {
      'name': 'American Tourister',
      'logo': 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e3/American_Tourister_logo.svg/1200px-American_Tourister_logo.svg.png',
    },
  ];

  Map<String, dynamic> get currentCategory =>
      categories[selectedCategoryIndex.value];

  void changeTab(int index) {
    currentIndex.value = index;
  }

  void selectCategory(int index) {
    selectedCategoryIndex.value = index;
  }

  void toggleFavorite(int productIndex) {
    final products = currentCategory['products'] as List<Map<String, dynamic>>;
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
