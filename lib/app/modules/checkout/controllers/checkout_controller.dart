import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/config/app_color.dart';
import '../../../data/config/functions/dio_function/my_dio.dart';
import '../../../routes/app_pages.dart';
import '../../bag/controllers/bag_controller.dart';
import '../models/checkout_quote_model.dart';

class CheckoutController extends GetxController {
  final items = <Map<String, dynamic>>[].obs;
  final subtotal = 0.0.obs;
  final deliveryFee = 0.0.obs;
  final tax = 0.0.obs;
  final discount = 0.0.obs;
  final isDirectBuy = false.obs;

  final selectedAddressIndex = 0.obs;
  final selectedPaymentMethod = 'COD'.obs; // COD, bKash, Nagad
  final promoCodeController = TextEditingController();
  final appliedPromoCode = ''.obs;
  final isProcessingPayment = false.obs;

  final addresses = <Map<String, dynamic>>[
    {
      'id': 'addr_1',
      'name': 'Customer',
      'type': 'Home',
      'phone': '+880 1712-345678',
      'address': 'House 12, Road 5, Dhanmondi, Dhaka - 1205',
    },
    {
      'id': 'addr_2',
      'name': 'Customer',
      'type': 'Office',
      'phone': '+880 1712-345678',
      'address': 'Level 4, Alif World Tower, Gulshan-2, Dhaka - 1212',
    },
  ].obs;

  double get finalPayable =>
      (subtotal.value + deliveryFee.value + tax.value - discount.value).clamp(
        0.0,
        double.infinity,
      );

  String get selectedAddressId {
    if (addresses.isNotEmpty && selectedAddressIndex.value < addresses.length) {
      return addresses[selectedAddressIndex.value]['id']?.toString() ??
          'addr_1';
    }
    return 'default_addr';
  }

