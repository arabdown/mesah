import 'dart:io';

class Ads {
  static String get appId {
    if (Platform.isAndroid) {
      return "ca-app-pub-8318136058462894~6986590261";
    } else if (Platform.isIOS) {
      return "ca-app-pub-8318136058462894~7546839370";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-8318136058462894/5673508594";
    } else if (Platform.isIOS) {
      return "ca-app-pub-8318136058462894/6233757705";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-8318136058462894/8739770965";
    } else if (Platform.isIOS) {
      return "ca-app-pub-8318136058462894/6843115803";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
}
