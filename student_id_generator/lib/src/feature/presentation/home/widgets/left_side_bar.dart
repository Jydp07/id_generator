import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_id_generator/src/core/constants/app_strings.dart';
import 'package:student_id_generator/src/core/extensions/size_extension.dart';
import 'package:student_id_generator/src/core/theme/app_colors.dart';
import 'package:student_id_generator/src/feature/presentation/home/controllers/home_page_controller.dart';
import 'package:student_id_generator/src/feature/presentation/home/widgets/preview_panel.dart';
import 'package:student_id_generator/src/shared/presentation/widgets/outlined_upload_field.dart';
import 'package:student_id_generator/src/shared/presentation/widgets/section_card.dart';

class LeftSidebar extends StatelessWidget {
  const LeftSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomePageController>();
    return Column(
      children: [
        SectionCard(
          title: AppStrings.uploadTemplate,
          subtitle: AppStrings.tipDragFieldsOnTemplateAndDragEdgesToResize,
          child: Obx(
            () => OutlinedUploadField(
              label: controller.templateFile.value == null
                  ? AppStrings.noFileChosen
                  : controller.templateFile.value!.name,
              onTap: controller.pickTemplateFile,
            ),
          ),
        ),
        16.verticalBox,
        SectionCard(
          title: AppStrings.uploadExcelSheet,
          child: Obx(
            () => Column(
              children: [
                OutlinedUploadField(
                  label: controller.excelFile.value == null
                      ? AppStrings.noFileChosen
                      : controller.excelFile.value!.name,
                  onTap: controller.pickExcelFile,
                ),
                if (controller.excelFile.value != null) ...[
                  8.verticalBox,
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.colorGreen50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle,
                            color: AppColors.colorGreen600, size: 18),
                        8.horizontalBox,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.dataLoaded,
                                style: TextStyle(
                                  color: AppColors.colorGreen700,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                "${controller.excelData.length} ${AppStrings.rows}",
                                style: TextStyle(
                                  color: AppColors.colorGreen600,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        16.verticalBox,
        const PreviewPanel(),
      ],
    );
  }
}
