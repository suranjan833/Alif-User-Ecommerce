import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../../../data/config/app_color.dart';
import '../../../routes/app_pages.dart';
import '../controllers/checkout_controller.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: AppColor.textPrimary,
            size: 24.r,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Checkout',
          style: GoogleFonts.lato(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: AppColor.textPrimary,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Delivery Address Card
                  _buildSectionHeader(
                    'Delivery Address',
                    actionText: 'Manage',
                    onAction: () => Get.toNamed(Routes.MANAGE_ADDRESSES),
                  ),
                  SizedBox(height: 8.h),
                  Obx(
                    () => Column(
                      children: List.generate(controller.addresses.length, (
                        index,
                      ) {
                        final addr = controller.addresses[index];
                        final isSelected =
                            controller.selectedAddressIndex.value == index;

                        return Padding(
                          padding: EdgeInsets.only(bottom: 10.h),
                          child: Material(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColor.primary
                                      : Colors.transparent,
                                  width: 1.5.w,
                                ),
                              ),
                              child: RadioListTile<int>(
                                value: index,
                                groupValue:
                                    controller.selectedAddressIndex.value,
                                activeColor: AppColor.primaryDark,
                                onChanged: (val) =>
                                    controller.selectAddress(val ?? 0),
                                title: Row(
                                  children: [
                                    Text(
                                      addr['type'] as String,
                                      style: GoogleFonts.lato(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.textPrimary,
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      addr['phone'] as String,
                                      style: GoogleFonts.lato(
                                        fontSize: 12.sp,
                                        color: AppColor.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Padding(
                                  padding: EdgeInsets.only(top: 4.h),
                                  child: Text(
                                    addr['address'] as String,
                                    style: GoogleFonts.lato(
                                      fontSize: 13.sp,
                                      color: AppColor.textSecondary,
                                      height: 1.3,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  SizedBox(height: 14.h),

                  // 2. Order Items Card
                  _buildSectionHeader('Order Items'),
                  SizedBox(height: 8.h),
                  Obx(
                    () => Container(
                      padding: EdgeInsets.all(14.r),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Column(
                        children: List.generate(controller.items.length, (
                          index,
                        ) {
                          final item = controller.items[index];
                          final isLast = index == controller.items.length - 1;
                          final price = item['price'] as double;
                          final qty = item['quantity'] as int;

                          return Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 48.r,
                                    height: 48.r,
                                    padding: EdgeInsets.all(4.r),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF8F9FA),
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: Image.network(
                                      item['image'] as String? ?? '',
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (context, error, stackTrace) => Icon(
                                            Iconsax.image,
                                            size: 22.r,
                                            color: AppColor.textSecondary,
                                          ),
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['title'] as String? ?? 'Product',
                                          style: GoogleFonts.lato(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold,
                                            color: AppColor.textPrimary,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 2.h),
                                        Text(
                                          'Qty: $qty • ₹${price.toStringAsFixed(2)}',
                                          style: GoogleFonts.lato(
                                            fontSize: 12.sp,
                                            color: AppColor.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '₹${(price * qty).toStringAsFixed(2)}',
                                    style: GoogleFonts.lato(
                                      fontSize: 14.5.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              if (!isLast)
                                Divider(
                                  color: const Color(0xFFF1F5F9),
                                  height: 16.h,
                                ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                  SizedBox(height: 14.h),

                  // 3. Promo Code Section
                  _buildSectionHeader('Promo Code'),
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.all(14.r),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Obx(() {
                      final hasApplied =
                          controller.appliedPromoCode.value.isNotEmpty;

                      if (hasApplied) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.discount_rounded,
                                  color: const Color(0xFF16A34A),
                                  size: 20.r,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'Coupon "${controller.appliedPromoCode.value}" Applied',
                                  style: GoogleFonts.lato(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF16A34A),
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.close_rounded,
                                color: AppColor.error,
                                size: 18.r,
                              ),
                              onPressed: () => controller.removePromoCode(),
                            ),
                          ],
                        );
                      }

                      return Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: controller.promoCodeController,
                              textCapitalization: TextCapitalization.characters,
                              style: GoogleFonts.lato(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Enter Coupon Code (e.g. ALIF50)',
                                hintStyle: GoogleFonts.lato(
                                  fontSize: 13.sp,
                                  color: AppColor.textHint,
                                  letterSpacing: 0,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 14.w,
                                  vertical: 10.h,
                                ),
                                filled: true,
                                fillColor: const Color(0xFFF8F9FA),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFE2E8F0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          ElevatedButton(
                            onPressed: () => controller.applyPromoCode(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.primary,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            child: Text(
                              'Apply',
                              style: GoogleFonts.lato(
                                fontSize: 13.5.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColor.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                  SizedBox(height: 14.h),

                  // 4. Payment Method Selection
                  _buildSectionHeader('Payment Method'),
                  SizedBox(height: 8.h),
                  Obx(
                    () => Container(
                      padding: EdgeInsets.all(14.r),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Column(
                        children: [
                          // Razorpay Online Radio Option
                          _buildPaymentMethodTile(
                            id: 'Razorpay',
                            title: 'Razorpay Online Payment',
                            subtitle: 'Instant UPI (GPay, PhonePe), Cards, Net Banking',
                            iconWidget: Container(
                              width: 30.r,
                              height: 30.r,
                              decoration: BoxDecoration(
                                color: const Color(0xFF0C2340),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Center(
                                child: Text(
                                  'R',
                                  style: GoogleFonts.inter(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w900,
                                    color: const Color(0xFF00C4F4),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Divider(color: Color(0xFFF1F5F9), height: 16),

                          // COD Option
                          _buildPaymentMethodTile(
                            id: 'COD',
                            title: 'Cash on Delivery (COD)',
                            subtitle: 'Pay cash upon delivery',
                            iconWidget: Icon(
                              Iconsax.money_send,
                              size: 24.r,
                              color: AppColor.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 14.h),

                  // 5. Payment Breakdown Summary Card
                  Obx(
                    () => Container(
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Price Details',
                            style: GoogleFonts.lato(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColor.textPrimary,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          _buildDetailRow(
                            'Items Subtotal',
                            '₹${controller.subtotal.value.toStringAsFixed(2)}',
                          ),
                          SizedBox(height: 8.h),
                          _buildDetailRow(
                            'Delivery Charge',
                            controller.deliveryFee.value == 0
                                ? 'FREE'
                                : '₹${controller.deliveryFee.value.toStringAsFixed(2)}',
                            isGreen: controller.deliveryFee.value == 0,
                          ),
                          SizedBox(height: 8.h),
                          _buildDetailRow(
                            'Estimated Tax',
                            '₹${controller.tax.value.toStringAsFixed(2)}',
                          ),
                          if (controller.discount.value > 0) ...[
                            SizedBox(height: 8.h),
                            _buildDetailRow(
                              'Promo Discount',
                              '- ₹${controller.discount.value.toStringAsFixed(2)}',
                              isGreen: true,
                            ),
                          ],
                          SizedBox(height: 10.h),
                          const Divider(color: Color(0xFFF1F5F9), height: 1),
                          SizedBox(height: 10.h),
                          _buildDetailRow(
                            'Total Amount',
                            '₹${controller.finalPayable.toStringAsFixed(2)}',
                            isBold: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),

          // Bottom Action Bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: const Color(0xFFE2E8F0), width: 1.w),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Payable',
                        style: GoogleFonts.lato(
                          fontSize: 12.sp,
                          color: AppColor.textSecondary,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Obx(
                        () => Text(
                          '₹${controller.finalPayable.toStringAsFixed(2)}',
                          style: GoogleFonts.lato(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColor.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 48.h,
                    child: Obx(
                      () => ElevatedButton(
                        onPressed: () => controller.placeOrder(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              controller.selectedPaymentMethod.value ==
                                  'Razorpay'
                              ? const Color(0xFF0284C7)
                              : AppColor.primary,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                        ),
                        child: Text(
                          controller.selectedPaymentMethod.value == 'Razorpay'
                              ? 'Pay with Razorpay'
                              : 'Place Order',
                          style: GoogleFonts.lato(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color:
                                controller.selectedPaymentMethod.value ==
                                    'Razorpay'
                                ? Colors.white
                                : AppColor.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    String title, {
    String? actionText,
    VoidCallback? onAction,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.lato(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppColor.textPrimary,
          ),
        ),
        if (actionText != null && onAction != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionText,
              style: GoogleFonts.lato(
                fontSize: 13.5.sp,
                fontWeight: FontWeight.bold,
                color: AppColor.primaryDark,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPaymentMethodTile({
    required String id,
    required String title,
    required String subtitle,
    required Widget iconWidget,
  }) {
    final isSelected = controller.selectedPaymentMethod.value == id;

    return InkWell(
      onTap: () => controller.selectPaymentMethod(id),
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF0F9FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Radio<String>(
              value: id,
              groupValue: controller.selectedPaymentMethod.value,
              activeColor: const Color(0xFF0284C7),
              onChanged: (val) => controller.selectPaymentMethod(val!),
            ),
            iconWidget,
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.lato(
                      fontSize: 14.5.sp,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w600,
                      color: AppColor.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: GoogleFonts.lato(
                      fontSize: 12.sp,
                      color: AppColor.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    bool isBold = false,
    bool isGreen = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.lato(
            fontSize: isBold ? 15.sp : 13.5.sp,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: isBold ? AppColor.textPrimary : AppColor.textSecondary,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.lato(
            fontSize: isBold ? 17.sp : 14.sp,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            color: isGreen
                ? const Color(0xFF16A34A)
                : (isBold ? AppColor.textPrimary : AppColor.textPrimary),
          ),
        ),
      ],
    );
  }
}
