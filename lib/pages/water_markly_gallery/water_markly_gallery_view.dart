import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:water_markly/pages/water_markly_gallery/water_markly_gallery_logic.dart';
import 'package:water_markly/db_water_markly/db_water_markly_entity.dart';

class WaterMarklyGalleryView extends GetView<WaterMarklyGalleryLogic> {
  const WaterMarklyGalleryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9FAFB),
      appBar: AppBar(
        title: Text(
          'Gallery',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Color(0xFF3B82F6)),
          onPressed: () => Get.back(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(height: 1, color: Color(0xFFE5E7EB)),
        ),
      ),
      body: _buildGalleryList(),
    );
  }

  Widget _buildGalleryList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(32.w),
            child: CircularProgressIndicator(),
          ),
        );
      }

      if (controller.mediaRecords.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(32.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.photo_library_outlined,
                  size: 64.sp,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 16.h),
                Text(
                  'No photos yet',
                  style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Take photos to see them here',
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.onRefresh,
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: controller.mediaRecords.length,
          itemBuilder: (context, index) {
            final record = controller.mediaRecords[index];
            return _buildGalleryItemFromRecord(record);
          },
        ),
      );
    });
  }

  Widget _buildGalleryItemFromRecord(MediaRecord record) {
    final time = DateFormat('yyyy.MM.dd HH:mm').format(record.timestamp);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => controller.onMediaTap(record),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildThumbnailFromRecord(record),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              record.watermarkName,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: Color(0xFF9CA3AF),
                            size: 20.sp,
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      _buildInfoRow(Icons.access_time, time, Color(0xFF3B82F6)),
                      if (record.locationAddress != null) ...[
                        SizedBox(height: 4.h),
                        _buildInfoRow(
                          Icons.location_on,
                          record.locationAddress!,
                          Color(0xFFEF4444),
                        ),
                      ],
                      if (record.customFields != null &&
                          record.customFields!.isNotEmpty)
                        ..._buildCustomFields(
                          Map<String, String>.from(record.customFields!),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnailFromRecord(MediaRecord record) {
    final file = File(record.filePath);

    return Container(
      width: 80.w,
      height: 80.h,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: file.existsSync()
            ? Image.file(
                file,
                width: 80.w,
                height: 80.h,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(
                      Icons.image,
                      size: 40.sp,
                      color: Colors.grey[600],
                    ),
                  );
                },
              )
            : Center(
                child: Icon(Icons.image, size: 40.sp, color: Colors.grey[600]),
              ),
      ),
    );
  }

  List<Widget> _buildCustomFields(Map<String, String> customFields) {
    final widgets = <Widget>[];
    final entries = customFields.entries.take(2).toList();

    for (final entry in entries) {
      if (entry.value.isNotEmpty) {
        widgets.add(SizedBox(height: 4.h));
        widgets.add(
          _buildInfoRow(
            Icons.edit_note,
            '${_getFieldLabel(entry.key)}: ${entry.value}',
            Color(0xFF8B5CF6),
          ),
        );
      }
    }

    return widgets;
  }

  String _getFieldLabel(String fieldName) {
    switch (fieldName) {
      case 'construction_area':
        return 'Area';
      case 'construction_content':
        return 'Content';
      case 'inspection_type':
        return 'Type';
      case 'issue_notes':
        return 'Notes';
      case 'location':
        return 'Location';
      case 'direction':
        return 'Direction';
      default:
        return fieldName;
    }
  }

  Widget _buildInfoRow(IconData icon, String text, Color iconColor) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 12.sp),
        SizedBox(width: 6.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 12.sp, color: Color(0xFF4B5563)),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
