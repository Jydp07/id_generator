import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_id_generator/src/core/theme/app_colors.dart';

import '../../shared/data/enums/enums.dart';

class SnackbarUtility {
  static void showSnackbar(String message, SnackbarType type) {
    Get.snackbar(
      type.title,
      message,
      backgroundColor: _getBackgroundColor(type),
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(12),
    );
  }

  static Color _getBackgroundColor(SnackbarType type) {
    switch (type) {
      case SnackbarType.error:
        return AppColors.red;
      case SnackbarType.success:
        return AppColors.green;
      case SnackbarType.info:
        return AppColors.blue;
    }
  }
}
