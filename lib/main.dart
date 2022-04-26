import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growthpad/core/controller/theme_controller.dart';
import 'package:growthpad/core/service/notification_service.dart';
import 'package:growthpad/view/growthpad.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService.initialize();
  var themeController = await ThemeController.getInstance();
  Get.lazyPut<ThemeController>(() => themeController);

  runApp(const GrowthPadApp());
}
