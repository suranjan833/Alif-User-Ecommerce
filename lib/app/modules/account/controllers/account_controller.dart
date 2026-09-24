import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class AccountMenuItem {
  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback? onTap;

  AccountMenuItem({
    required this.title,
    this.subtitle,
    required this.icon,
    this.onTap,
  });
}

class AccountSectionData {
  final String title;
  final List<AccountMenuItem> items;

  AccountSectionData({required this.title, required this.items});
}

class AccountController extends GetxController {
  final userName = 'User'.obs;
  final memberSince = 'Member since Jun-2026'.obs;
  final currentLanguage = 'English'.obs;

  List<AccountSectionData> get sections => [
    AccountSectionData(
      title: 'Manage',
      items: [
        AccountMenuItem(
          title: 'My Orders',
          icon: Iconsax.shopping_bag,
          onTap: () => onMenuItemTap('My Orders'),
        ),
        AccountMenuItem(
          title: 'Manage addresses',
          icon: Iconsax.location,
          onTap: () => onMenuItemTap('Manage addresses'),
        ),
        AccountMenuItem(
          title: 'My transactions',
          icon: Iconsax.card,
          onTap: () => onMenuItemTap('My transactions'),
        ),
        AccountMenuItem(
          title: 'My Wishlist',
          icon: Iconsax.heart,
          onTap: () => onMenuItemTap('My Wishlist'),
        ),
        AccountMenuItem(
          title: 'Wallet',
          icon: Iconsax.wallet_2,
          onTap: () => onMenuItemTap('Wallet'),
        ),
        AccountMenuItem(
          title: 'Shopping List',
          icon: Iconsax.clipboard_text,
          onTap: () => onMenuItemTap('Shopping List'),
        ),
        AccountMenuItem(
          title: 'Saved for later',
          icon: Iconsax.bookmark,
          onTap: () => onMenuItemTap('Saved for later'),
        ),
        AccountMenuItem(
          title: 'Refer and Earn',
          icon: Iconsax.profile_add,
          onTap: () => onMenuItemTap('Refer and Earn'),
        ),
      ],
    ),
    AccountSectionData(
      title: 'Settings',
      items: [
        AccountMenuItem(
          title: 'Account settings',
          icon: Iconsax.user,
          onTap: () => onMenuItemTap('Account settings'),
        ),
        AccountMenuItem(
          title: 'Notifications',
          icon: Iconsax.notification,
          onTap: () => onMenuItemTap('Notifications'),
        ),
        AccountMenuItem(
          title: 'Support',
          icon: Iconsax.message_question,
          onTap: () => onMenuItemTap('Support'),
        ),
        AccountMenuItem(
          title: 'Language',
          subtitle: 'Current Language: ${currentLanguage.value}',
          icon: Iconsax.translate,
          onTap: () => onMenuItemTap('Language'),
        ),
        AccountMenuItem(
          title: 'Stores',
          icon: Iconsax.shop,
          onTap: () => onMenuItemTap('Stores'),
        ),
      ],
    ),
    AccountSectionData(
      title: 'Others',
      items: [
        AccountMenuItem(
          title: 'About us',
          icon: Iconsax.info_circle,
          onTap: () => onMenuItemTap('About us'),
        ),
        AccountMenuItem(
          title: 'Terms & Condition',
          icon: Iconsax.document_text,
          onTap: () => onMenuItemTap('Terms & Condition'),
        ),
        AccountMenuItem(
          title: 'Privacy Policy',
          icon: Iconsax.lock,
          onTap: () => onMenuItemTap('Privacy Policy'),
        ),
        AccountMenuItem(
          title: 'Refund Policy',
          icon: Iconsax.refresh_circle,
          onTap: () => onMenuItemTap('Refund Policy'),
        ),
        AccountMenuItem(
          title: 'Shipping Policy',
          icon: Iconsax.truck_fast,
          onTap: () => onMenuItemTap('Shipping Policy'),
        ),
      ],
    ),
  ];

  void onMenuItemTap(String title) {
    // Menu item action handler
  }
}
