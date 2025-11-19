import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import 'package:water_markly/components/water_markly_watermark_cards.dart';
import 'package:water_markly/db_water_markly/db_water_markly_entity.dart';

class WatermarkService {
  static final WatermarkService _instance = WatermarkService._internal();
  factory WatermarkService() => _instance;
  WatermarkService._internal();

  
  Future<File> addWatermarkToImage({
    required File imageFile,
    required String watermarkName,
    required String timestamp,
    String? locationAddress,
    Map<String, String>? customFields,
    WatermarkTemplate? currentTemplate,
  }) async {
    try {
      
      final bytes = await imageFile.readAsBytes();
      
      img.Image? originalImage = img.decodeImage(bytes);

      if (originalImage == null) {
        throw Exception('Failed to decode image');
      }

      
      final cardWidth = _getCardWidth(watermarkName);
      
      
      
      final watermarkSize = Size(cardWidth * 3, 500);
      
      
      final scale = watermarkSize.width / 375.0;

      
      final watermarkWidget = WatermarkCardWidget(
        templateName: watermarkName,
        timeString: timestamp,
        location: locationAddress ?? 'Unknown Location',
        customFields: customFields ?? {},
        currentTemplate: currentTemplate,
        scale: scale,
      );
      
      
      final watermarkImage = await captureWidgetAsImage(
        widget: watermarkWidget,
        size: watermarkSize,
        pixelRatio: 1.0, 
      );

      
      final result = _compositeImages(
        originalImage,
        watermarkImage,
        Offset(
          20, 
          (originalImage.height - watermarkImage.height - 20).toDouble(), 
        ),
      );

      
      final newBytes = img.encodeJpg(result, quality: 95);
      await imageFile.writeAsBytes(newBytes);

      return imageFile;
    } catch (e) {
      rethrow;
    }
  }

  
  Future<img.Image> captureWidgetAsImage({
    required Widget widget,
    required Size size,
    double pixelRatio = 3.0,
  }) async {
    try {
      
      final RenderRepaintBoundary repaintBoundary = RenderRepaintBoundary();
      
      
      final PipelineOwner pipelineOwner = PipelineOwner();
      final BuildOwner buildOwner = BuildOwner(focusManager: FocusManager());
      
      
      final view = ui.PlatformDispatcher.instance.views.first;
      
      
      final RenderView renderView = RenderView(
        view: view,
        child: RenderPositionedBox(
          alignment: Alignment.center,
          child: repaintBoundary,
        ),
        configuration: ViewConfiguration(
          devicePixelRatio: pixelRatio,
          logicalConstraints: BoxConstraints.tight(size),
        ),
      );
      
      
      pipelineOwner.rootNode = renderView;
      renderView.prepareInitialFrame();
      
      
      final RenderObjectToWidgetElement<RenderBox> rootElement = 
        RenderObjectToWidgetAdapter<RenderBox>(
          container: repaintBoundary,
          child: Directionality(
            textDirection: ui.TextDirection.ltr,
            child: MediaQuery(
              data: MediaQueryData(
                size: size,
                devicePixelRatio: pixelRatio,
                textScaler: TextScaler.linear(1.0),
              ),
              child: DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  decoration: TextDecoration.none,
                ),
                child: widget,
              ),
            ),
          ),
        ).attachToRenderTree(buildOwner);
      
      
      buildOwner.buildScope(rootElement);
      buildOwner.finalizeTree();
      
      pipelineOwner.flushLayout();
      pipelineOwner.flushCompositingBits();
      pipelineOwner.flushPaint();
      
      if (!repaintBoundary.hasSize || repaintBoundary.size.isEmpty) {
        throw Exception('Widget rendered with invalid size: ${repaintBoundary.size}. '
            'Expected size: $size');
      }
      
      
      final ui.Image image = await repaintBoundary.toImage(
        pixelRatio: pixelRatio,
      );
      
      
      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      
      if (byteData == null) {
        throw Exception('Failed to convert image to bytes');
      }
      
      final Uint8List pngBytes = byteData.buffer.asUint8List();
      
      
      final img.Image? imgImage = img.decodePng(pngBytes);
      
      if (imgImage == null) {
        throw Exception('Failed to decode PNG bytes');
      }
      
      return imgImage;
    } catch (e) {
      rethrow;
    }
  }

  
  img.Image _compositeImages(
    img.Image background,
    img.Image watermark,
    Offset position,
  ) {
    
    return img.compositeImage(
      background,
      watermark,
      dstX: position.dx.toInt(),
      dstY: position.dy.toInt(),
    );
  }

  
  double _getCardWidth(String templateName) {
    if (templateName.contains('Attendance') || templateName.contains('Check')) {
      return 180;
    } else if (templateName.contains('Construction')) {
      return 230;
    } else if (templateName.contains('Patrol')) {
      return 210;
    } else if (templateName.contains('Sales')) {
      return 250;
    } else if (templateName.contains('Note')) {
      return 230;
    } else if (templateName.contains('Clock')) {
      return 210;
    } else if (templateName.contains('Travel')) {
      return 190;
    } else if (templateName.contains('Inbound')) {
      return 220;
    } else if (templateName.contains('Outbound')) {
      return 220;
    } else {
      return 240;
    }
  }

  
  String formatTimestamp(DateTime dateTime) {
    return DateFormat('yyyy.MM.dd HH:mm').format(dateTime);
  }
}
