import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingUtility {
  static void start() {
    Get.dialog(
      Center(child: CircularProgressIndicator()),
    );
  }

  static void stop() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }
}
