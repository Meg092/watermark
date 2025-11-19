import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:water_markly/pages/water_markly_camera/water_markly_camera_logic.dart';
import 'package:water_markly/components/water_markly_watermark_cards.dart';

class WaterMarklyCameraView extends GetView<WaterMarklyCameraLogic> {
  const WaterMarklyCameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildTopToolbar(),
            Expanded(child: _buildCameraPreview()),
            _buildBottomControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopToolbar() {
    return Container(
      padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(
            () => IconButton(
              icon: Icon(
                controller.isFlashOn.value ? Icons.flash_on : Icons.flash_off,
                color: Colors.white,
                size: 24.sp,
              ),
              onPressed: controller.toggleFlash,
            ),
          ),
          Text(
            'Camera',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          IconButton(
            icon: Icon(Icons.flip_camera_ios, color: Colors.white, size: 24.sp),
            onPressed: controller.switchCamera,
          ),
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Obx(() {
          if (controller.isCameraInitialized.value &&
              controller.cameraController != null) {
            return ClipRect(
              child: OverflowBox(
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width:
                        controller
                            .cameraController!
                            .value
                            .previewSize
                            ?.height ??
                        1,
                    height:
                        controller.cameraController!.value.previewSize?.width ??
                        1,
                    child: CameraPreview(controller.cameraController!),
                  ),
                ),
              ),
            );
          } else {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt,
                      color: Colors.white.withOpacity(0.3),
                      size: 100.sp,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Initializing Camera...',
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
        }),
        
        _buildShutterFlash(),
        _buildWatermarkTip(),
        _buildZoomControls(),
        _buildWatermarkCard(),
      ],
    );
  }

  Widget _buildShutterFlash() {
    return Obx(() {
      return AnimatedOpacity(
        opacity: controller.isCapturing.value ? 1.0 : 0.0,
        duration: Duration(milliseconds: 150),
        child: Container(color: Colors.white),
      );
    });
  }

  Widget _buildWatermarkTip() {
    return Positioned(
      top: 16.h,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock, color: Colors.white, size: 12.sp),
              SizedBox(width: 4.w),
              Text(
                'Watermark ensures time is real and cannot be modified',
                style: TextStyle(color: Colors.white, fontSize: 11.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildZoomControls() {
    return Positioned(
      right: 16.w,
      bottom: 180.h,
      child: Column(
        children: [
          _buildZoomButton('10×', 10.0),
          SizedBox(height: 8.h),
          _buildZoomButton('2×', 2.0),
          SizedBox(height: 8.h),
          _buildZoomButton('1×', 1.0, isActive: true),
          SizedBox(height: 16.h),
          _buildLocationButton(),
        ],
      ),
    );
  }

  Widget _buildLocationButton() {
    return GestureDetector(
      onTap: controller.fetchLocation,
      child: Container(
        width: 42.w,
        height: 42.h,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.location_on, color: Colors.white, size: 20.sp),
      ),
    );
  }

  Widget _buildZoomButton(String label, double zoom, {bool isActive = false}) {
    return Obx(() {
      final isSelected = controller.zoomLevel.value == zoom;
      return GestureDetector(
        onTap: () => controller.setZoom(zoom),
        child: Container(
          width: 42.w,
          height: 42.h,
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.white.withOpacity(0.9)
                : Colors.black.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontSize: 16.sp,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildWatermarkCard() {
    return Positioned(
      bottom: 8.h,
      left: 16.w,
      child: Obx(() {
        
        controller.customFieldsUpdateCounter.value;
        return GestureDetector(
          onTap: controller.onWatermarkCardTap,
          child: WatermarkCardWidget(
            templateName: controller.currentWatermark.value,
            timeString: controller.timeString.value,
            location: controller.location.value,
            customFields: Map<String, String>.from(controller.customFields),
            currentTemplate: controller.currentTemplate,
          ),
        );
      }),
    );
  }

  Widget _buildBottomControls() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 24.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: controller.onGalleryTap,
            child: Container(
              width: 52.w,
              height: 52.h,
              margin: EdgeInsets.only(top: 4.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: Container(
                  color: Color(0xFF1F2937),
                  child: Icon(
                    Icons.photo_library,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                ),
              ),
            ),
          ),
          Obx(() {
            final isCapturing = controller.isCapturing.value;
            return GestureDetector(
              onTapDown: (_) {
                
              },
              onTapUp: (_) {
                
              },
              onTap: controller.onCaptureTap,
              child: AnimatedScale(
                scale: isCapturing ? 0.85 : 1.0,
                duration: Duration(milliseconds: 100),
                child: Container(
                  width: 70.w,
                  height: 70.h,
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                    ),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    width: 60.w,
                    height: 60.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF667eea).withOpacity(0.4),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 24.sp,
                    ),
                  ),
                ),
              ),
            );
          }),
          GestureDetector(
            onTap: controller.onWatermarkSelectorTap,
            child: Container(
              width: 56.w,
              height: 56.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF1F2937),
              ),
              child: Icon(Icons.palette, color: Colors.white, size: 24.sp),
            ),
          ),
        ],
      ),
    );
  }
}
