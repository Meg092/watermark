import 'package:get/get.dart';
import 'package:water_markly/pages/water_markly_camera/water_markly_camera_logic.dart';

class WaterMarklyCameraBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WaterMarklyCameraLogic());
  }
}

