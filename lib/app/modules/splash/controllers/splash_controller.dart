import 'package:flutter/animation.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> logoScaleAnimation;
  late Animation<double> logoFadeAnimation;
  late Animation<Offset> textSlideAnimation;
  late Animation<double> textFadeAnimation;
  late Animation<double> taglineFadeAnimation;

  @override
  void onInit() {
    super.onInit();
    _initAnimations();
    _startAnimationAndNavigate();
  }

  void _initAnimations() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    logoScaleAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOutBack),
      ),
    );

    logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.45, curve: Curves.easeIn),
      ),
    );

    textSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero).animate(
          CurvedAnimation(
            parent: animationController,
            curve: const Interval(0.4, 0.8, curve: Curves.easeOutCubic),
          ),
        );

    textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.4, 0.75, curve: Curves.easeIn),
      ),
    );

    taglineFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.65, 1.0, curve: Curves.easeIn),
      ),
    );
  }

  void _startAnimationAndNavigate() async {
    await animationController.forward();
    await Future.delayed(const Duration(milliseconds: 600));
    Get.offNamed(Routes.ONBOARDING);
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
