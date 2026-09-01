import 'dart:io';
import 'package:flutter/foundation.dart';

class AdConfig {
  // Flag to toggle between Test Ads and Production Ads
  static const bool useTestAds = true;

  // ===========================================================================
  // YOUR ADMOB PRODUCTION APP & AD UNIT IDS
  // Replace the strings below with your actual AdMob IDs from the AdMob Console.
  // ===========================================================================

  // Production Banner Ad Unit IDs
  static const String _androidProdBannerUnitId = "ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX";
  static const String _iosProdBannerUnitId = "ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX";

  // Production Interstitial Ad Unit IDs
  static const String _androidProdInterstitialUnitId = "ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX";
  static const String _iosProdInterstitialUnitId = "ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX";

  // Android Production App ID (Place in AndroidManifest.xml)
  static const String androidAppId = "ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX";

  // iOS Production App ID (Place in Info.plist)
  static const String iosAppId = "ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX";

  // ===========================================================================
  // GOOGLE OFFICIAL TEST UNIT IDS (Safe for development and testing)
  // ===========================================================================
  static const String _androidTestBannerUnitId = "ca-app-pub-3940256099942544/6300978111";
  static const String _iosTestBannerUnitId = "ca-app-pub-3940256099942544/2934735716";

  static const String _androidTestInterstitialUnitId = "ca-app-pub-3940256099942544/1033173712";
  static const String _iosTestInterstitialUnitId = "ca-app-pub-3940256099942544/4411468910";

  /// Returns the appropriate Banner Ad Unit ID based on platform and mode
  static String get bannerAdUnitId {
    if (useTestAds) {
      if (kIsWeb) return _androidTestBannerUnitId;
      return Platform.isAndroid ? _androidTestBannerUnitId : _iosTestBannerUnitId;
    }

    if (kIsWeb) return _androidProdBannerUnitId;
    return Platform.isAndroid ? _androidProdBannerUnitId : _iosProdBannerUnitId;
  }

  /// Returns the appropriate Interstitial Ad Unit ID based on platform and mode
  static String get interstitialAdUnitId {
    if (useTestAds) {
      if (kIsWeb) return _androidTestInterstitialUnitId;
      return Platform.isAndroid ? _androidTestInterstitialUnitId : _iosTestInterstitialUnitId;
    }

    if (kIsWeb) return _androidProdInterstitialUnitId;
    return Platform.isAndroid ? _androidProdInterstitialUnitId : _iosProdInterstitialUnitId;
  }
}