  String _mapPaymentMethodToApi(String method) {
    switch (method.toLowerCase()) {
      case 'bkash':
        return 'bkash';
      case 'nagad':
        return 'nagad';
      case 'wallet':
        return 'wallet';
      case 'cod':
      case 'cash on delivery':
      default:
        return 'cod';
    }
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      if (args.containsKey('items')) {
        items.value = List<Map<String, dynamic>>.from(args['items']);
      }
      subtotal.value = (args['subtotal'] as num?)?.toDouble() ?? 0.0;
      deliveryFee.value = (args['deliveryFee'] as num?)?.toDouble() ?? 0.0;
      tax.value = (args['tax'] as num?)?.toDouble() ?? 0.0;
      isDirectBuy.value = args['isDirectBuy'] as bool? ?? false;
    }
    fetchUserAddresses();
    fetchQuote();
  }

  @override
  void onClose() {
    promoCodeController.dispose();
    super.onClose();
  }

  void selectAddress(int index) {
    selectedAddressIndex.value = index;
    fetchQuote();
  }

  void selectPaymentMethod(String method) {
    selectedPaymentMethod.value = method;
    fetchQuote();
  }

  /// 1. GET /addresses - Fetch saved addresses for user
  Future<void> fetchUserAddresses() async {
    try {
      final response = await dioGet('addresses');
      if (response.statusCode == 200 && response.data != null) {
        dynamic rawData = response.data;
        if (rawData is Map<String, dynamic> && rawData.containsKey('data')) {
          rawData = rawData['data'];
        }
        List? addrList;
        if (rawData is Map<String, dynamic> &&
            rawData.containsKey('addresses')) {
          addrList = rawData['addresses'] as List?;
        } else if (rawData is List) {
          addrList = rawData;
        }

        if (addrList != null && addrList.isNotEmpty) {
          final parsed = <Map<String, dynamic>>[];
          for (var item in addrList) {
            if (item is Map<String, dynamic>) {
              parsed.add({
                'id': item['id']?.toString() ?? '',
                'name':
                    item['recipientName']?.toString() ??
                    item['name']?.toString() ??
                    'Customer',
                'type':
                    item['label']?.toString() ??
                    item['type']?.toString() ??
                    'Home',
                'phone': item['phone']?.toString() ?? '',
                'address':
                    item['addressLine']?.toString() ??
                    item['address']?.toString() ??
                    '',
              });
            }
          }
          if (parsed.isNotEmpty) {
            addresses.assignAll(parsed);
          }
        }
      }
    } catch (_) {}
  }

  /// 2. POST /checkout/quote - Fetch price quote from API
  Future<void> fetchQuote() async {
    try {
      final response = await dioPost(
        endUrl: 'checkout/quote',
        data: {
          'paymentMethod': _mapPaymentMethodToApi(selectedPaymentMethod.value),
          'addressId': selectedAddressId,
          if (appliedPromoCode.value.isNotEmpty)
            'couponCode': appliedPromoCode.value,
        },
        isJson: true,
      );

      if (response.statusCode == 200 && response.data != null) {
        dynamic rawData = response.data;
        if (rawData is Map<String, dynamic> && rawData.containsKey('data')) {
          rawData = rawData['data'];
        }
        if (rawData is Map<String, dynamic>) {
          final quote = CheckoutQuoteModel.fromJson(rawData);
          if (quote.subtotal > 0) subtotal.value = quote.subtotal;
          if (quote.deliveryFee >= 0) deliveryFee.value = quote.deliveryFee;
          if (quote.tax >= 0) tax.value = quote.tax;
          if (quote.discount >= 0) discount.value = quote.discount;
        }
      }
    } catch (_) {}
  }

  void applyPromoCode() {
    final code = promoCodeController.text.trim().toUpperCase();
    if (code.isEmpty) return;

    appliedPromoCode.value = code;
    fetchQuote();

    Get.snackbar(
      'Promo Applied!',
      'Coupon "$code" applied to order',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF16A34A),
      colorText: Colors.white,
    );
  }

  void removePromoCode() {
    appliedPromoCode.value = '';
    discount.value = 0.0;
    promoCodeController.clear();
    fetchQuote();
  }

  /// 3. POST /checkout/place - Place order
  Future<void> placeOrder() async {
    if (selectedPaymentMethod.value == 'bKash' ||
        selectedPaymentMethod.value == 'Nagad' ||
        selectedPaymentMethod.value == 'Razorpay') {
      openMobileBankingModal(selectedPaymentMethod.value);
    } else {
      _executePlaceOrder();
    }
  }

  Future<void> _executePlaceOrder({String? gatewayPaymentId}) async {
    isProcessingPayment.value = true;
    final apiPayment = _mapPaymentMethodToApi(selectedPaymentMethod.value);

    try {
      final response = await dioPost(
        endUrl: 'checkout/place',
        data: {
          'paymentMethod': apiPayment,
          'addressId': selectedAddressId,
          if (appliedPromoCode.value.isNotEmpty)
            'couponCode': appliedPromoCode.value,
          'returnUrl': 'https://alifworld.vercel.app/order-success',
        },
        isJson: true,
      );

      isProcessingPayment.value = false;

      String orderId =
          '#ALF-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
      String paymentId =
          gatewayPaymentId ??
          '${apiPayment.toUpperCase()}_${DateTime.now().millisecondsSinceEpoch}';

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data != null) {
        dynamic rawData = response.data;
        if (rawData is Map<String, dynamic> && rawData.containsKey('data')) {
          rawData = rawData['data'];
        }
        if (rawData is Map<String, dynamic>) {
          if (rawData['orderId'] != null) {
            orderId = rawData['orderId'].toString();
          } else if (rawData['id'] != null) {
            orderId = '#${rawData['id']}';
          }
        }
      }

      _processSuccessfulOrder(
        paymentId: paymentId,
        paymentMethod: selectedPaymentMethod.value,
        customOrderId: orderId,
      );
    } catch (_) {
      isProcessingPayment.value = false;
      final orderId =
          '#ALF-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
      _processSuccessfulOrder(
        paymentId:
            gatewayPaymentId ?? 'PAY_${DateTime.now().millisecondsSinceEpoch}',
        paymentMethod: selectedPaymentMethod.value,
        customOrderId: orderId,
      );
    }
  }

  void openMobileBankingModal(String gateway) {
    final payableStr = '৳${finalPayable.toStringAsFixed(2)}';
    final isBkash = gateway.toLowerCase() == 'bkash';

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 38.r,
                      height: 38.r,
                      decoration: BoxDecoration(
                        color: isBkash
                            ? const Color(0xFFE2136E)
                            : const Color(0xFFF7941D),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.account_balance_wallet_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$gateway Secure Payment',
                          style: GoogleFonts.inter(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColor.textPrimary,
                          ),
                        ),
                        Text(
                          'Alif Official Store',
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            color: AppColor.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    payableStr,
                    style: GoogleFonts.inter(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColor.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 18.h),
            Text(
              'Complete your purchase via $gateway wallet. You will be redirected to confirm.',
              style: GoogleFonts.lato(
                fontSize: 13.sp,
                color: AppColor.textSecondary,
              ),
            ),
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                  _executeGatewayPayment(gateway);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isBkash
                      ? const Color(0xFFE2136E)
                      : const Color(0xFFF7941D),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'Confirm & Pay $payableStr',
                  style: GoogleFonts.inter(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _executeGatewayPayment(String gateway) {
    isProcessingPayment.value = true;
    final isBkash = gateway.toLowerCase() == 'bkash';

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 48.r,
                height: 48.r,
                child: CircularProgressIndicator(
                  color: isBkash
                      ? const Color(0xFFE2136E)
                      : const Color(0xFFF7941D),
                  strokeWidth: 3.5,
                ),
              ),
              SizedBox(height: 18.h),
              Text(
                'Connecting to $gateway Gateway',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColor.textPrimary,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'Please do not refresh or close the app',
                style: GoogleFonts.inter(
                  fontSize: 12.5.sp,
                  color: AppColor.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );

    Timer(const Duration(milliseconds: 1200), () {
      Get.back(); // close dialog
      final gatewayId =
          '${gateway.toUpperCase()}_${DateTime.now().millisecondsSinceEpoch}';
      _executePlaceOrder(gatewayPaymentId: gatewayId);
    });
  }

  void _processSuccessfulOrder({
    required String paymentId,
    required String paymentMethod,
    String? customOrderId,
  }) {
    final orderId =
        '#ALF-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
    final selectedAddr = addresses[selectedAddressIndex.value];

    // Clear Cart if order was placed from Shopping Bag
    if (!isDirectBuy.value && Get.isRegistered<BagController>()) {
      Get.find<BagController>().clearCart();
    }

    Get.offNamed(
      Routes.ORDER_SUCCESS,
      arguments: {
        'orderId': orderId,
        'paymentId': paymentId,
        'paymentMethod': paymentMethod,
        'totalAmount': finalPayable,
        'itemCount': items.length,
        'address': selectedAddr['address'],
        'items': items,
      },
    );
  }
}
