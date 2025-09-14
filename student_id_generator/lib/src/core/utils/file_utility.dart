import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:student_id_generator/src/core/utils/snackbar_utility.dart';
import 'package:student_id_generator/src/shared/data/enums/enums.dart';
import 'package:student_id_generator/src/shared/data/models/picked_local_file.dart';

class FileUtility {
  static Future<PickedLocalFile?> pickImageFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result == null) return null;
      final first = result.files.first;

      // For web compatibility, use bytes if available, otherwise use file path
      if (first.bytes != null) {
        return PickedLocalFile(
          file: first.path != null ? File(first.path!) : null,
          name: first.name,
          bytes: first.bytes,
        );
      } else {
        return PickedLocalFile(file: File(first.path!), name: first.name);
      }
    } catch (ex) {
      log(ex.toString());
      SnackbarUtility.showSnackbar(ex.toString(), SnackbarType.error);
      return null;
    }
  }

  static Future<PickedLocalFile?> pickExcelFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
      );
      if (result == null) return null;
      final first = result.files.first;

      // For web compatibility, use bytes if available, otherwise use file path
      if (first.bytes != null) {
        return PickedLocalFile(
          file: first.path != null ? File(first.path!) : null,
          name: first.name,
          bytes: first.bytes,
        );
      } else {
        return PickedLocalFile(file: File(first.path!), name: first.name);
      }
    } catch (ex) {
      log(ex.toString());
      SnackbarUtility.showSnackbar(ex.toString(), SnackbarType.error);
    }
    return null;
  }
}
