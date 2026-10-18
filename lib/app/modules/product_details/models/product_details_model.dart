import '../../home/models/showcase_model.dart';

class ProductVariantModel {
  final String id;
  final String sku;
  final String label;
  final int? priceMinor;
  final int? compareAtPriceMinor;
  final int? productPoints;
  final int? stockQty;
  final List<String> images;
  final Map<String, dynamic>? attributes;

  ProductVariantModel({
    required this.id,
    required this.sku,
    required this.label,
    this.priceMinor,
    this.compareAtPriceMinor,
    this.productPoints,
    this.stockQty,
    this.images = const [],
    this.attributes,
  });

  double get price => (priceMinor ?? 0) / 100.0;

  double? get originalPrice =>
      compareAtPriceMinor != null ? compareAtPriceMinor! / 100.0 : null;

  String get priceFormatted =>
      '৳${price.toStringAsFixed(price.truncateToDouble() == price ? 0 : 2)}';

  String? get originalPriceFormatted {
    final orig = originalPrice;
    if (orig != null && orig > price) {
      return '৳${orig.toStringAsFixed(orig.truncateToDouble() == orig ? 0 : 2)}';
    }
    return null;
  }

  String get discount {
    if (compareAtPriceMinor != null &&
        priceMinor != null &&
        compareAtPriceMinor! > priceMinor! &&
        priceMinor! > 0) {
      final pct =
          (((compareAtPriceMinor! - priceMinor!) / compareAtPriceMinor!) * 100)
              .round();
      if (pct > 0) return '$pct% OFF';
    }
    return '';
  }

  bool get inStock => stockQty == null || stockQty! > 0;

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    int? pMinor = json['priceMinor'] is num
        ? (json['priceMinor'] as num).toInt()
        : null;
    if (pMinor == null && json['price'] is num) {
      pMinor = ((json['price'] as num) * 100).toInt();
    }

    int? cMinor = json['compareAtPriceMinor'] is num
        ? (json['compareAtPriceMinor'] as num).toInt()
        : null;
    if (cMinor == null && json['originalPrice'] is num) {
      cMinor = ((json['originalPrice'] as num) * 100).toInt();
    }

    List<String> imgs = [];
    if (json['images'] is List) {
      imgs = (json['images'] as List).map((e) => e.toString()).toList();
    } else if (json['image'] != null) {
      imgs = [json['image'].toString()];
    }

    return ProductVariantModel(
      id: json['id']?.toString() ?? '',
      sku: json['sku']?.toString() ?? '',
      label: json['label']?.toString() ??
          json['title']?.toString() ??
          json['name']?.toString() ??
          'Default',
      priceMinor: pMinor,
      compareAtPriceMinor: cMinor,
      productPoints: json['productPoints'] is num
          ? (json['productPoints'] as num).toInt()
          : null,
      stockQty: json['stockQty'] is int ? json['stockQty'] as int : null,
      images: imgs,
      attributes: json['attributes'] is Map<String, dynamic>
          ? json['attributes'] as Map<String, dynamic>
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sku': sku,
      'label': label,
      'priceMinor': priceMinor,
      'compareAtPriceMinor': compareAtPriceMinor,
      'productPoints': productPoints,
      'stockQty': stockQty,
      'images': images,
      'attributes': attributes,
    };
  }
}

class ProductSellerModel {
  final String id;
  final String shopName;
  final String slug;
  final String avatar;
  final double rating;
  final String reviewsCount;
  final String location;
  final bool isVerified;
  final String joinedDate;
  final String bio;
  final String responseRate;

  ProductSellerModel({
    this.id = '',
    required this.shopName,
    this.slug = '',
    this.avatar = '',
    this.rating = 4.9,
    this.reviewsCount = '1.8k',
    this.location = 'Dhaka, Bangladesh',
    this.isVerified = true,
    this.joinedDate = 'Verified Seller',
    this.bio =
        'Official retailer on Alif offering 100% authentic products with brand warranty and fast delivery.',
    this.responseRate = '99%',
  });

  factory ProductSellerModel.fromJson(Map<String, dynamic> json) {
    return ProductSellerModel(
      id: json['id']?.toString() ?? '',
      shopName: json['shopName']?.toString() ??
          json['storeName']?.toString() ??
          json['name']?.toString() ??
          'Alif Official Store',
      slug: json['slug']?.toString() ?? '',
      avatar: json['avatar']?.toString() ??
          json['logoUrl']?.toString() ??
          'https://images.unsplash.com/photo-1560250097-0b93528c311a?q=80&w=200&auto=format&fit=crop',
      rating: json['rating'] is num ? (json['rating'] as num).toDouble() : 4.9,
      reviewsCount: json['reviewsCount']?.toString() ?? '1.8k',
      location: json['location']?.toString() ?? 'Dhaka, Bangladesh',
      isVerified: json['isVerified'] == true || json['verified'] == true,
      joinedDate: json['joinedDate']?.toString() ?? 'Verified Seller',
      bio: json['bio']?.toString() ??
          'Official retailer on Alif offering 100% authentic products with brand warranty and fast delivery.',
      responseRate: json['responseRate']?.toString() ?? '99%',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shopName': shopName,
      'slug': slug,
      'avatar': avatar,
      'rating': rating,
      'reviewsCount': reviewsCount,
      'location': location,
      'isVerified': isVerified,
      'joinedDate': joinedDate,
      'bio': bio,
      'responseRate': responseRate,
    };
  }
}

