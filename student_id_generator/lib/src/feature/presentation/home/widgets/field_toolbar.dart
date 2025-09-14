import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_id_generator/src/core/constants/app_strings.dart';
import 'package:student_id_generator/src/core/extensions/url_extenstion.dart';

import 'package:student_id_generator/src/core/theme/app_colors.dart';
import 'package:student_id_generator/src/feature/data/models/id_card_fields.dart';
import 'package:student_id_generator/src/feature/presentation/home/controllers/home_page_controller.dart';
import 'package:student_id_generator/src/feature/presentation/home/controllers/transform_controller.dart';
import 'package:student_id_generator/src/shared/data/enums/enums.dart';

class FieldToolbar extends StatelessWidget {
  const FieldToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomePageController>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Obx(
      () => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: colorScheme.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Edit mode toggle
            Row(
              children: [
                Icon(
                  controller.isEditMode.value ? Icons.edit : Icons.edit_off,
                  color: controller.isEditMode.value
                      ? AppColors.blue
                      : colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Text(
                  controller.isEditMode.value
                      ? AppStrings.editMode
                      : AppStrings.viewMode,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: controller.isEditMode.value
                        ? AppColors.blue
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                Switch(
                  value: controller.isEditMode.value,
                  onChanged: (value) => controller.toggleEditMode(),
                ),
              ],
            ),

            if (controller.isEditMode.value &&
                controller.fields.isNotEmpty) ...[
              const Divider(),
              const SizedBox(height: 8),

              // Field management
              Text(
                "${AppStrings.fields} (${controller.fields.length}):",
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),

              // Field list
              ...controller.fields.map(
                (field) => _buildFieldItem(context, field),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFieldItem(BuildContext context, IDCardField field) {
    final controller = Get.find<HomePageController>();
    final transformController = Get.find<TransformController>(tag: field.id);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: field.isSelected
            ? AppColors.blue.withOpacity(0.1)
            : colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: field.isSelected ? AppColors.blue : colorScheme.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          Icon(
            _getFieldIcon(field.type),
            size: 16,
            color: field.isSelected
                ? AppColors.blue
                : colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              field.name,
              style: theme.textTheme.labelMedium?.copyWith(
                color:
                    field.isSelected ? AppColors.blue : colorScheme.onSurface,
                fontWeight:
                    field.isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, size: 16),
            color: AppColors.blue,
            onPressed: () => openEditDialog(
              id: field.id,
              initialFontSize: transformController.style.fontSize!,
              initialBold: false,
              initialItalic: false,
              initialUnderline: false,
              color: transformController.color,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
          ),
          IconButton(
            icon: const Icon(Icons.delete, size: 16),
            color: AppColors.red,
            onPressed: () => controller.removeField(field.id),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
          ),
        ],
      ),
    );
  }

  IconData _getFieldIcon(FieldType type) {
    switch (type) {
      case FieldType.text:
        return Icons.text_fields;
      case FieldType.image:
        return Icons.image;
      case FieldType.label:
        return Icons.label;
    }
  }

  void openEditDialog({
    required double initialFontSize,
    required String id,
    required bool initialBold,
    required bool initialItalic,
    required bool initialUnderline,
    required Color color,
  }) {
    final controller = Get.find<TransformController>(tag: id);
    Get.dialog(
      AlertDialog(
        title: const Text(AppStrings.editTextStyle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Text(AppStrings.size),
                Obx(
                  () => Expanded(
                    child: Slider(
                      min: 10,
                      max: 40,
                      value: controller.fontSize,
                      onChanged: (value) {
                        controller.setFontSize(value);
                      },
                      label: controller.fontSize.toStringAsFixed(0),
                      divisions: 30,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Obx(() => Text(controller.fontSize.toStringAsFixed(0))),
              ],
            ),
            // Bold Toggle
            Obx(
              () => CheckboxListTile(
                title: const Text(AppStrings.bold),
                value: controller.isBold,
                onChanged: (value) {
                  controller.setBold(value!);
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),
            ),
            // Italic Toggle
            Obx(
              () => CheckboxListTile(
                title: const Text(AppStrings.italic),
                value: controller.isItalic,
                onChanged: (value) {
                  controller.setItalic(value!);
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),
            ),
            // Underline Toggle
            Obx(
              () => CheckboxListTile(
                title: const Text(AppStrings.underline),
                value: controller.isUnderline,
                onChanged: (value) {
                  controller.setUnderline(value!);
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),
            ),
            Obx(() {
              final selectedColor = controller.style.color ?? Colors.black;
              return Row(
                children: [
                  const Text(AppStrings.colorColon),
                  const SizedBox(width: 8),
                  ...controller.colors.map((color) {
                    final isSelected = selectedColor.value == color.value;
                    return GestureDetector(
                      onTap: () {
                        controller.setStyle(
                          controller.style.copyWith(color: color),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(
                                  color: Colors.grey.shade800,
                                  width: 2,
                                )
                              : null,
                        ),
                        child: isSelected
                            ? const Icon(Icons.check,
                                color: Colors.white, size: 18)
                            : null,
                      ),
                    );
                  }),
                ],
              );
            }),
          ],
        ),
        actions: [
          TextButton(
              child: const Text(AppStrings.cancel),
              onPressed: () => Get.back()),
          ElevatedButton(
            child: const Text(AppStrings.back),
            onPressed: () {
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}
