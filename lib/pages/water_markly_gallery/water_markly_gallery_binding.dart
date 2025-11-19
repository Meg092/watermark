import 'package:get/get.dart';
import 'package:water_markly/pages/water_markly_gallery/water_markly_gallery_logic.dart';

class WaterMarklyGalleryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WaterMarklyGalleryLogic());
  }
}

