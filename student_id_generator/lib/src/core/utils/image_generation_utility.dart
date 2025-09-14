import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:student_id_generator/src/core/extensions/url_extenstion.dart';
import 'package:student_id_generator/src/core/utils/loading_utility.dart';
import 'package:student_id_generator/src/feature/presentation/home/widgets/id_card_widget.dart';
import 'package:student_id_generator/src/shared/data/enums/enums.dart';
import 'package:http/http.dart' as http;

class ImageGenerationUtility {
  static Future<List<Uint8List>> generateImagesFromWidget(
    GlobalKey key, {
    double pixelRatio = 1.0,
    required List<Map<String, dynamic>> data,
  }) async {
    try {
      LoadingUtility.start();
      if (data.isEmpty) {
        throw Exception('No data provided for image generation');
      }
      final generatedImages = <Uint8List>[];
      for (int i = 0; i < data.length; i++) {
        final currentData = data[i];
        String? imageUrlKey;
        currentData.forEach((key, value) {
          if (value is String && value.isNotEmpty && value.isImageUrl) {
            imageUrlKey = key;
          }
        });

        Uint8List? loadedImage;
        if (imageUrlKey != null) {
          loadedImage = await downloadImage(currentData[imageUrlKey!]);
        }

        final image = await _renderToImage(
          Material(
            child: IdCardWidget(
              type: IdCardType.preview,
              index: i,
              image: loadedImage,
            ),
          ),
          key,
        );
        generatedImages.add(image);
      }
      return generatedImages;
    } catch (ex) {
      rethrow;
    } finally {
      LoadingUtility.stop();
    }
  }

  static Future<Uint8List> _renderToImage(Widget widget, GlobalKey key) async {
    final constrainedWidget = SizedBox(
      width: 600,
      height: 800,
      child: widget,
    );

    final boxContrints = BoxConstraints(
      maxHeight: Get.height,
      maxWidth: Get.width,
      minHeight: Get.height,
      minWidth: Get.width,
    );

    final RenderRepaintBoundary boundary = RenderRepaintBoundary();

    final BuildOwner buildOwner = BuildOwner(focusManager: FocusManager());
    final RenderView renderView = RenderView(
      child: RenderPositionedBox(
        alignment: Alignment.center,
        child: boundary,
      ),
      configuration: ViewConfiguration(
        devicePixelRatio: 1.0, // Use 1.0 for better compatibility
        physicalConstraints: boxContrints,
        logicalConstraints: boxContrints,
      ),
      view: WidgetsBinding.instance.window,
    );

    final pipelineOwner = PipelineOwner();
    pipelineOwner.rootNode = renderView;
    renderView.prepareInitialFrame();

    final renderElement = RenderObjectToWidgetAdapter<RenderBox>(
      container: boundary,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: constrainedWidget,
      ),
    ).attachToRenderTree(buildOwner);

    buildOwner.buildScope(renderElement);
    buildOwner.finalizeTree();
    pipelineOwner.flushLayout();
    pipelineOwner.flushCompositingBits();
    pipelineOwner.flushPaint();

    if (boundary.size.isEmpty) {
      throw Exception(
          'Widget rendered with empty size. Check widget constraints.');
    }

    final image = await boundary.toImage(pixelRatio: 1.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  static Future<Uint8List> downloadImage(String url) async {
    final response = await http.get(Uri.parse(url));
    return response.bodyBytes;
  }
}
