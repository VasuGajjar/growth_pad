import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:growthpad/helper/get_di.dart';

import '../theme/theme.dart';
import 'screens/splash/splash_screen.dart';

class GrowthPadApp extends StatelessWidget {
  const GrowthPadApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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