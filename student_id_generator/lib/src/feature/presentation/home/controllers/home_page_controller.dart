import 'dart:developer';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:student_id_generator/src/core/utils/export_utility.dart';
import 'package:student_id_generator/src/core/utils/file_utility.dart';
import 'package:student_id_generator/src/core/utils/image_generation_utility.dart';
import 'package:student_id_generator/src/core/utils/snackbar_utility.dart';
import 'package:student_id_generator/src/core/constants/app_strings.dart';
import 'package:student_id_generator/src/feature/data/models/id_card_fields.dart';
import 'package:student_id_generator/src/shared/data/enums/enums.dart';
import 'package:student_id_generator/src/shared/data/models/picked_local_file.dart';

class HomePageController extends GetxController {
  final templateFile = Rx<PickedLocalFile?>(null);
  final excelFile = Rx<PickedLocalFile?>(null);
  final isLaoding = false.obs;
  final idCardTemplateKey = GlobalKey();
  Rx<Uint8List?> previewImage = Rx<Uint8List?>(null);

  final fields = RxList<IDCardField>();
  final selectedFieldId = RxnString();
  final isEditMode = false.obs;
  final isPreviewGenerated = false.obs;
  final previewData = Rxn<Map<String, dynamic>>();
  final currentPreviewIndex = 0.obs;
  final excelHeaders = RxList<String>();

  void pickTemplateFile() async {
    try {
      templateFile.value = await FileUtility.pickImageFile();
    } catch (ex) {
      SnackbarUtility.showSnackbar(ex.toString(), SnackbarType.error);
    }
  }

  void pickExcelFile() async {
    if (templateFile.value == null) {
      SnackbarUtility.showSnackbar(
        AppStrings.pleaseFirstUploadTemplate,
        SnackbarType.error,
      );
      return;
    }
    await _readFileAndGetData();
  }

  Future<void> _readFileAndGetData() async {
    try {
      excelFile.value = await FileUtility.pickExcelFile();
      if (excelFile.value == null) return;

      final bytes = await excelFile.value!.getBytes();
      final excel = Excel.decodeBytes(bytes);
      isLaoding.value = true;

      Sheet? sheet;
      for (var s in excel.tables.keys) {
        final t = excel.tables[s]!;
        if (t.maxRows > 0) {
          sheet = t;
          break;
        }
      }
      if (sheet == null) throw Exception('No sheets found');

      final rows = <Map<String, dynamic>>[];
      if (sheet.maxRows > 0) {
        final firstRow = sheet.rows[0];
        for (var c in firstRow) {
          final cellValue = _getCellValue(c);
          excelHeaders.add(cellValue);
        }
        for (int r = 1; r < sheet.maxRows; r++) {
          final row = sheet.rows[r];
          if (row.every((c) => c == null || _getCellValue(c).trim().isEmpty)) {
            continue;
          }

          final map = <String, dynamic>{};
          for (int c = 0; c < excelHeaders.length; c++) {
            final key = excelHeaders[c];
            final cell = c < row.length ? row[c] : null;
            map[key] = _getCellValue(cell);
          }
          rows.add(map);
        }
      }

      _excelData = rows;

      createFieldsFromExcelHeaders();
    } catch (ex) {
      log(ex.toString());
      SnackbarUtility.showSnackbar(
        "${AppStrings.errorLoadingExcelFile} ${ex.toString()}",
        SnackbarType.error,
      );
    } finally {
      isLaoding.value = false;
    }
  }

  String _getCellValue(dynamic cell) {
    if (cell == null) return '';

    try {
      final value = cell.value;
      if (value == null) return '';

      if (value is String) {
        return value;
      } else if (value is int || value is double) {
        return value.toString();
      } else if (value is DateTime) {
        return value.toString();
      } else if (value is bool) {
        return value.toString();
      } else {
        return value.toString();
      }
    } catch (e) {
      log('${AppStrings.errorExtractingCellValue} $e');
      return '';
    }
  }

  List<Map<String, dynamic>> _excelData = [];

  List<Map<String, dynamic>> get excelData => _excelData;

  void addField(
    int index,
    String fieldName,
    FieldType fieldType, {
    Offset? position,
    Size? size,
  }) {
    final field = IDCardField(
      id: index.toString(),
      name: fieldName,
      type: fieldType,
      position: position ?? const Offset(50, 50),
      size: size ?? const Size(100, 52),
      isSelected: false,
    );
    fields.add(field);
  }

  void selectField(String fieldId) {
    selectedFieldId.value = fieldId;
  }

  void deselectAllFields() {
    for (var field in fields) {
      field.isSelected = false;
    }
    selectedFieldId.value = null;
    fields.refresh();
  }

  void removeField(String fieldId) {
    fields.removeWhere((f) => f.id == fieldId);
    if (selectedFieldId.value == fieldId) {
      selectedFieldId.value = null;
    }
  }

  void toggleEditMode() {
    isEditMode.value = !isEditMode.value;
    if (!isEditMode.value) {
      deselectAllFields();
    }
  }

  void createFieldsFromExcelHeaders() {
    fields.clear();

    for (int i = 0; i < excelHeaders.length; i++) {
      final header = excelHeaders[i];
      addField(
        i,
        header,
        FieldType.text,
        position: Offset(50, 50 + (i * 52)),
        size: const Size(120, 42),
      );
    }
  }

  Future<void> generatePreview() async {
    try {
      selectedFieldId.value = "";
      isPreviewGenerated.value = false;

      if (templateFile.value == null) {
        SnackbarUtility.showSnackbar(
          AppStrings.pleaseUploadTemplateFirst,
          SnackbarType.error,
        );
        return;
      }

      if (excelData.isEmpty) {
        SnackbarUtility.showSnackbar(
          AppStrings.pleaseUploadExcelFileWithDataFirst,
          SnackbarType.error,
        );
        return;
      }

      if (fields.isEmpty) {
        SnackbarUtility.showSnackbar(
          AppStrings.pleaseAddSomeFieldsToTemplateFirst,
          SnackbarType.error,
        );
        return;
      }

      if (excelData.isNotEmpty) {
        currentPreviewIndex.value = 0;
        previewData.value = excelData[0];

        for (var field in fields) {
          field.value = previewData.value![field.name]?.toString() ?? '';
        }
        fields.refresh();
      }

      isPreviewGenerated.value = true;
      Get.forceAppUpdate();
    } catch (ex) {
      SnackbarUtility.showSnackbar(ex.toString(), SnackbarType.error);
    }
  }

  void clearPreview() {
    isPreviewGenerated.value = false;
    previewData.value = null;
    currentPreviewIndex.value = 0;
    for (var field in fields) {
      field.value = null;
    }
    excelHeaders.clear();

    for (var field in fields) {
      field.value = null;
    }
    fields.refresh();
  }

  Future<void> clearCurrentLayout() async {
    fields.clear();
    templateFile.value = null;
    excelFile.value = null;

    clearPreview();
  }

  Future<void> exportCurrentPreviewAsPdf() async {
    if (previewData.value == null) {
      SnackbarUtility.showSnackbar(
        AppStrings.pleaseGeneratePreviewFirst,
        SnackbarType.error,
      );
      return;
    }

    final images = await ImageGenerationUtility.generateImagesFromWidget(
        idCardTemplateKey,
        data: excelData);

    final fileName = 'id_card_${DateTime.now().millisecondsSinceEpoch}';
    await ExportUtility.exportImagesAsPdf(
      images: images,
      fileName: fileName,
    );
  }
}
