import 'package:animated_theme_switcher/animated_theme_switcher.dart';
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
    return ThemeProvider(
      initTheme: Get.find<ThemeController>().getTheme(),
      builder: (context, themeData) => GetMaterialApp(
        title: 'GrowthPad',
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.cupertino,
        initialBinding: GlobalBindings(),
        // theme: controller.getTheme(),
        theme: themeData,
        home: const SplashScreen(),
        scrollBehavior: const CupertinoScrollBehavior().copyWith(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        ),
      ),
    );
  }
}
