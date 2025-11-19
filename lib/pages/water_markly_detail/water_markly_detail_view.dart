import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:water_markly/pages/water_markly_detail/water_markly_detail_logic.dart';

class WaterMarklyDetailView extends GetView<WaterMarklyDetailLogic> {
  const WaterMarklyDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    if (controller.mediaRecord == null) {
      return Scaffold(body: Center(child: Text('No media record found')));
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _buildImageViewer(),
          _buildInfoCard(),
          _buildTopBarBackground(),
          _buildTopBar(),
        ],
      ),
    );
  }

  Widget _buildImageViewer() {
    final file = File(controller.mediaRecord!.filePath);

    if (!file.existsSync()) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.broken_image,
                color: Colors.white.withOpacity(0.3),
                size: 100.sp,
              ),
              SizedBox(height: 16.h),
              Text(
                'File not found',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black,
      child: InteractiveViewer(
        minScale: 0.5,
        maxScale: 4.0,
        child: Align(
          alignment: Alignment.topCenter,
          child: Image.file(
            file,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.broken_image,
                color: Colors.white.withOpacity(0.3),
                size: 100.sp,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTopBarBackground() {
    return Builder(
      builder: (context) {
        return Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: MediaQuery.of(context).padding.top + 52.h,
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.26)),
          ),
        );
      },
    );
  }

  Widget _buildTopBar() {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                padding: EdgeInsets.only(left: 8.w),
                alignment: Alignment.center,
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 18.sp,
                ),
                onPressed: () => Get.back(),
              ),
            ),
            Text(
              'Photo Details',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                alignment: Alignment.center,
                icon: Icon(Icons.more_horiz, color: Colors.white, size: 18.sp),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return DraggableScrollableSheet(
      initialChildSize: 0.25,
      minChildSize: 0.18,
      maxChildSize: 0.85,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildHandleBar(),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  children: [
                    Text(
                      'Details',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    _buildDetailItem(
                      Icons.access_time,
                      'Capture Time',
                      DateFormat(
                        'yyyy.MM.dd HH:mm:ss',
                      ).format(controller.mediaRecord!.timestamp),
                      Color(0xFFDBEAFE),
                      Color(0xFF2563EB),
                    ),
                    if (controller.mediaRecord!.locationAddress != null) ...[
                      SizedBox(height: 16.h),
                      _buildDetailItem(
                        Icons.location_on,
                        'Location',
                        controller.mediaRecord!.locationAddress!,
                        Color(0xFFFEE2E2),
                        Color(0xFFDC2626),
                        subtitle:
                            controller.mediaRecord!.locationLatitude != null &&
                                controller.mediaRecord!.locationLongitude !=
                                    null
                            ? 'Lat: ${controller.mediaRecord!.locationLatitude!.toStringAsFixed(4)}°, Lon: ${controller.mediaRecord!.locationLongitude!.toStringAsFixed(4)}°'
                            : null,
                      ),
                    ],
                    SizedBox(height: 16.h),
                    _buildDetailItem(
                      Icons.palette,
                      'Watermark Type',
                      controller.mediaRecord!.watermarkName,
                      Color(0xFFF3E8FF),
                      Color(0xFF9333EA),
                    ),
                    if (controller.mediaRecord!.customFields != null &&
                        controller.mediaRecord!.customFields!.isNotEmpty) ...[
                      SizedBox(height: 16.h),
                      _buildCustomInfoItem(),
                    ],
                    SizedBox(height: 16.h),
                    _buildDetailItem(
                      Icons.image,
                      'File Information',
                      _getFileInfo(),
                      Color(0xFFF3F4F6),
                      Color(0xFF4B5563),
                    ),
                    SizedBox(height: 24.h),
                    _buildActionButtons(),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHandleBar() {
    return Container(
      padding: EdgeInsets.only(top: 8.h, bottom: 12.h),
      child: Center(
        child: Container(
          width: 40.w,
          height: 4.h,
          decoration: BoxDecoration(
            color: Color(0xFFD1D5DB),
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(
    IconData icon,
    String label,
    String value,
    Color bgColor,
    Color iconColor, {
    String? subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
          child: Icon(icon, color: iconColor, size: 20.sp),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12.sp, color: Color(0xFF6B7280)),
              ),
              SizedBox(height: 2.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              if (subtitle != null) ...[
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12.sp, color: Color(0xFF9CA3AF)),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCustomInfoItem() {
    final customFields = controller.mediaRecord!.customFields!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(
            color: Color(0xFFD1FAE5),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.info, color: Color(0xFF059669), size: 20.sp),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Custom Information',
                style: TextStyle(fontSize: 12.sp, color: Color(0xFF6B7280)),
              ),
              SizedBox(height: 4.h),
              ...customFields.entries.map((entry) {
                if (entry.value.toString().isEmpty) {
                  return SizedBox.shrink();
                }
                return Padding(
                  padding: EdgeInsets.only(bottom: 4.h),
                  child: Text(
                    '${controller.getFieldLabel(entry.key)}: ${entry.value}',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  String _getFileInfo() {
    final file = File(controller.mediaRecord!.filePath);
    if (!file.existsSync()) {
      return 'File not found';
    }

    final size = file.lengthSync();
    final sizeInMB = (size / (1024 * 1024)).toStringAsFixed(2);

    return 'Size: $sizeInMB MB';
  }

  Widget _buildActionButtons() {
    return Obx(
      () => Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.onSaveTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF10B981),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? SizedBox(
                          width: 20.w,
                          height: 20.h,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.save_alt,
                              color: Colors.white,
                              size: 18.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Save to Gallery',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.onShareTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3B82F6),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.share, color: Colors.white, size: 18.sp),
                      SizedBox(width: 8.w),
                      Text(
                        'Share',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : controller.onDeleteTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFEF4444),
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.delete, color: Colors.white, size: 18.sp),
                  SizedBox(width: 8.w),
                  Text(
                    'Delete',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
