class BrandModel {
  final String id;
  final String name;
  final String slug;
  final String logoUrl;

  BrandModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.logoUrl,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      logoUrl: json['logoUrl']?.toString() ?? json['logo']?.toString() ?? '',
    );
  }

  String get fullLogoUrl {
    if (logoUrl.isEmpty) return '';
    if (logoUrl.startsWith('http://') || logoUrl.startsWith('https://')) {
      return logoUrl;
    }
    return 'https://alifworld.vercel.app$logoUrl';
  }

  bool get isSvg => fullLogoUrl.toLowerCase().contains('.svg');

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'logoUrl': logoUrl,
    };
  }
}

class ShowcaseMiniBannerModel {
  final String id;
  final String name;
  final String slug;
  final String imageUrl;
  final String? tagline;
  final String? badge;

  ShowcaseMiniBannerModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.imageUrl,
    this.tagline,
    this.badge,
  });

  factory ShowcaseMiniBannerModel.fromJson(Map<String, dynamic> json) {
    return ShowcaseMiniBannerModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? json['image']?.toString() ?? '',
      tagline: json['tagline']?.toString(),
      badge: json['badge']?.toString(),
    );
  }

  String get fullImageUrl {
    if (imageUrl.isEmpty) return '';
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return imageUrl;
    }
    return 'https://alifworld.vercel.app$imageUrl';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'imageUrl': imageUrl,
      'tagline': tagline,
      'badge': badge,
    };
  }
}

class ShowcaseProductModel {
  final String id;
  final String name;
  final String slug;
  final String? brandName;
  final String? categoryName;
  final double price;
  final double? originalPrice;
  final String discount;
  final List<String> images;
  final String? sellerShopName;
  final Map<String, dynamic>? seller;
  final List<Map<String, dynamic>> variants;
  final double? rating;
  final int? reviews;
  final int? stockQty;
  final String? description;
  bool isFavorite;

  ShowcaseProductModel({
    required this.id,
    required this.name,
    required this.slug,
    this.brandName,
    this.categoryName,
    required this.price,
    this.originalPrice,
    this.discount = '',
    this.images = const [],
    this.sellerShopName,
    this.seller,
    this.variants = const [],
    this.rating,
    this.reviews,
    this.stockQty,
    this.description,
    this.isFavorite = false,
  });

  String get displayImage => images.isNotEmpty ? images.first : '';

  factory ShowcaseProductModel.fromJson(Map<String, dynamic> json) {
    double parsedPrice = 0.0;
    double? parsedOriginalPrice;

    // Check direct priceMinor or variants[0].priceMinor (money in minor units / 100)
    final rawPriceMinor = json['priceMinor'];
    final rawComparePriceMinor = json['compareAtPriceMinor'];

    if (rawPriceMinor is num) {
      parsedPrice = rawPriceMinor / 100.0;
    } else if (json['price'] is num) {
      parsedPrice = (json['price'] as num).toDouble();
    }

    if (rawComparePriceMinor is num) {
      parsedOriginalPrice = rawComparePriceMinor / 100.0;
    } else if (json['originalPrice'] is num) {
      parsedOriginalPrice = (json['originalPrice'] as num).toDouble();
    }

    List<Map<String, dynamic>> parsedVariants = [];
    if (json['variants'] is List) {
      parsedVariants = (json['variants'] as List)
          .whereType<Map<String, dynamic>>()
          .toList();
    }

    // Fallback to first variant if product-level price is null
    if (parsedPrice == 0.0 && parsedVariants.isNotEmpty) {
      final firstVar = parsedVariants.first;
      if (firstVar['priceMinor'] is num) {
        parsedPrice = (firstVar['priceMinor'] as num) / 100.0;
      }
      if (firstVar['compareAtPriceMinor'] is num) {
        parsedOriginalPrice = (firstVar['compareAtPriceMinor'] as num) / 100.0;
      }
    }

    // Calculate discount text if compareAtPrice is greater
    String calcDiscount = '';
    if (parsedOriginalPrice != null && parsedOriginalPrice > parsedPrice && parsedPrice > 0) {
      final pct = (((parsedOriginalPrice - parsedPrice) / parsedOriginalPrice) * 100).round();
      if (pct > 0) {
        calcDiscount = '$pct% OFF';
      }
    }

    List<String> parsedImages = [];
    if (json['images'] is List) {
      parsedImages = (json['images'] as List).map((e) => e.toString()).toList();
    } else if (json['image'] != null) {
      parsedImages = [json['image'].toString()];
    }

    String? shopName;
    Map<String, dynamic>? sellerObj;
    if (json['seller'] is Map<String, dynamic>) {
      sellerObj = json['seller'] as Map<String, dynamic>;
      shopName = sellerObj['shopName']?.toString();
    }

    double? parsedRating;
    if (json['ratingAvg'] is num) {
      parsedRating = (json['ratingAvg'] as num).toDouble();
    } else if (json['rating'] is num) {
      parsedRating = (json['rating'] as num).toDouble();
    }

    int? parsedReviews;
    if (json['ratingCount'] is int) {
      parsedReviews = json['ratingCount'] as int;
    } else if (json['reviews'] is int) {
      parsedReviews = json['reviews'] as int;
    }

    int? parsedStock;
    if (json['stockQty'] is int) {
      parsedStock = json['stockQty'] as int;
    }

    return ShowcaseProductModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? json['title']?.toString() ?? 'Product',
      slug: json['slug']?.toString() ?? '',
      brandName: json['brandName']?.toString() ?? json['brand']?.toString(),
      categoryName: json['categoryName']?.toString(),
      price: parsedPrice > 0 ? parsedPrice : 0.0,
      originalPrice: parsedOriginalPrice,
      discount: calcDiscount.isNotEmpty ? calcDiscount : (json['discount']?.toString() ?? ''),
      images: parsedImages,
      sellerShopName: shopName,
      seller: sellerObj,
      variants: parsedVariants,
      rating: parsedRating,
      reviews: parsedReviews,
      stockQty: parsedStock,
      description: json['description']?.toString(),
      isFavorite: json['isFavorite'] == true,
    );
  }

  Map<String, dynamic> toDetailsMap() {
    return {
      'id': id,
      'title': name,
      'name': name,
      'slug': slug,
      'brand': brandName ?? 'Alif',
      'brandName': brandName ?? 'Alif',
      'categoryName': categoryName,
      'price': '৳${price.toStringAsFixed(2)}',
      'rawPrice': price,
      'originalPrice': originalPrice != null
          ? '৳${originalPrice!.toStringAsFixed(2)}'
          : null,
      'discount': discount,
      'image': displayImage,
      'images': images,
      'variants': variants,
      'seller': seller ?? (sellerShopName != null ? {'name': sellerShopName, 'shopName': sellerShopName} : null),
      'rating': rating ?? 4.8,
      'reviews': reviews ?? 24,
      'stockQty': stockQty,
      'description': description,
      'isFavorite': isFavorite,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'brandName': brandName,
      'categoryName': categoryName,
      'price': price,
      'originalPrice': originalPrice,
      'discount': discount,
      'images': images,
      'sellerShopName': sellerShopName,
      'seller': seller,
      'variants': variants,
      'rating': rating,
      'reviews': reviews,
      'stockQty': stockQty,
      'description': description,
      'isFavorite': isFavorite,
    };
  }
}

