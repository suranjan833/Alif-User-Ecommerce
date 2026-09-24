import 'package:get/get.dart';

import '../../account/controllers/account_controller.dart';
import '../../bag/controllers/bag_controller.dart';
import '../../categories/controllers/categories_controller.dart';
import '../../discover/controllers/discover_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/main_navigation_controller.dart';

class MainNavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainNavigationController>(() => MainNavigationController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<CategoriesController>(() => CategoriesController());
    Get.lazyPut<DiscoverController>(() => DiscoverController());
    Get.lazyPut<BagController>(() => BagController());
    Get.lazyPut<AccountController>(() => AccountController());
  }
}
