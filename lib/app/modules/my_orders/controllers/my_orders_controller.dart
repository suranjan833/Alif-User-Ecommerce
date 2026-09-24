import 'package:get/get.dart';

class MyOrdersController extends GetxController {
  final selectedStatusIndex = 0.obs;

  final statuses = const ['All', 'In Progress', 'Delivered', 'Cancelled'];

  final orders = <Map<String, dynamic>>[
    {
      'orderId': '#ALF-98742',
      'date': '24 Sep 2026',
      'status': 'In Progress',
      'total': '₹1,299.00',
      'itemCount': 2,
      'items': [
        {
          'name': 'Smart Color Bulb 2 Pack',
          'image': 'https://images.unsplash.com/photo-1550525811-e5869dd03032?q=80&w=400&auto=format&fit=crop',
          'quantity': 1,
          'price': '₹499.00',
        },
        {
          'name': 'Gaming Mouse 16000 DPI',
          'image': 'https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?q=80&w=400&auto=format&fit=crop',
          'quantity': 1,
          'price': '₹800.00',
        },
      ],
    },
    {
      'orderId': '#ALF-85412',
      'date': '18 Sep 2026',
      'status': 'Delivered',
      'total': '₹2,499.00',
      'itemCount': 1,
      'items': [
        {
          'name': 'Gaming Controller Wireless',
          'image': 'https://images.unsplash.com/photo-1600080972464-8e5f35f63d08?q=80&w=400&auto=format&fit=crop',
          'quantity': 1,
          'price': '₹2,499.00',
        },
      ],
    },
    {
      'orderId': '#ALF-74120',
      'date': '10 Aug 2026',
      'status': 'Delivered',
      'total': '₹5,999.00',
      'itemCount': 1,
      'items': [
        {
          'name': 'Air Fryer Max XL 5.5L',
          'image': 'https://images.unsplash.com/photo-1585515320310-259814833e62?q=80&w=400&auto=format&fit=crop',
          'quantity': 1,
          'price': '₹5,999.00',
        },
      ],
    },
    {
      'orderId': '#ALF-63214',
      'date': '02 Jul 2026',
      'status': 'Cancelled',
      'total': '₹899.00',
      'itemCount': 1,
      'items': [
        {
          'name': 'Flip 6 Portable Speaker',
          'image': 'https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?q=80&w=400&auto=format&fit=crop',
          'quantity': 1,
          'price': '₹899.00',
        },
      ],
    },
  ].obs;

  List<Map<String, dynamic>> get filteredOrders {
    if (selectedStatusIndex.value == 0) {
      return orders;
    }
    final targetStatus = statuses[selectedStatusIndex.value];
    return orders.where((o) => o['status'] == targetStatus).toList();
  }

  void changeStatusTab(int index) {
    selectedStatusIndex.value = index;
  }
}
