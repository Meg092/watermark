import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:gal/gal.dart';
import 'package:water_markly/db_water_markly/db_water_markly.dart';
import 'package:water_markly/db_water_markly/db_water_markly_entity.dart';
import 'package:water_markly/utils/index.dart';

class WaterMarklyDetailLogic extends GetxController {
  MediaRecord? mediaRecord;
  final isLoading = false.obs;

  final db = Get.find<WaterMarklyDB>();

  @override
  void onInit() {
    super.onInit();
    _loadMediaRecord();
  }

  
  void _loadMediaRecord() {
    final args = Get.arguments;
    if (args != null && args is MediaRecord) {
      mediaRecord = args;
    }
  }

  
  Future<void> onSaveTap() async {
    if (mediaRecord == null) return;

    try {
      isLoading.value = true;

      final file = File(mediaRecord!.filePath);
      if (!file.existsSync()) {
        errorToast('File not found');
        isLoading.value = false;
        return;
      }

      
      final hasAccess = await Gal.hasAccess();
      
      if (!hasAccess) {
        final requestGranted = await Gal.requestAccess();
        
        if (!requestGranted) {
          errorToast('Permission denied. Please allow photo library access in Settings');
          isLoading.value = false;
          return;
        }
      }

      
      await Gal.putImage(
        mediaRecord!.filePath,
        album: 'WaterMarkly',
      );
      
      successToast('Saved to gallery successfully');
    } catch (e) {
      if (e.toString().contains('permission') || e.toString().contains('authorized')) {
        errorToast('Permission denied. Please allow photo library access in Settings');
      } else {
        errorToast('Failed to save: ${e.toString()}');
      }
    } finally {
      isLoading.value = false;
    }
  }

  
  Future<void> onShareTap() async {
    if (mediaRecord == null) return;

    try {
      final file = File(mediaRecord!.filePath);
      if (!file.existsSync()) {
        errorToast('File not found');
        return;
      }

      await Share.shareXFiles(
        [XFile(mediaRecord!.filePath)],
        text: '${mediaRecord!.watermarkName} - ${mediaRecord!.timestamp}',
      );
    } catch (e) {
      errorToast('Failed to share');
    }
  }

  
  Future<void> onDeleteTap() async {
    if (mediaRecord == null) return;

    try {
      final confirmed = await Get.dialog<bool>(
        AlertDialog(
          title: Text('Delete ${mediaRecord!.type == 'photo' ? 'Photo' : 'Video'}'),
          content: Text('Are you sure you want to delete this ${mediaRecord!.type}? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text('Delete'),
            ),
          ],
        ),
      );

      if (confirmed != true) return;

      isLoading.value = true;

      
      final file = File(mediaRecord!.filePath);
      if (file.existsSync()) {
        await file.delete();
      }

      
      await db.deleteMediaRecord(mediaRecord!.id!);

      successToast('Deleted successfully');

      
      Get.back(result: true);
    } catch (e) {
      errorToast('Failed to delete');
    } finally {
      isLoading.value = false;
    }
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
      case 'latitude':
        return 'Latitude';
      case 'longitude':
        return 'Longitude';
      default:
        return fieldName;
    }
  }
}