class ShowcaseRailModel {
  final String categoryId;
  final String categoryName;
  final String categorySlug;
  final List<ShowcaseProductModel> products;

  ShowcaseRailModel({
    required this.categoryId,
    required this.categoryName,
    required this.categorySlug,
    this.products = const [],
  });

  factory ShowcaseRailModel.fromJson(Map<String, dynamic> json) {
    String cId = '';
    String cName = 'Featured';
    String cSlug = '';

    if (json['category'] is Map<String, dynamic>) {
      final cat = json['category'] as Map<String, dynamic>;
      cId = cat['id']?.toString() ?? '';
      cName = cat['name']?.toString() ?? 'Featured';
      cSlug = cat['slug']?.toString() ?? '';
    }

    List<ShowcaseProductModel> prodList = [];
    if (json['products'] is List) {
      prodList = (json['products'] as List)
          .whereType<Map<String, dynamic>>()
          .map((e) => ShowcaseProductModel.fromJson(e))
          .toList();
    }

    return ShowcaseRailModel(
      categoryId: cId,
      categoryName: cName,
      categorySlug: cSlug,
      products: prodList,
    );
  }
}

class ShowcaseModel {
  final List<BrandModel> brands;
  final List<ShowcaseMiniBannerModel> miniBanners;
  final List<ShowcaseRailModel> rails;
  final List<Map<String, dynamic>> rawCategories;

  ShowcaseModel({
    this.brands = const [],
    this.miniBanners = const [],
    this.rails = const [],
    this.rawCategories = const [],
  });

  factory ShowcaseModel.fromJson(Map<String, dynamic> json) {
    List<BrandModel> parsedBrands = [];
    if (json['brands'] is List) {
      parsedBrands = (json['brands'] as List)
          .whereType<Map<String, dynamic>>()
          .map((e) => BrandModel.fromJson(e))
          .toList();
    }

    List<ShowcaseMiniBannerModel> parsedBanners = [];
    if (json['miniBanners'] is List) {
      parsedBanners = (json['miniBanners'] as List)
          .whereType<Map<String, dynamic>>()
          .map((e) => ShowcaseMiniBannerModel.fromJson(e))
          .toList();
    }

    List<ShowcaseRailModel> parsedRails = [];
    if (json['rails'] is List) {
      parsedRails = (json['rails'] as List)
          .whereType<Map<String, dynamic>>()
          .map((e) => ShowcaseRailModel.fromJson(e))
          .toList();
    }

    List<Map<String, dynamic>> parsedCategories = [];
    if (json['categories'] is List) {
      parsedCategories = (json['categories'] as List)
          .whereType<Map<String, dynamic>>()
          .toList();
    }

    return ShowcaseModel(
      brands: parsedBrands,
      miniBanners: parsedBanners,
      rails: parsedRails,
      rawCategories: parsedCategories,
    );
  }
}