class ProductDetailsModel {
  final String id;
  final String name;
  final String slug;
  final String description;
  final int? priceMinor;
  final int? compareAtPriceMinor;
  final int? productPoints;
  final int? stockQty;
  final List<String> images;
  final List<ProductVariantModel> variants;
  final ProductSellerModel seller;
  final String? categoryId;
  final String? categoryName;
  final String? brandName;
  final double? ratingAvg;
  final int? ratingCount;
  final bool openBoxDelivery;
  final bool isFavorite;

  ProductDetailsModel({
    required this.id,
    required this.name,
    required this.slug,
    this.description = '',
    this.priceMinor,
    this.compareAtPriceMinor,
    this.productPoints,
    this.stockQty,
    this.images = const [],
    this.variants = const [],
    required this.seller,
    this.categoryId,
    this.categoryName,
    this.brandName,
    this.ratingAvg,
    this.ratingCount,
    this.openBoxDelivery = false,
    this.isFavorite = false,
  });

  /// Base price in BDT
  double get price {
    if (priceMinor != null && priceMinor! > 0) {
      return priceMinor! / 100.0;
    }
    if (variants.isNotEmpty && variants.first.priceMinor != null) {
      return variants.first.price;
    }
    return 0.0;
  }

  /// Base original/compare price in BDT
  double? get originalPrice {
    if (compareAtPriceMinor != null && compareAtPriceMinor! > 0) {
      return compareAtPriceMinor! / 100.0;
    }
    if (variants.isNotEmpty && variants.first.compareAtPriceMinor != null) {
      return variants.first.originalPrice;
    }
    return null;
  }

  String get priceFormatted =>
      '৳${price.toStringAsFixed(price.truncateToDouble() == price ? 0 : 2)}';

  String? get originalPriceFormatted {
    final orig = originalPrice;
    if (orig != null && orig > price) {
      return '৳${orig.toStringAsFixed(orig.truncateToDouble() == orig ? 0 : 2)}';
    }
    return null;
  }

  String get discount {
    final orig = originalPrice;
    if (orig != null && orig > price && price > 0) {
      final pct = (((orig - price) / orig) * 100).round();
      if (pct > 0) return '$pct% OFF';
    }
    return '';
  }

  String get displayTitle => name;

  String get displayBrand => brandName ?? 'Alif';

  String get displayCategory => categoryName ?? '';

  double get displayRating => ratingAvg ?? 4.8;

  int get displayReviewsCount => ratingCount ?? 128;

  String get displayImage => images.isNotEmpty
      ? images.first
      : (variants.isNotEmpty && variants.first.images.isNotEmpty
          ? variants.first.images.first
          : '');

  bool get inStock =>
      (stockQty != null && stockQty! > 0) ||
      (variants.isNotEmpty && variants.any((v) => v.inStock));

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    // 1. Resolve Name
    final resolvedName = json['name']?.toString() ??
        json['title']?.toString() ??
        'Product Details';

    // 2. Resolve Price Minor
    int? pMinor = json['priceMinor'] is num
        ? (json['priceMinor'] as num).toInt()
        : null;
    if (pMinor == null) {
      final rawPrice = json['rawPrice'] ?? json['price'];
      if (rawPrice is num) {
        pMinor = (rawPrice * 100).toInt();
      } else if (rawPrice is String) {
        final clean = rawPrice
            .replaceAll('৳', '')
            .replaceAll('₹', '')
            .replaceAll('\$', '')
            .replaceAll(',', '')
            .trim();
        final parsed = double.tryParse(clean);
        if (parsed != null) pMinor = (parsed * 100).toInt();
      }
    }

    // 3. Resolve Compare Price Minor
    int? cMinor = json['compareAtPriceMinor'] is num
        ? (json['compareAtPriceMinor'] as num).toInt()
        : null;
    if (cMinor == null) {
      final rawOrig = json['originalPrice'];
      if (rawOrig is num) {
        cMinor = (rawOrig * 100).toInt();
      } else if (rawOrig is String) {
        final clean = rawOrig
            .replaceAll('৳', '')
            .replaceAll('₹', '')
            .replaceAll('\$', '')
            .replaceAll(',', '')
            .trim();
        final parsed = double.tryParse(clean);
        if (parsed != null) cMinor = (parsed * 100).toInt();
      }
    }

