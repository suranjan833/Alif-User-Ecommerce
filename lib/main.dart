import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app/data/config/app_color.dart';
import 'app/routes/app_pages.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: "ALIF",
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: AppColor.background,
            textTheme: GoogleFonts.latoTextTheme(),
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColor.primary,
              primary: AppColor.primary,
            ),
          ),
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
        );
      },
    ),
  );
}
