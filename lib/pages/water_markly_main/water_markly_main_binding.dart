import 'package:get/get.dart';

import 'water_markly_main_logic.dart';

class WaterMarklyMainBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      WaterMarklyMainLogic(),
      permanent: true,
    );
  }
}
