import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:water_markly/db_water_markly/db_water_markly.dart';
import 'package:water_markly/db_water_markly/db_water_markly_entity.dart';
import 'package:water_markly/services/location_service.dart';
import 'package:water_markly/services/watermark_service.dart';
import 'package:water_markly/utils/index.dart';

class WaterMarklyCameraLogic extends GetxController {
  final isFlashOn = false.obs;
  final zoomLevel = 1.0.obs;
  final isCameraInitialized = false.obs;

  WatermarkTemplate? currentTemplate;
  final currentWatermarkId = 0.obs;
  final currentWatermark = 'Construction Record'.obs;
  final timeString = ''.obs;
  final location = 'Loading location...'.obs;
  final customFields = <String, String>{}.obs;
  final customFieldsUpdateCounter = 0.obs;
  final isCapturing = false.obs;

  double? latitude;
  double? longitude;

  CameraController? cameraController;
  List<CameraDescription>? cameras;
  Timer? _timeUpdateTimer;

  bool _isInitializing = false;

  final db = Get.find<WaterMarklyDB>();
  final locationService = LocationService();
  final watermarkService = WatermarkService();

  @override
  void onInit() {
    super.onInit();
    _initializeCamera();
    _updateTime();
    _startTimeUpdate();
    _loadDefaultWatermark();

    location.value = 'Getting location...';
    _getCurrentLocation();
  }

  @override
  void onClose() {
    _timeUpdateTimer?.cancel();
    cameraController?.dispose();
    super.onClose();
  }

  Future<void> _initializeCamera() async {
    if (_isInitializing || isCameraInitialized.value) {
      return;
    }

    _isInitializing = true;

    try {
      cameras = await availableCameras();
      if (cameras == null || cameras!.isEmpty) {
        errorToast('No camera available');
        _isInitializing = false;
        return;
      }

      cameraController = CameraController(
        cameras![0],
        ResolutionPreset.high,
        enableAudio: false,
      );

      await cameraController!.initialize();
      isCameraInitialized.value = true;
    } catch (e) {
      if (e.toString().contains('permission') ||
          e.toString().contains('authorized')) {
        errorToast('Camera permission denied');
      } else {
        errorToast('Failed to initialize camera');
      }
    } finally {
      _isInitializing = false;
    }
  }

  void _updateTime() {
    final now = DateTime.now();
    timeString.value = DateFormat('yyyy.MM.dd HH:mm').format(now);
  }

  void _startTimeUpdate() {
    _timeUpdateTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }

  Future<void> _loadDefaultWatermark() async {
    try {
      final templates = await db.getWatermarkTemplatesByCategory('work');
      if (templates.isNotEmpty) {
        final constructionTemplate = templates.firstWhere(
          (t) => t.name == 'Construction Record',
          orElse: () => templates.first,
        );
        _applyWatermarkTemplate(constructionTemplate);
      }
    } catch (e) {}
  }

  void _applyWatermarkTemplate(
    WatermarkTemplate template, {
    Map<String, String>? fields,
  }) {
    currentTemplate = template;
    currentWatermarkId.value = template.id!;
    currentWatermark.value = template.name;

    final newFields = <String, String>{};
    for (final config in template.fieldsConfig) {
      final name = config['name'] as String;
      newFields[name] = fields?[name] ?? '';
    }

    customFields.assignAll(newFields);

    customFieldsUpdateCounter.value++;
  }

  Future<void> _getCurrentLocation() async {
    try {
      final locationData = await locationService
          .getCurrentLocationWithAddress();
      if (locationData != null) {
        latitude = locationData['latitude'] as double?;
        longitude = locationData['longitude'] as double?;
        location.value =
            locationData['address'] as String? ?? 'Unknown Location';
      } else {
        location.value = 'Location unavailable';
      }
    } catch (e) {
      location.value = 'Location unavailable';
    }
  }

  Future<void> toggleFlash() async {
    if (cameraController == null || !isCameraInitialized.value) return;

    try {
      final newValue = !isFlashOn.value;
      await cameraController!.setFlashMode(
        newValue ? FlashMode.torch : FlashMode.off,
      );
      isFlashOn.value = newValue;
    } catch (e) {
      errorToast('Failed to toggle flash');
    }
  }

