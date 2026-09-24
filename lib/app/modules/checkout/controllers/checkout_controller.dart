import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../../../data/config/app_color.dart';
import '../../../routes/app_pages.dart';
import '../../bag/controllers/bag_controller.dart';

class CheckoutController extends GetxController {
  final items = <Map<String, dynamic>>[].obs;
  final subtotal = 0.0.obs;
  final deliveryFee = 0.0.obs;
  final tax = 0.0.obs;
  final discount = 0.0.obs;
  final isDirectBuy = false.obs;

  final selectedAddressIndex = 0.obs;
  final selectedPaymentMethod = 'Razorpay'.obs; // Razorpay vs COD
  final promoCodeController = TextEditingController();
  final appliedPromoCode = ''.obs;
  final isProcessingPayment = false.obs;

  final addresses = <Map<String, dynamic>>[
    {
      'name': 'User Name',
      'type': 'Home',
      'phone': '+91 98765 43210',
      'address': 'Bakali coloni, Vijay Nagar, Sector 4, Bhuj, Gujarat - 370001',
    },
    {
      'name': 'User Name',
      'type': 'Work',
      'phone': '+91 98765 43210',
      'address': 'Office 402, Alif Tower, CG Road, Ahmedabad, Gujarat - 380009',
    },
  ].obs;

  double get finalPayable =>
      (subtotal.value + deliveryFee.value + tax.value - discount.value).clamp(
        0.0,
        double.infinity,
      );

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
  }

  @override
  void onClose() {
    promoCodeController.dispose();
    super.onClose();
  }

  void selectAddress(int index) {
    selectedAddressIndex.value = index;
  }

  void selectPaymentMethod(String method) {
    selectedPaymentMethod.value = method;
  }

  void applyPromoCode() {
    final code = promoCodeController.text.trim().toUpperCase();
    if (code.isEmpty) return;

    if (code == 'ALIF50' || code == 'FIRST100') {
      discount.value = code == 'ALIF50' ? 50.0 : 100.0;
      appliedPromoCode.value = code;
      Get.snackbar(
        'Promo Applied!',
        '₹${discount.value.toStringAsFixed(0)} discount applied to order',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF16A34A),
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Invalid Promo',
        'Coupon code "$code" is invalid or expired',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColor.error,
        colorText: Colors.white,
      );
    }
  }

  void removePromoCode() {
    appliedPromoCode.value = '';
    discount.value = 0.0;
    promoCodeController.clear();
  }

  void placeOrder() {
    if (selectedPaymentMethod.value == 'Razorpay') {
      openRazorpayPaymentModal();
    } else {
      _processSuccessfulOrder(
        paymentId: 'COD_${DateTime.now().millisecondsSinceEpoch}',
        paymentMethod: 'Cash on Delivery',
      );
    }
  }

  void openRazorpayPaymentModal() {
    final payableStr = '₹${finalPayable.toStringAsFixed(2)}';
    final selectedPaymentOption = 'UPI / GPay'.obs;

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
            // Razorpay Header Banner
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36.r,
                      height: 36.r,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0C2340),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Center(
                        child: Text(
                          'R',
                          style: GoogleFonts.inter(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF00C4F4),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Razorpay Trusted',
                          style: GoogleFonts.inter(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0C2340),
                          ),
                        ),
                        Text(
                          'Alif Commerce Inc.',
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
            SizedBox(height: 16.h),
            const Divider(color: Color(0xFFF1F5F9), height: 1),
            SizedBox(height: 16.h),

            Text(
              'Select Payment Option',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: AppColor.textPrimary,
              ),
            ),
            SizedBox(height: 12.h),

            // Payment Options
            Obx(
              () => Column(
                children: [
                  _buildRazorpayOption(
                    title: 'UPI (GPay / PhonePe / Paytm)',
                    icon: Iconsax.mobile,
                    isSelected: selectedPaymentOption.value == 'UPI / GPay',
                    onTap: () => selectedPaymentOption.value = 'UPI / GPay',
                  ),
                  SizedBox(height: 8.h),
                  _buildRazorpayOption(
                    title: 'Credit / Debit Card',
                    icon: Iconsax.card,
                    isSelected: selectedPaymentOption.value == 'Card',
                    onTap: () => selectedPaymentOption.value = 'Card',
                  ),
                  SizedBox(height: 8.h),
                  _buildRazorpayOption(
                    title: 'Net Banking',
                    icon: Iconsax.bank,
                    isSelected: selectedPaymentOption.value == 'Net Banking',
                    onTap: () => selectedPaymentOption.value = 'Net Banking',
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // Pay Button
            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: isProcessingPayment.value
                      ? null
                      : () {
                          Get.back();
                          _executeRazorpayPayment(selectedPaymentOption.value);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0284C7),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: isProcessingPayment.value
                      ? SizedBox(
                          width: 24.r,
                          height: 24.r,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          'Pay $payableStr via Razorpay',
                          style: GoogleFonts.inter(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
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

  Widget _buildRazorpayOption({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF0F9FF) : const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF0284C7)
                : const Color(0xFFE2E8F0),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20.r,
              color: isSelected
                  ? const Color(0xFF0284C7)
                  : AppColor.textSecondary,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: AppColor.textPrimary,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                size: 18.r,
                color: const Color(0xFF0284C7),
              ),
          ],
        ),
      ),
    );
  }

  void _executeRazorpayPayment(String option) {
    isProcessingPayment.value = true;

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
                child: const CircularProgressIndicator(
                  color: Color(0xFF0284C7),
                  strokeWidth: 3.5,
                ),
              ),
              SizedBox(height: 18.h),
              Text(
                'Connecting to Razorpay',
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

    Timer(const Duration(milliseconds: 1400), () {
      Get.back(); // close loading dialog
      isProcessingPayment.value = false;

      final razorpayPaymentId =
          'pay_Rzp${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';

      _processSuccessfulOrder(
        paymentId: razorpayPaymentId,
        paymentMethod: 'Razorpay Online ($option)',
      );
    });
  }

  void _processSuccessfulOrder({
    required String paymentId,
    required String paymentMethod,
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
