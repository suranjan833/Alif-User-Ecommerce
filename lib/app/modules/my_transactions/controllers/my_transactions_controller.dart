import 'package:get/get.dart';

class MyTransactionsController extends GetxController {
  final transactions = <Map<String, dynamic>>[
    {
      'title': 'Order Payment #ALF-98742',
      'date': '24 Sep 2026, 02:45 PM',
      'amount': '- ₹1,299.00',
      'type': 'Debit',
      'paymentMethod': 'UPI / GPay',
      'status': 'Success',
    },
    {
      'title': 'Refund for #ALF-63214',
      'date': '02 Jul 2026, 11:30 AM',
      'amount': '+ ₹899.00',
      'type': 'Credit',
      'paymentMethod': 'Alif Wallet',
      'status': 'Success',
    },
    {
      'title': 'Wallet Top-Up',
      'date': '15 Jun 2026, 05:15 PM',
      'amount': '+ ₹1,000.00',
      'type': 'Credit',
      'paymentMethod': 'Debit Card',
      'status': 'Success',
    },
    {
      'title': 'Order Payment #ALF-85412',
      'date': '18 Sep 2026, 10:20 AM',
      'amount': '- ₹2,499.00',
      'type': 'Debit',
      'paymentMethod': 'Net Banking',
      'status': 'Success',
    },
  ].obs;
}
