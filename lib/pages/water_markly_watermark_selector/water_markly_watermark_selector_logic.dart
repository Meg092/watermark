import 'package:get/get.dart';
import 'package:water_markly/db_water_markly/db_water_markly.dart';
import 'package:water_markly/db_water_markly/db_water_markly_entity.dart';
import 'package:water_markly/utils/index.dart';

class WaterMarklyWatermarkSelectorLogic extends GetxController {
  final templates = <WatermarkTemplate>[].obs;
  final isLoading = false.obs;

  final db = Get.find<WaterMarklyDB>();

  @override
  void onInit() {
    super.onInit();
    _loadTemplates();
  }

  
  Future<void> _loadTemplates() async {
    try {
      isLoading.value = true;

      final loadedTemplates = await db.getAllWatermarkTemplates();
      templates.value = loadedTemplates;
    } catch (e) {
      errorToast('Failed to load watermark templates');
    } finally {
      isLoading.value = false;
    }
  }

  
  void selectTemplate(WatermarkTemplate template) {
    Get.back(result: template);
  }

  
  Future<void> toggleFavorite(int id, bool isFavorite) async {
    try {
      await db.toggleWatermarkTemplateFavorite(id, !isFavorite);
      
      
      final index = templates.indexWhere((t) => t.id == id);
      if (index != -1) {
        templates[index] = templates[index].copyWith(isFavorite: !isFavorite);
        templates.refresh();
      }

      successToast(isFavorite ? 'Removed from favorites' : 'Added to favorites');
    } catch (e) {
      errorToast('Failed to update favorite status');
    }
  }
}

