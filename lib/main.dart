import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:water_markly/pages/water_markly_camera/water_markly_camera_binding.dart';
import 'package:water_markly/pages/water_markly_camera/water_markly_camera_view.dart';
import 'package:water_markly/pages/water_markly_detail/water_markly_detail_binding.dart';
import 'package:water_markly/pages/water_markly_detail/water_markly_detail_view.dart';
import 'package:water_markly/pages/water_markly_field_editor/water_markly_field_editor_binding.dart';
import 'package:water_markly/pages/water_markly_field_editor/water_markly_field_editor_view.dart';
import 'package:water_markly/pages/water_markly_gallery/water_markly_gallery_binding.dart';
import 'package:water_markly/pages/water_markly_gallery/water_markly_gallery_list.dart';
import 'package:water_markly/pages/water_markly_gallery/water_markly_gallery_view.dart';
import 'package:water_markly/pages/water_markly_main/water_markly_main_binding.dart';
import 'package:water_markly/pages/water_markly_main/water_markly_main_view.dart';
import 'package:water_markly/pages/water_markly_watermark_selector/water_markly_watermark_selector_binding.dart';
import 'package:water_markly/pages/water_markly_watermark_selector/water_markly_watermark_selector_view.dart';
import 'package:water_markly/db_water_markly/db_water_markly.dart';

Color primaryColor = const Color(0xFF667eea);
Color bgColor = const Color(0xFFF9FAFB);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Get.putAsync(() => WaterMarklyDB().init());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          getPages: Markly,
          initialRoute: '/',
          theme: ThemeData(
            useMaterial3: true,
            primaryColor: primaryColor,
            scaffoldBackgroundColor: bgColor,
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              surface: Color(0xFFFFFFFF),
            ),
            appBarTheme: const AppBarTheme(
              elevation: 0,
              scrolledUnderElevation: 0,
              centerTitle: true,
              titleTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF0F0F0F),
              ),
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(size: 22, color: Color(0xFF0F0F0F)),
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              selectedLabelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
              unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedItemColor: Color(0xFFC9743B),
              unselectedItemColor: Color(0xFF292929),
              elevation: 0,
              backgroundColor: Color(0xFFFFFFFF),
            ),
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            dividerTheme: DividerThemeData(
              thickness: 1,
              color: Colors.grey[200],
            ),
          ),
        );
      },
    );
  }
}
List<GetPage<dynamic>> Markly = [
  GetPage(
    name: '/',
    page: () => const WaterMarklyMainView(),
    binding: WaterMarklyMainBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: true,
  ),
  GetPage(
    name: '/camera',
    page: () => const WaterMarklyCameraView(),
    binding: WaterMarklyCameraBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: true,
  ),
  GetPage(
    name: '/watermark_selector',
    page: () => const WaterMarklyWatermarkSelectorView(),
    binding: WaterMarklyWatermarkSelectorBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/field_editor',
    page: () => const WaterMarklyFieldEditorView(),
    binding: WaterMarklyFieldEditorBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/gallery',
    page: () => const WaterMarklyGalleryView(),
    binding: WaterMarklyGalleryBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/gallery_list',
    page: () => WaterMarklyGalleryList(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
  GetPage(
    name: '/detail',
    page: () => const WaterMarklyDetailView(),
    binding: WaterMarklyDetailBinding(),
    transition: Transition.cupertino,
    popGesture: true,
    preventDuplicates: false,
  ),
];