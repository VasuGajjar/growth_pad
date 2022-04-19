import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:growthpad/helper/get_di.dart';
import 'package:growthpad/view/base/portrait_mode_mixin.dart';

import '../theme/theme.dart';
import 'screens/splash/splash_screen.dart';

class GrowthPadApp extends StatelessWidget with PortraitModeMixin {
  const GrowthPadApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    portraitModeOnly();
    return GetMaterialApp(
      title: 'GrowthPad',
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.fadeIn,
      initialBinding: GlobalBindings(),
      theme: AppTheme.lightTheme(),
      home: const SplashScreen(),
      scrollBehavior: const CupertinoScrollBehavior().copyWith(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      ),
    );
  }
}
