import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:growthpad/view/base/progressbar.dart';

/// Don't Use Overlays in initState or before the build method has called.
/// (Toast can be used)
class AppOverlay {
  static void showProgressBar() {
    Get.dialog(
      const Center(child: Progressbar()),
      barrierDismissible: false,
    );
  }

  static void closeProgressBar() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  static void showSuccessSnackbar(String message) {}

  static void showErrorSnackbar(String message) {}

  static void showToast(String message) {
    Fluttertoast.showToast(msg: message);
  }
}
