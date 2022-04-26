import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:growthpad/core/controller/theme_controller.dart';
import 'package:growthpad/helper/get_di.dart';
import 'package:growthpad/view/base/portrait_mode_mixin.dart';

import 'screens/splash/splash_screen.dart';

class GrowthPadApp extends StatelessWidget with PortraitModeMixin {
  const GrowthPadApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    portraitModeOnly();
    return GetBuilder<ThemeController>(
        init: Get.find<ThemeController>(),
        builder: (controller) {
          return GetMaterialApp(
            title: 'GrowthPad',
            debugShowCheckedModeBanner: false,
            defaultTransition: Transition.fadeIn,
            initialBinding: GlobalBindings(),
            theme: controller.getTheme(),
            home: const SplashScreen(),
            scrollBehavior: const CupertinoScrollBehavior().copyWith(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            ),
          );
        });
  }
}
