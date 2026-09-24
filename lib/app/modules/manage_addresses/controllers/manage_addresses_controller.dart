import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/config/app_color.dart';

class AddressModel {
  final String id;
  final String name;
  final String phone;
  final String street;
  final String city;
  final String state;
  final String pincode;
  final String type; // Home, Work, Other
  bool isDefault;

  AddressModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.street,
    required this.city,
    required this.state,
    required this.pincode,
    required this.type,
    this.isDefault = false,
  });
}

class ManageAddressesController extends GetxController {
  final addresses = <AddressModel>[
    AddressModel(
      id: 'addr_1',
      name: 'User Name',
      phone: '+91 98765 43210',
      street: 'Bakali coloni, Vijay Nagar, Sector 4',
      city: 'Bhuj',
      state: 'Gujarat',
      pincode: '370001',
      type: 'Home',
      isDefault: true,
    ),
    AddressModel(
      id: 'addr_2',
      name: 'User Name',
      phone: '+91 98765 43210',
      street: 'Office 402, Alif Tower, CG Road',
      city: 'Ahmedabad',
      state: 'Gujarat',
      pincode: '380009',
      type: 'Work',
      isDefault: false,
    ),
  ].obs;

  void setDefaultAddress(String addressId) {
    for (var addr in addresses) {
      addr.isDefault = (addr.id == addressId);
    }
    addresses.refresh();
    Get.snackbar(
      'Default Address',
      'Default delivery address updated',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColor.textPrimary,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void deleteAddress(String addressId) {
    addresses.removeWhere((addr) => addr.id == addressId);
    Get.snackbar(
      'Address Removed',
      'Address has been removed',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColor.error,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void openAddAddressSheet(BuildContext context) {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final streetCtrl = TextEditingController();
    final cityCtrl = TextEditingController(text: 'Bhuj');
    final stateCtrl = TextEditingController(text: 'Gujarat');
    final pincodeCtrl = TextEditingController();
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
                'Add New Address',
                style: GoogleFonts.lato(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColor.textPrimary,
                ),
              ),
              SizedBox(height: 16.h),

              // Address Type Selector
              Obx(
                () => Row(
                  children: ['Home', 'Work', 'Other'].map((type) {
                    final isSel = selectedType.value == type;
                    return Padding(
                      padding: EdgeInsets.only(right: 10.w),
                      child: ChoiceChip(
                        label: Text(type),
                        selected: isSel,
                        onSelected: (val) => selectedType.value = type,
                        selectedColor: AppColor.primary,
                        backgroundColor: const Color(0xFFF1F5F9),
                        labelStyle: GoogleFonts.lato(
                          fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                          color: isSel
                              ? AppColor.textPrimary
                              : AppColor.textSecondary,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 14.h),

              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Full Name'),
              ),
              SizedBox(height: 10.h),
              TextField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Phone Number'),
              ),
              SizedBox(height: 10.h),
              TextField(
                controller: streetCtrl,
                decoration: const InputDecoration(
                  labelText: 'House/Street/Locality',
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: cityCtrl,
                      decoration: const InputDecoration(labelText: 'City'),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: TextField(
                      controller: pincodeCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Pincode'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),

              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: () {
                    if (nameCtrl.text.trim().isEmpty ||
                        streetCtrl.text.trim().isEmpty) {
                      Get.snackbar(
                        'Error',
                        'Please fill in the required fields',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                      return;
                    }

                    addresses.add(
                      AddressModel(
                        id: 'addr_${DateTime.now().millisecondsSinceEpoch}',
                        name: nameCtrl.text.trim(),
                        phone: phoneCtrl.text.trim(),
                        street: streetCtrl.text.trim(),
                        city: cityCtrl.text.trim().isEmpty
                            ? 'Bhuj'
                            : cityCtrl.text.trim(),
                        state: stateCtrl.text.trim(),
                        pincode: pincodeCtrl.text.trim(),
                        type: selectedType.value,
                        isDefault: addresses.isEmpty,
                      ),
                    );

                    Get.back();
                    Get.snackbar(
                      'Success',
                      'Address added successfully',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: AppColor.textPrimary,
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
                  child: Text(
                    'Save Address',
                    style: GoogleFonts.lato(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColor.textPrimary,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}
