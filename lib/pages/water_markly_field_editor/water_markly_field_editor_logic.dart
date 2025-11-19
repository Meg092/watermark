import 'package:get/get.dart';
import 'package:water_markly/db_water_markly/db_water_markly_entity.dart';
import 'package:water_markly/utils/index.dart';

class WaterMarklyFieldEditorLogic extends GetxController {
  late WatermarkTemplate template;
  final fieldsData = <String, String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeTemplate();
  }

  
  void _initializeTemplate() {
    final args = Get.arguments;
    
    
    if (args is WatermarkTemplate) {
      
      template = args;
      
      
      for (final config in template.fieldsConfig) {
        final name = config['name'] as String;
        fieldsData[name] = '';
      }
    } else if (args is Map) {
      
      final templateData = args['template'];
      final existingFields = args['fieldsData'] as Map<String, String>?;
      
      if (templateData == null || templateData is! WatermarkTemplate) {
        errorToast('Invalid template data');
        Get.back();
        return;
      }
      
      template = templateData;
      
      
      for (final config in template.fieldsConfig) {
        final name = config['name'] as String;
        fieldsData[name] = existingFields?[name] ?? '';
      }
    } else {
      errorToast('Invalid template data');
      Get.back();
      return;
    }
  }

  
  void updateField(String name, String value) {
    fieldsData[name] = value;
  }

  
  void continueToCamera() {
    
    
    Get.back(result: Map<String, String>.from(fieldsData));
  }
}

