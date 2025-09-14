import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_id_generator/src/core/theme/app_colors.dart';
import 'package:student_id_generator/src/feature/presentation/home/controllers/home_page_controller.dart';
import 'package:student_id_generator/src/feature/presentation/home/widgets/transformable_field.dart';
import 'package:student_id_generator/src/shared/data/enums/enums.dart';

class IdCardWidget extends StatelessWidget {
  const IdCardWidget(
      {super.key, required this.type, this.index = 0, this.image});
  final IdCardType type;
  final int index;
  final Uint8List? image;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomePageController>();

    return Obx(() {
      if (controller.templateFile.value == null) {
        return Container(
          height: 800,
          width: 600,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Please upload a template image first',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      }

      return Container(
        height: 800,
        width: 600,
        decoration: BoxDecoration(
          image: controller.templateFile.value!.file != null
              ? DecorationImage(
                  image: NetworkImage(
                    controller.templateFile.value!.file!.path,
                  ),
                  fit: BoxFit.contain,
                )
              : null,
          color: controller.templateFile.value!.file == null
              ? AppColors.colorGrey300
              : null,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            ...controller.fields.map((field) {
              return TransformableField(
                key: ValueKey(field.id),
                id: field.id,
                fieldName: field.name,
                fieldValue: controller.excelData.isNotEmpty
                    ? controller.excelData[index][field.name]?.toString() ?? ''
                    : '',
                initialPosition: field.position,
                initialSize: field.size,
                previewContainerHeight: 800,
                previewContainerWidth: 600,
                type: type,
              );
            }),
          ],
        ),
      );
    });
  }
}