    // 4. Resolve Images
    List<String> imgs = [];
    if (json['images'] is List) {
      imgs = (json['images'] as List).map((e) => e.toString()).toList();
    } else if (json['image'] != null && json['image'].toString().isNotEmpty) {
      imgs = [json['image'].toString()];
    }

    // 5. Resolve Variants
    List<ProductVariantModel> parsedVariants = [];
    if (json['variants'] is List) {
      parsedVariants = (json['variants'] as List)
          .whereType<Map<String, dynamic>>()
          .map((v) => ProductVariantModel.fromJson(v))
          .toList();
    }

    // 6. Resolve Seller
    ProductSellerModel parsedSeller;
    if (json['seller'] is Map<String, dynamic>) {
      parsedSeller =
          ProductSellerModel.fromJson(json['seller'] as Map<String, dynamic>);
    } else {
      parsedSeller = ProductSellerModel(
        shopName: json['sellerShopName']?.toString() ?? 'Alif Official Store',
      );
    }

    // 7. Resolve Description
    String desc = json['description']?.toString() ?? '';
    if (desc.isEmpty) {
      desc =
          'Experience genuine quality with $resolvedName. Certified authentic product directly from ${parsedSeller.shopName} on Alif with fast and secure shipping.';
    }

    return ProductDetailsModel(
      id: json['id']?.toString() ?? '',
      name: resolvedName,
      slug: json['slug']?.toString() ?? '',
      description: desc,
      priceMinor: pMinor,
      compareAtPriceMinor: cMinor,
      productPoints: json['productPoints'] is num
          ? (json['productPoints'] as num).toInt()
          : null,
      stockQty: json['stockQty'] is int ? json['stockQty'] as int : null,
      images: imgs,
      variants: parsedVariants,
      seller: parsedSeller,
      categoryId: json['categoryId']?.toString(),
      categoryName: json['categoryName']?.toString() ??
          json['category']?.toString(),
      brandName: json['brandName']?.toString() ?? json['brand']?.toString(),
      ratingAvg: json['ratingAvg'] is num
          ? (json['ratingAvg'] as num).toDouble()
          : (json['rating'] is num ? (json['rating'] as num).toDouble() : null),
      ratingCount: json['ratingCount'] is int
          ? json['ratingCount'] as int
          : (json['reviews'] is int ? json['reviews'] as int : null),
      openBoxDelivery: json['openBoxDelivery'] == true,
      isFavorite: json['isFavorite'] == true || json['isWishlisted'] == true,
    );
  }

  factory ProductDetailsModel.fromShowcase(ShowcaseProductModel showcase) {
    return ProductDetailsModel.fromJson(showcase.toDetailsMap());
  }

  ProductDetailsModel copyWith({
    String? id,
    String? name,
    String? slug,
    String? description,
    int? priceMinor,
    int? compareAtPriceMinor,
    int? productPoints,
    int? stockQty,
    List<String>? images,
    List<ProductVariantModel>? variants,
    ProductSellerModel? seller,
    String? categoryId,
    String? categoryName,
    String? brandName,
    double? ratingAvg,
    int? ratingCount,
    bool? openBoxDelivery,
    bool? isFavorite,
  }) {
    return ProductDetailsModel(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      priceMinor: priceMinor ?? this.priceMinor,
      compareAtPriceMinor: compareAtPriceMinor ?? this.compareAtPriceMinor,
      productPoints: productPoints ?? this.productPoints,
      stockQty: stockQty ?? this.stockQty,
      images: images ?? this.images,
      variants: variants ?? this.variants,
      seller: seller ?? this.seller,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      brandName: brandName ?? this.brandName,
      ratingAvg: ratingAvg ?? this.ratingAvg,
      ratingCount: ratingCount ?? this.ratingCount,
      openBoxDelivery: openBoxDelivery ?? this.openBoxDelivery,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'title': name,
      'slug': slug,
      'description': description,
      'priceMinor': priceMinor,
      'compareAtPriceMinor': compareAtPriceMinor,
      'productPoints': productPoints,
      'stockQty': stockQty,
      'images': images,
      'image': displayImage,
      'variants': variants.map((v) => v.toJson()).toList(),
      'seller': seller.toJson(),
      'categoryId': categoryId,
      'categoryName': categoryName,
      'brandName': brandName,
      'brand': brandName,
      'ratingAvg': ratingAvg,
      'rating': ratingAvg,
      'ratingCount': ratingCount,
      'reviews': ratingCount,
      'openBoxDelivery': openBoxDelivery,
      'isFavorite': isFavorite,
      'price': priceFormatted,
      'originalPrice': originalPriceFormatted,
      'discount': discount,
    };
  }
}