  Future<void> switchCamera() async {
    if (cameras == null || cameras!.isEmpty) return;

    try {
      final currentDirection = cameraController!.description.lensDirection;

      final targetDirection = currentDirection == CameraLensDirection.back
          ? CameraLensDirection.front
          : CameraLensDirection.back;

      final targetCamera = cameras!.firstWhere(
        (camera) => camera.lensDirection == targetDirection,
        orElse: () => cameras!.first,
      );

      isCameraInitialized.value = false;

      await cameraController?.dispose();

      cameraController = CameraController(
        targetCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await cameraController!.initialize();

      isFlashOn.value = false;
      zoomLevel.value = 1.0;

      isCameraInitialized.value = true;
    } catch (e) {
      errorToast('Failed to switch camera');
      isCameraInitialized.value = false;
    }
  }

  Future<void> setZoom(double zoom) async {
    if (cameraController == null || !isCameraInitialized.value) return;

    try {
      await cameraController!.setZoomLevel(zoom);
      zoomLevel.value = zoom;
    } catch (e) {}
  }

  Future<void> fetchLocation() async {
    location.value = 'Getting location...';
    await _getCurrentLocation();
    if (location.value != 'Location unavailable') {
      successToast('Location updated');
    } else {
      errorToast('Failed to get location');
    }
  }

  Future<void> takePhoto() async {
    if (cameraController == null || !isCameraInitialized.value) {
      errorToast('Camera not ready');
      return;
    }

    if (isCapturing.value) return;

    try {
      isCapturing.value = true;
      HapticFeedback.heavyImpact();

      final XFile photo = await cameraController!.takePicture();

      await Future.delayed(Duration(milliseconds: 300));
      isCapturing.value = false;

      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = '${directory.path}/photo_$timestamp.jpg';

      final photoFile = File(photo.path);
      final savedFile = await photoFile.copy(filePath);

      final watermarkedFile = await watermarkService.addWatermarkToImage(
        imageFile: savedFile,
        watermarkName: currentWatermark.value,
        timestamp: timeString.value,
        locationAddress:
            location.value != 'Location unavailable' &&
                location.value != 'Tap location button to get address'
            ? location.value
            : null,
        customFields: Map<String, String>.from(customFields),
        currentTemplate: currentTemplate,
      );

      final record = MediaRecord(
        type: 'photo',
        filePath: watermarkedFile.path,
        timestamp: DateTime.now(),
        watermarkId: currentWatermarkId.value,
        watermarkName: currentWatermark.value,
        locationAddress:
            location.value != 'Location unavailable' &&
                location.value != 'Tap location button to get address'
            ? location.value
            : null,
        locationLatitude: latitude,
        locationLongitude: longitude,
        customFields: Map<String, String>.from(customFields),
        createdAt: DateTime.now(),
      );

      await db.insertMediaRecord(record);

      _resetCustomFields();

      successToast('Photo saved successfully');
    } catch (e) {
      errorToast('Failed to save photo: ${e.toString()}');
    }
  }

  void _resetCustomFields() {
    if (currentTemplate != null) {
      final newFields = <String, String>{};
      for (final config in currentTemplate!.fieldsConfig) {
        final name = config['name'] as String;
        newFields[name] = '';
      }
      customFields.assignAll(newFields);
      customFieldsUpdateCounter.value++;
    }
  }

  Future<void> onCaptureTap() async {
    await takePhoto();
  }

  void onGalleryTap() {
    Get.toNamed('/gallery');
  }

  Future<void> onWatermarkSelectorTap() async {
    final selectedTemplate = await Get.toNamed(
      '/watermark_selector',
    );
    if (selectedTemplate != null && selectedTemplate is WatermarkTemplate) {
      _applyWatermarkTemplate(selectedTemplate);
    }
  }

  Future<void> onWatermarkCardTap() async {
    if (currentTemplate == null) {
      errorToast('No watermark template selected');
      return;
    }

    final fieldsData = await Get.toNamed(
      '/field_editor',
      arguments: {
        'template': currentTemplate!,
        'fieldsData': Map<String, String>.from(customFields),
      },
    );

    if (fieldsData != null && fieldsData is Map<String, String>) {
      _applyWatermarkTemplate(currentTemplate!, fields: fieldsData);
    }
  }

  Future<void> showCustomFieldInputDialog(
    String fieldName,
    String fieldLabel,
  ) async {
    final controller = TextEditingController(
      text: customFields[fieldName] ?? '',
    );

    await Get.dialog(
      AlertDialog(
        title: Text(fieldLabel),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Enter $fieldLabel',
            border: OutlineInputBorder(),
          ),
          maxLines:
              fieldLabel.contains('Content') || fieldLabel.contains('Notes')
              ? 3
              : 1,
          maxLength:
              fieldLabel.contains('Content') || fieldLabel.contains('Notes')
              ? 200
              : 50,
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          TextButton(
            onPressed: () {
              customFields[fieldName] = controller.text;
              Get.back();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  String getFieldLabel(String fieldName) {
    switch (fieldName) {
      case 'construction_area':
        return 'Construction Area';
      case 'construction_content':
        return 'Construction Content';
      case 'inspection_type':
        return 'Inspection Type';
      case 'issue_notes':
        return 'Issue Notes';
      case 'location':
        return 'Location';
      case 'direction':
        return 'Direction';
      default:
        return fieldName;
    }
  }
}
