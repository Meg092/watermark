import 'package:get/get.dart';
import 'package:water_markly/pages/water_markly_watermark_selector/water_markly_watermark_selector_logic.dart';

class WaterMarklyWatermarkSelectorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WaterMarklyWatermarkSelectorLogic());
  }
}

