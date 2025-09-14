import 'dart:async';
import 'dart:developer';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:student_id_generator/src/core/utils/snackbar_utility.dart';
import 'package:student_id_generator/src/shared/data/enums/enums.dart';

/// Utility class for exporting ID cards as PDF or images
class ExportUtility {

  static Future<void> exportImagesAsPdf({
    required List<Uint8List> images,
    required String fileName,
  }) async {
    try {
      final pdf = pw.Document();

      for (final imageBytes in images) {
        final image = pw.MemoryImage(imageBytes);
        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) {
              return pw.Center(
                child: pw.Image(image, fit: pw.BoxFit.contain),
              );
            },
          ),
        );
      }

      final pdfBytes = await pdf.save();
      await _downloadBytes(pdfBytes, '$fileName.pdf', 'application/pdf');

      SnackbarUtility.showSnackbar(
        'PDF exported successfully!',
        SnackbarType.success,
      );
    } catch (e) {
      log('Error exporting PDF: $e');
      SnackbarUtility.showSnackbar(
        'Failed to export PDF: $e',
        SnackbarType.error,
      );
    }
  }

  static Future<void> _downloadBytes(
    Uint8List bytes,
    String fileName,
    String mimeType,
  ) async {
    try {
      final blob = html.Blob([bytes], mimeType);
      final url = html.Url.createObjectUrlFromBlob(blob);

      html.AnchorElement(href: url)
        ..setAttribute('download', fileName)
        ..click();

      html.Url.revokeObjectUrl(url);
    } catch (e) {
      log('Error downloading file: $e');
      rethrow;
    }
  }
}

