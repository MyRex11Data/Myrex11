import 'package:flutter/foundation.dart';

class AppInfo {
  static const String companyName = "myrex11";
  static const String companyAddress = "";
  static const String appName = "myrex11";
  static const String appVersion = "1.0.0";
  static const String appVersionDisplay = "20200801";
  static const String allRightReserved =
      "© 2020 \n myrex11. \nAll Rights Reserved.";

  static const String _ANDROID = "ANDROID";
  static const String _IOS = "IOS";

  static String getPlatform() =>
      defaultTargetPlatform == TargetPlatform.android ? _ANDROID : _IOS;
}
