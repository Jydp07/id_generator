import 'dart:developer' as dev;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_box_transform/flutter_box_transform.dart';
import 'package:get/get.dart';
import 'package:student_id_generator/src/core/extensions/url_extenstion.dart';
import 'package:student_id_generator/src/core/theme/app_colors.dart';
import 'package:student_id_generator/src/feature/presentation/home/controllers/home_page_controller.dart';
import 'package:student_id_generator/src/feature/presentation/home/controllers/transform_controller.dart';
import 'package:student_id_generator/src/shared/data/enums/enums.dart';

class TransformableField extends StatelessWidget {
  final String id;
  final String fieldName;
  final String? fieldValue;
  final Offset initialPosition;
  final Size initialSize;
  final double previewContainerWidth;
  final double previewContainerHeight;
  final IdCardType type;
  final Uint8List? image;

  const TransformableField({
    super.key,
    required this.id,
    required this.fieldName,
    this.fieldValue,
    required this.initialPosition,
    required this.initialSize,
    required this.previewContainerWidth,
    required this.previewContainerHeight,
    required this.type,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    final homePageController = Get.find<HomePageController>();

    TransformController controller;
    if (type == IdCardType.preview) {
      final mainFieldId = id.replaceFirst('preview_', '');
      controller = Get.find<TransformController>(tag: mainFieldId);
    } else {
      controller = Get.put(
        TransformController(
          initialPosition: initialPosition,
          initialSize: initialSize,
        ),
        tag: id,
      );
    }

    return Obx(() {
      final isSelected = homePageController.selectedFieldId.value == id;
      return TransformableBox(
        rect: controller.rect,
        onChanged: (result, event) {
          controller.setRect(result.rect);
        },
        draggable: type == IdCardType.edit &&
            (homePageController.isEditMode.value && isSelected),
        resizable: type == IdCardType.edit &&
            (homePageController.isEditMode.value && isSelected),
        contentBuilder: (BuildContext context, Rect rect, Flip flip) {
          return GestureDetector(
            onTap: () {
              if (homePageController.isEditMode.value) {
                homePageController.selectField(id);
              }
            },
            child: Container(
              decoration: type == IdCardType.edit
                  ? BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(4),
                    )
                  : null,
              child: _buildFieldContent(homePageController, controller),
            ),
          );
        },
      );
    });
  }

  Widget _buildFieldContent(
    HomePageController homePageController,
    TransformController controller,
  ) {
    if ((fieldValue?.isImageUrl ?? false) &&
        homePageController.isPreviewGenerated.value &&
        type == IdCardType.preview) {
      dev.log(fieldValue.toString(), name: fieldName);
      return image != null
          ? Image.memory(
              image!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.error_outline,
                  color: AppColors.red,
                  size: (controller.rect?.height ?? 0) * 0.3,
                );
              },
            )
          : Image.network(
              fieldValue.toString().trim(),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.error_outline,
                  color: AppColors.red,
                  size: (controller.rect?.height ?? 0) * 0.3,
                );
              },
            );
    } else {
      return Center(
        child: Obx(
          () => Text(
            type == IdCardType.preview &&
                    fieldValue != null &&
                    fieldValue!.isNotEmpty
                ? fieldValue!
                : fieldName,
            style: controller.style,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }
  }
}
