import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:water_markly/pages/water_markly_watermark_selector/water_markly_watermark_selector_logic.dart';
import 'package:water_markly/db_water_markly/db_water_markly_entity.dart';

class WaterMarklyWatermarkSelectorView
    extends GetView<WaterMarklyWatermarkSelectorLogic> {
  const WaterMarklyWatermarkSelectorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9FAFB),
      appBar: AppBar(
        title: Text(
          'Select Watermark',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Color(0xFF3B82F6)),
          onPressed: () => Get.back(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _buildWatermarkList(),
    );
  }

  Widget _buildWatermarkList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(32.w),
            child: CircularProgressIndicator(),
          ),
        );
      }

      if (controller.templates.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(32.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.water_drop_outlined,
                  size: 64.sp,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 16.h),
                Text(
                  'No watermark templates',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: controller.templates.length,
        itemBuilder: (context, index) {
          final template = controller.templates[index];
          return _buildWatermarkItemFromTemplate(template);
        },
      );
    });
  }

  Widget _buildWatermarkItemFromTemplate(WatermarkTemplate template) {
    final icon = _getIconForTemplate(template.name);
    final gradient = _getBackgroundGradientForTemplate(template.name);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12.r),
        child: InkWell(
          onTap: () => controller.selectTemplate(template),
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        gradient: gradient,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(icon, color: Colors.white, size: 20.sp),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        template.name,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        template.isFavorite ? Icons.star : Icons.star_border,
                        color: template.isFavorite ? Colors.amber : Colors.grey[400],
                        size: 22.sp,
                      ),
                      onPressed: () => controller.toggleFavorite(
                        template.id!,
                        template.isFavorite,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                _buildTemplatePreview(template, gradient),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconForTemplate(String name) {
    if (name.contains('Attendance') || name.contains('Check')) {
      return Icons.access_time;
    } else if (name.contains('Construction')) {
      return Icons.construction;
    } else if (name.contains('Patrol')) {
      return Icons.shield;
    } else if (name.contains('Sales')) {
      return Icons.shopping_bag;
    } else if (name.contains('Note')) {
      return Icons.note;
    } else if (name.contains('Clock')) {
      return Icons.access_alarm;
    } else if (name.contains('Travel')) {
      return Icons.flight;
    } else if (name.contains('Inbound')) {
      return Icons.arrow_downward;
    } else if (name.contains('Outbound')) {
      return Icons.arrow_upward;
    } else {
      return Icons.image;
    }
  }

  LinearGradient _getBackgroundGradientForTemplate(String name) {
    if (name.contains('Attendance') || name.contains('Check')) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
      );
    } else if (name.contains('Construction')) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFF97316), Color(0xFFEA580C)],
      );
    } else if (name.contains('Patrol')) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
      );
    } else if (name.contains('Sales')) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF10B981), Color(0xFF059669)],
      );
    } else if (name.contains('Note')) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
      );
    } else if (name.contains('Clock')) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF06B6D4), Color(0xFF0891B2)],
      );
    } else if (name.contains('Travel')) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFEC4899), Color(0xFFDB2777)],
      );
    } else if (name.contains('Inbound')) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
      );
    } else if (name.contains('Outbound')) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
      );
    } else {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF667eea), Color(0xFF764ba2)],
      );
    }
  }

  Widget _buildTemplatePreview(WatermarkTemplate template, LinearGradient gradient) {
    final templateName = template.name;

    
    if (templateName.contains('Attendance') || templateName.contains('Check')) {
      return Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          border: Border.all(color: Color(0xFF3B82F6), width: 2),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          children: [
            Icon(Icons.access_time, color: Color(0xFF3B82F6), size: 32.sp),
            SizedBox(height: 6.h),
            Text(
              '10:30 AM',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Sample Location',
              style: TextStyle(color: Colors.black54, fontSize: 10.sp),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    
    if (templateName.contains('Construction')) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Column(
          children: [
            Container(
              height: 6.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFF97316), Color(0xFFEA580C)],
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(4.r)),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.w),
              child: Row(
                children: [
                  Container(
                    width: 3.w,
                    height: 50.h,
                    color: Color(0xFFF97316),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.construction, color: Color(0xFFF97316), size: 18.sp),
                        SizedBox(height: 4.h),
                        Text(
                          '10:30 AM',
                          style: TextStyle(
                            color: Color(0xFFF97316),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Sample Location',
                          style: TextStyle(color: Colors.black54, fontSize: 9.sp),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    
    if (templateName.contains('Patrol')) {
      return Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
          ),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.r),
            bottom: Radius.circular(8.r),
          ),
        ),
        child: Column(
          children: [
            Icon(Icons.shield, color: Colors.white, size: 28.sp),
            SizedBox(height: 6.h),
            Text(
              '10:30 AM',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Sample Location',
              style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 10.sp),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    
    if (templateName.contains('Sales')) {
      return Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF10B981), Color(0xFF059669)],
          ),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Icon(Icons.shopping_bag, color: Colors.white, size: 28.sp),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '10:30 AM',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Sample Location',
                    style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 10.sp),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    
    if (templateName.contains('Note')) {
      return Transform.rotate(
        angle: -0.02,
        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Color(0xFFFDE68A),
            borderRadius: BorderRadius.circular(2.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.note, color: Color(0xFFF59E0B), size: 18.sp),
              SizedBox(height: 6.h),
              Text(
                '10:30 AM',
                style: TextStyle(
                  color: Color(0xFF92400E),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Sample Location',
                style: TextStyle(color: Color(0xFF92400E).withOpacity(0.8), fontSize: 10.sp),
              ),
            ],
          ),
        ),
      );
    }

    
    if (templateName.contains('Clock')) {
      return Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          border: Border.all(color: Color(0xFF06B6D4), width: 2),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Column(
              children: [
                Text(
                  '10:30',
                  style: TextStyle(
                    color: Color(0xFF06B6D4),
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    height: 1.0,
                  ),
                ),
                Container(
                  width: 40.w,
                  height: 2.h,
                  color: Color(0xFF06B6D4),
                  margin: EdgeInsets.symmetric(vertical: 2.h),
                ),
                Text(
                  'AM',
                  style: TextStyle(
                    color: Color(0xFF06B6D4),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.access_alarm, color: Color(0xFF06B6D4), size: 20.sp),
                  SizedBox(height: 4.h),
                  Text(
                    'Sample Location',
                    style: TextStyle(color: Colors.black54, fontSize: 9.sp),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    
    if (templateName.contains('Travel')) {
      return Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEC4899), Color(0xFFDB2777)],
          ),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Text(
                  '10:30 AM',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Sample Location',
                  style: TextStyle(color: Colors.white.withOpacity(0.95), fontSize: 10.sp),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Positioned(
              right: 0,
              top: 0,
              child: Icon(Icons.flight, color: Colors.white.withOpacity(0.5), size: 20.sp),
            ),
          ],
        ),
      );
    }

    
    if (templateName.contains('Inbound')) {
      return Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
          ),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.arrow_downward, color: Colors.white, size: 24.sp),
                SizedBox(width: 6.w),
                Text(
                  'INBOUND',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            Text(
              '10:30 AM',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Sample Location',
              style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 10.sp),
            ),
          ],
        ),
      );
    }

    
    if (templateName.contains('Outbound')) {
      return Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
          ),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.arrow_upward, color: Colors.white, size: 24.sp),
                SizedBox(width: 6.w),
                Text(
                  'OUTBOUND',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            Text(
              '10:30 AM',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Sample Location',
              style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 10.sp),
            ),
          ],
        ),
      );
    }

    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            template.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            '2025.11.15 10:30',
            style: TextStyle(
              color: Colors.white.withOpacity(0.95),
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Sample Location Address',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    );
  }

}
