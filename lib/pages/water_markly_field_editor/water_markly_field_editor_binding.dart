import 'package:get/get.dart';
import 'package:water_markly/pages/water_markly_field_editor/water_markly_field_editor_logic.dart';

class WaterMarklyFieldEditorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WaterMarklyFieldEditorLogic());
  }
}

