import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_id_generator/src/core/constants/app_strings.dart';
import 'package:student_id_generator/src/core/extensions/size_extension.dart';
import 'package:student_id_generator/src/core/theme/app_colors.dart';
import 'package:student_id_generator/src/feature/presentation/home/controllers/home_page_controller.dart';
import 'package:student_id_generator/src/feature/presentation/home/widgets/id_card_widget.dart';
import 'package:student_id_generator/src/shared/data/enums/enums.dart';
import 'package:student_id_generator/src/shared/presentation/widgets/primary_button.dart';
import 'package:student_id_generator/src/shared/presentation/widgets/section_card.dart';

class PreviewPanel extends StatelessWidget {
  const PreviewPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomePageController>();

    return SectionCard(
        title: AppStrings.preview,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 400;
            return ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 600),
              child: SingleChildScrollView(
                child: Obx(
                  () => Column(
                    children: [
                      if (!controller.isPreviewGenerated.value)
                        Container(
                          height: isWide ? 500 : 300,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.colorGrey300!),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                AppStrings.noPreviewYet,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: isWide ? 16 : 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        )
                      else
                        Center(
                          child: FittedBox(
                              child: InkWell(
                            onTap: () => controller.openPreview(),
                            child: IdCardWidget(
                              type: IdCardType.preview,
                            ),
                          )),
                        ),
                      16.verticalBox,
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.start,
                        runSpacing: 12,
                        spacing: 12,
                        children: [
                          PrimaryButton(
                            label: controller.isPreviewGenerated.value
                                ? AppStrings.regeneratePreview
                                : AppStrings.generatePreview,
                            onPressed: controller.generatePreview,
                          ),
                          OutlinedButton.icon(
                            onPressed: controller.isPreviewGenerated.value ||
                                    controller.excelData.isNotEmpty
                                ? () {
                                    controller.exportCurrentPreviewAsPdf();
                                  }
                                : null,
                            icon: const Icon(Icons.download, size: 18),
                            label: const Text(AppStrings.export),
                          ),
                        ],
                      ),
                      if (controller.isPreviewGenerated.value) ...[
                        12.verticalBox,
                        TextButton.icon(
                          onPressed: controller.clearPreview,
                          icon: const Icon(Icons.clear, size: 18),
                          label: const Text(AppStrings.clearPreview),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red[600],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }
}
