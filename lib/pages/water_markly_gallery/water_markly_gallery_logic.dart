import 'package:get/get.dart';
import 'package:water_markly/db_water_markly/db_water_markly.dart';
import 'package:water_markly/db_water_markly/db_water_markly_entity.dart';
import 'package:water_markly/utils/index.dart';

class WaterMarklyGalleryLogic extends GetxController {
  final mediaRecords = <MediaRecord>[].obs;
  final isLoading = false.obs;

  final db = Get.find<WaterMarklyDB>();

  @override
  void onInit() {
    super.onInit();
    loadMediaRecords();
  }

  
  Future<void> loadMediaRecords() async {
    try {
      isLoading.value = true;
      final records = await db.getAllMediaRecords();
      mediaRecords.value = records;
    } catch (e) {
      errorToast('Failed to load media records');
    } finally {
      isLoading.value = false;
    }
  }

  
  void onMediaTap(MediaRecord record) {
    Get.toNamed(
      '/detail',
      arguments: record,
    )?.then((_) {
      
      loadMediaRecords();
    });
  }

  
  Future<void> onRefresh() async {
    await loadMediaRecords();
  }
}

