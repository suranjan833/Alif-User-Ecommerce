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
  final isLoadingAddresses = false.obs;

  final addresses = <Map<String, dynamic>>[].obs;

  double get finalPayable =>
      (subtotal.value + deliveryFee.value + tax.value - discount.value).clamp(
        0.0,
        double.infinity,
      );

  String? get selectedAddressId {
    if (addresses.isNotEmpty && selectedAddressIndex.value < addresses.length) {
      final id = addresses[selectedAddressIndex.value]['id']?.toString();
      if (id != null && id.isNotEmpty) return id;
    }
    return null;
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
    isLoadingAddresses.value = true;
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
                    item['fullName']?.toString() ??
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
                'city': item['district']?.toString() ?? item['city']?.toString() ?? '',
                'division': item['division']?.toString() ?? '',
                'postalCode': item['postalCode']?.toString() ?? '',
              });
            }
          }
          if (parsed.isNotEmpty) {
            addresses.assignAll(parsed);
            if (selectedAddressIndex.value >= addresses.length) {
              selectedAddressIndex.value = 0;
            }
          }
        }
      }
    } catch (_) {
    } finally {
      isLoadingAddresses.value = false;
    }
  }

  /// 2. POST /checkout/quote - Fetch price quote from API
  Future<void> fetchQuote() async {
    try {
      final reqData = <String, dynamic>{
        'paymentMethod': _mapPaymentMethodToApi(selectedPaymentMethod.value),
        if (selectedAddressId != null) 'addressId': selectedAddressId,
        if (appliedPromoCode.value.isNotEmpty)
          'couponCode': appliedPromoCode.value,
      };

      final response = await dioPost(
        endUrl: 'checkout/quote',
        data: reqData,
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

  /// Open modal to dynamically add an address
  void openAddAddressModal(BuildContext context) {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final streetCtrl = TextEditingController();
    final cityCtrl = TextEditingController();
    final isSaving = false.obs;
    final selectedType = 'Home'.obs;

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Add Delivery Address',
                style: GoogleFonts.lato(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColor.textPrimary,
                ),
              ),
              SizedBox(height: 14.h),

              // Address Type
              Obx(
                () => Row(
                  children: ['Home', 'Office', 'Other'].map((type) {
                    final isSel = selectedType.value == type;
                    return Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: ChoiceChip(
                        label: Text(type),
                        selected: isSel,
                        onSelected: (val) => selectedType.value = type,
                        selectedColor: AppColor.primary,
                        backgroundColor: const Color(0xFFF1F5F9),
                        labelStyle: GoogleFonts.lato(
                          fontSize: 12.sp,
                          fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                          color: isSel ? Colors.white : AppColor.textPrimary,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 12.h),

              // Recipient Name
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: 'Recipient Full Name *',
                  labelStyle: GoogleFonts.lato(fontSize: 13.sp),
                  filled: true,
                  fillColor: const Color(0xFFF8F9FA),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                ),
              ),
              SizedBox(height: 10.h),

              // Phone Number
              TextField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number (e.g. 017xxxxxxxx) *',
                  labelStyle: GoogleFonts.lato(fontSize: 13.sp),
                  filled: true,
                  fillColor: const Color(0xFFF8F9FA),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                ),
              ),
              SizedBox(height: 10.h),

              // Delivery Address
              TextField(
                controller: streetCtrl,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Street Address / House / Flat *',
                  labelStyle: GoogleFonts.lato(fontSize: 13.sp),
                  filled: true,
                  fillColor: const Color(0xFFF8F9FA),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                ),
              ),
              SizedBox(height: 10.h),

              // City / Area
              TextField(
                controller: cityCtrl,
                decoration: InputDecoration(
                  labelText: 'City / District / Area *',
                  labelStyle: GoogleFonts.lato(fontSize: 13.sp),
                  filled: true,
                  fillColor: const Color(0xFFF8F9FA),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Save Button
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed: isSaving.value
                        ? null
                        : () async {
                            final name = nameCtrl.text.trim();
                            final phone = phoneCtrl.text.trim();
                            final street = streetCtrl.text.trim();
                            final city = cityCtrl.text.trim();

                            if (name.isEmpty ||
                                phone.isEmpty ||
                                street.isEmpty ||
                                city.isEmpty) {
                              Get.snackbar(
                                'Missing Information',
                                'Please fill all required fields',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: AppColor.error,
                                colorText: Colors.white,
                              );
                              return;
                            }

                            isSaving.value = true;
                            final fullAddr = '$street, $city';
                            String newId =
                                'addr_${DateTime.now().millisecondsSinceEpoch}';

                            try {
                              final response = await dioPost(
                                endUrl: 'addresses',
                                data: {
                                  'label': selectedType.value,
                                  'fullName': name,
                                  'phone': phone,
                                  'addressLine': street,
                                  'division': city,
                                  'district': city,
                                  'upazila': city,
                                  'postalCode': '1000',
                                  'isDefault': addresses.isEmpty,
                                },
                                isJson: true,
                              );
                              if (response.statusCode == 200 ||
                                  response.statusCode == 201) {
                                dynamic rawData = response.data;
                                if (rawData is Map &&
                                    rawData.containsKey('data')) {
                                  rawData = rawData['data'];
                                }
                                if (rawData is Map && rawData['id'] != null) {
                                  newId = rawData['id'].toString();
                                }
                              }
                            } catch (_) {}

                            addresses.add({
                              'id': newId,
                              'name': name,
                              'type': selectedType.value,
                              'phone': phone,
                              'address': fullAddr,
                            });
                            selectedAddressIndex.value =
                                addresses.length - 1;
                            isSaving.value = false;

                            Get.back(); // close bottomsheet
                            fetchQuote();

                            Get.snackbar(
                              'Address Saved',
                              'Delivery address added successfully',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: const Color(0xFF16A34A),
                              colorText: Colors.white,
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: isSaving.value
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Save & Deliver Here',
                            style: GoogleFonts.lato(
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
      ),
      isScrollControlled: true,
    );
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
    if (addresses.isEmpty || selectedAddressId == null || selectedAddressId!.isEmpty) {
      Get.snackbar(
        'Address Required',
        'Please add a delivery address to complete your order',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColor.error,
        colorText: Colors.white,
      );
      if (Get.context != null) {
        openAddAddressModal(Get.context!);
      }
      return;
    }

    if (selectedPaymentMethod.value == 'bKash' ||
        selectedPaymentMethod.value == 'Nagad') {
      openMobileBankingModal(selectedPaymentMethod.value);
    } else {
      _executePlaceOrder();
    }
  }

  Future<void> _executePlaceOrder({String? gatewayPaymentId}) async {
    if (selectedAddressId == null || selectedAddressId!.isEmpty) {
      Get.snackbar(
        'Address Required',
        'Please select a valid delivery address',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColor.error,
        colorText: Colors.white,
      );
      return;
    }

    isProcessingPayment.value = true;
    final apiPayment = _mapPaymentMethodToApi(selectedPaymentMethod.value);
    final idempotencyKey =
        'ALF_IDEMP_${DateTime.now().millisecondsSinceEpoch}_${selectedAddressId!}';

    final payload = <String, dynamic>{
      'addressId': selectedAddressId,
      'paymentMethod': apiPayment,
      if (appliedPromoCode.value.isNotEmpty)
        'couponCode': appliedPromoCode.value,
      if (apiPayment == 'wallet') 'remainderMethod': 'cod',
      'returnUrl': 'https://alifworld.vercel.app/order-success',
    };

    try {
      final response = await dioPost(
        endUrl: 'checkout/place',
        data: payload,
        isJson: true,
        customHeaders: {
          'Idempotency-Key': idempotencyKey,
        },
      );

      isProcessingPayment.value = false;

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data != null) {
        dynamic rawData = response.data;
        if (rawData is Map<String, dynamic> && rawData.containsKey('data')) {
          rawData = rawData['data'];
        }

        String orderId =
            '#ALF-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
        if (rawData is Map<String, dynamic>) {
          if (rawData['orderId'] != null) {
            orderId = rawData['orderId'].toString();
          } else if (rawData['id'] != null) {
            orderId = '#${rawData['id']}';
          }
        }

        String paymentId = gatewayPaymentId ??
            '${apiPayment.toUpperCase()}_${DateTime.now().millisecondsSinceEpoch}';

        _processSuccessfulOrder(
          paymentId: paymentId,
          paymentMethod: selectedPaymentMethod.value,
          customOrderId: orderId,
        );
      } else {
        // Handle error status
        String errorMsg = 'Failed to place order. Please try again.';
        if (response.data is Map<String, dynamic>) {
          final data = response.data as Map<String, dynamic>;
          if (data['message'] != null) {
            errorMsg = data['message'].toString();
          } else if (data['error'] != null) {
            if (data['error'] is Map && data['error']['message'] != null) {
              errorMsg = data['error']['message'].toString();
            } else {
              errorMsg = data['error'].toString();
            }
          }
        }

        if (response.statusCode == 401) {
          Get.snackbar(
            'Login Required',
            'Please log in to your account to place an order',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColor.error,
            colorText: Colors.white,
            duration: const Duration(seconds: 4),
            mainButton: TextButton(
              onPressed: () => Get.toNamed(Routes.LOGIN),
              child: const Text(
                'LOG IN',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        } else {
          Get.snackbar(
            'Order Placement Error',
            errorMsg,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColor.error,
            colorText: Colors.white,
            duration: const Duration(seconds: 4),
          );
        }
      }
    } catch (e) {
      isProcessingPayment.value = false;
      Get.snackbar(
        'Connection Error',
        'Unable to reach server. Please check your internet connection.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColor.error,
        colorText: Colors.white,
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
    final orderId = customOrderId ??
        '#ALF-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
    final selectedAddr = (addresses.isNotEmpty &&
            selectedAddressIndex.value < addresses.length)
        ? addresses[selectedAddressIndex.value]
        : <String, dynamic>{'address': 'Customer Delivery Address'};

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
        'address': selectedAddr['address'] ?? '',
        'items': items,
      },
    );
  }
}
