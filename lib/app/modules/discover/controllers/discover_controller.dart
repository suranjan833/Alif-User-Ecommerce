import 'package:get/get.dart';

class DiscoverController extends GetxController {
  final sellers = <Map<String, dynamic>>[
    {
      'username': 'homeandliv...',
      'avatar': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=200&auto=format&fit=crop',
    },
    {
      'username': 'electronics...',
      'avatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=200&auto=format&fit=crop',
    },
    {
      'username': 'fashionseller',
      'avatar': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=200&auto=format&fit=crop',
    },
    {
      'username': 'demoseller',
      'avatar': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=200&auto=format&fit=crop',
    },
  ].obs;

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
