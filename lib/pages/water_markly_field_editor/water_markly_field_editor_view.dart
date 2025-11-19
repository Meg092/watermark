import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:water_markly/pages/water_markly_field_editor/water_markly_field_editor_logic.dart';
import 'package:water_markly/component/text_field.dart';

class WaterMarklyFieldEditorView extends GetView<WaterMarklyFieldEditorLogic> {
  const WaterMarklyFieldEditorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9FAFB),
      appBar: AppBar(
        title: Text(
          controller.template.name,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Color(0xFF3B82F6)),
          onPressed: () => Get.back(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTemplatePreview(),
                  SizedBox(height: 24.h),
                  if (controller.template.fieldsConfig.isNotEmpty) ...[
                    Text(
                      'Fill in watermark information',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    _buildFieldsForm(),
                  ] else ...[
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 32.h),
                        child: Text(
                          'This watermark has no custom fields.\nTime and location will be added automatically.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          _buildBottomButton(),
        ],
      ),
    );
  }

  Widget _buildTemplatePreview() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: _getBackgroundGradient(controller.template.name),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getIconForTemplate(controller.template.name),
                color: Colors.white,
                size: 24.sp,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  controller.template.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            '2025.11.15 10:30',
            style: TextStyle(
              color: Colors.white.withOpacity(0.95),
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Sample Location Address',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldsForm() {
    return Column(
      children: controller.template.fieldsConfig.map((config) {
        final name = config['name'] as String;
        final label = config['label'] as String;
        final type = config['type'] as String;
        final maxLength = config['maxLength'] as int?;

        return Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8.h),
              Obx(
                () => Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: MyTextField(
                    value: controller.fieldsData[name] ?? '',
                    onChange: (value) => controller.updateField(name, value),
                    hintText: 'Enter $label',
                    maxLength: maxLength,
                    maxLines: type == 'textarea' ? 4 : 1,
                    minLines: type == 'textarea' ? 3 : 1,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 48.h,
          child: ElevatedButton(
            onPressed: () => controller.continueToCamera(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF3B82F6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check, size: 20.sp, color: Colors.white),
                SizedBox(width: 8.w),
                Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
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

  LinearGradient _getBackgroundGradient(String name) {
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
}

