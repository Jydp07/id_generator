import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_id_generator/src/core/constants/app_strings.dart';
import 'package:student_id_generator/src/core/extensions/size_extension.dart';
import 'package:student_id_generator/src/feature/presentation/home/controllers/home_page_controller.dart';
import 'package:student_id_generator/src/feature/presentation/home/widgets/field_toolbar.dart';
import 'package:student_id_generator/src/feature/presentation/home/widgets/id_card_widget.dart';
import 'package:student_id_generator/src/shared/data/enums/enums.dart';
import 'package:student_id_generator/src/shared/presentation/widgets/section_card.dart';

class ArrangeColumnsPanel extends StatelessWidget {
  const ArrangeColumnsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.find<HomePageController>();
    return SectionCard(
      title: AppStrings.arrangeColumnsOnTemplate,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 800;
          return SingleChildScrollView(
            scrollDirection: isWide ? Axis.horizontal : Axis.vertical,
            child: isWide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() {
                        if (controller.excelFile.value != null) {
                          return SizedBox(
                            width: 300,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [const FieldToolbar(), 16.verticalBox],
                            ),
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      }),
                      16.horizontalBox,
                      _buildIdCardSection(theme, controller),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() {
                        if (controller.excelFile.value != null) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [const FieldToolbar(), 16.verticalBox],
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      }),
                      16.verticalBox,
                      _buildIdCardSection(theme, controller),
                    ],
                  ),
          );
        },
      ),
    );
  }

  Widget _buildIdCardSection(ThemeData theme, HomePageController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          if (controller.templateFile.value != null) {
            return IdCardWidget(
              type: IdCardType.edit,
            );
          }
          return Container(
            height: 600,
            width: 400,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.outlineVariant,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                AppStrings.uploadTemplateAndExcelSheetToStartArrangingColumns,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
            ),
          );
        }),
        16.verticalBox,
        OutlinedButton.icon(
          onPressed: () => _showClearDialog(controller),
          icon: const Icon(Icons.clear, size: 18),
          label: const Text(AppStrings.clear),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red,
          ),
        ),
      ],
    );
  }

  void _showClearDialog(HomePageController controller) {
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.clearLayout),
        content: const Text(AppStrings.clearLayoutConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              controller.clearCurrentLayout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text(AppStrings.clear),
          ),
        ],
      ),
    );
  }
}
