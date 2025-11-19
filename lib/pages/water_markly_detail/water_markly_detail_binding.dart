import 'package:get/get.dart';
import 'package:water_markly/pages/water_markly_detail/water_markly_detail_logic.dart';

class WaterMarklyDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WaterMarklyDetailLogic());
  }
}

