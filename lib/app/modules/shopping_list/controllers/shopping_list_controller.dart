import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/config/app_color.dart';

class ShoppingListItem {
  final String id;
  final String title;
  bool isCompleted;

  ShoppingListItem({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });
}

class ShoppingListController extends GetxController {
  final items = <ShoppingListItem>[
    ShoppingListItem(id: '1', title: 'Milk & Bread', isCompleted: true),
    ShoppingListItem(id: '2', title: 'Smart LED Bulb 2-Pack'),
    ShoppingListItem(id: '3', title: 'Gaming Mouse Pad'),
    ShoppingListItem(id: '4', title: 'Organic Olive Oil'),
  ].obs;

  void toggleItem(int index) {
    items[index].isCompleted = !items[index].isCompleted;
    items.refresh();
  }

  void addItem(String title) {
    if (title.trim().isNotEmpty) {
      items.add(
        ShoppingListItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title.trim(),
        ),
      );
      Get.snackbar(
        'Added',
        'Item added to shopping list',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColor.textPrimary,
        colorText: Colors.white,
      );
    }
  }

  void removeItem(int index) {
    items.removeAt(index);
  }
}
