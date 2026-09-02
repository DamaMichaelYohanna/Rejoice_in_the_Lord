import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/ad_config.dart';

class InterstitialAdManager {
  static final InterstitialAdManager _instance = InterstitialAdManager._internal();
  factory InterstitialAdManager() => _instance;
  InterstitialAdManager._internal();

  InterstitialAd? _interstitialAd;
  bool _isAdLoading = false;

  // Strict Limit: Only 2 interstitial ads per day per user
  static const int maxAdsPerDay = 2;

  static const String _keyAdDate = "interstitial_ad_last_date";
  static const String _keyAdCount = "interstitial_ad_daily_count";

  /// Call this when the app initializes or whenever needed to preload an ad
  void preloadAd() async {
    if (kIsWeb || _isAdLoading || _interstitialAd != null) return;

    // Check if daily quota (max 2/day) is already reached before loading
    bool isQuotaReached = await _isDailyQuotaReached();
    if (isQuotaReached) {
      debugPrint('ℹ️ [AdMob] Daily interstitial quota reached ($maxAdsPerDay/day). Skipping preload.');
      return;
    }

    _isAdLoading = true;
    debugPrint('⏳ [AdMob] Preloading Interstitial Ad: ${AdConfig.interstitialAdUnitId}...');
    InterstitialAd.load(
      adUnitId: AdConfig.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('🟢 [AdMob] Interstitial Ad loaded successfully: ${ad.adUnitId}');
          _interstitialAd = ad;
          _isAdLoading = false;
        },
        onAdFailedToLoad: (error) {
          debugPrint('🔴 [AdMob] Interstitial Ad failed to load: code=${error.code}, message="${error.message}", domain="${error.domain}"');
          _interstitialAd = null;
          _isAdLoading = false;
        },
      ),
    );
  }

  /// Call this whenever a user opens a hymn to ensure an ad is preloaded
  void registerHymnView() {
    if (_interstitialAd == null && !_isAdLoading) {
      preloadAd();
    }
  }

  /// Helper to check if today's limit of 2 ads has been reached
  Future<bool> _isDailyQuotaReached() async {
    final prefs = await SharedPreferences.getInstance();
    final String todayStr = _getTodayDateString();

    final String? savedDate = prefs.getString(_keyAdDate);
    final int savedCount = prefs.getInt(_keyAdCount) ?? 0;

    if (savedDate != todayStr) {
      // New calendar day: reset counter to 0
      await prefs.setString(_keyAdDate, todayStr);
      await prefs.setInt(_keyAdCount, 0);
      return false;
    }

    return savedCount >= maxAdsPerDay;
  }

  /// Returns today's date formatted as YYYY-MM-DD
  String _getTodayDateString() {
    final now = DateTime.now();
    return "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }

  /// Increments today's ad count in SharedPreferences
  Future<void> _recordAdShown() async {
    final prefs = await SharedPreferences.getInstance();
    final String todayStr = _getTodayDateString();
    final String? savedDate = prefs.getString(_keyAdDate);
    int savedCount = prefs.getInt(_keyAdCount) ?? 0;

    if (savedDate != todayStr) {
      savedCount = 0;
    }

    savedCount++;
    await prefs.setString(_keyAdDate, todayStr);
    await prefs.setInt(_keyAdCount, savedCount);
    debugPrint('ℹ️ [AdMob] Interstitial ads shown today: $savedCount / $maxAdsPerDay');
  }

  /// Attempts to display an interstitial ad any time, capped at strictly 2 ads per day
  void tryShowAd({VoidCallback? onAdClosed}) async {
    bool quotaReached = await _isDailyQuotaReached();

    debugPrint('ℹ️ [AdMob] tryShowAd called: adReady=${_interstitialAd != null}, quotaReached=$quotaReached');

    if (quotaReached) {
      debugPrint('ℹ️ [AdMob] Daily limit reached ($maxAdsPerDay/day). No ad shown.');
      if (onAdClosed != null) onAdClosed();
      return;
    }

    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {
          debugPrint('🟢 [AdMob] Interstitial Ad showing full screen.');
        },
        onAdDismissedFullScreenContent: (ad) async {
          debugPrint('ℹ️ [AdMob] Interstitial Ad dismissed by user.');
          ad.dispose();
          _interstitialAd = null;
          await _recordAdShown();
          preloadAd();
          if (onAdClosed != null) onAdClosed();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          debugPrint('🔴 [AdMob] Interstitial Ad failed to show: code=${error.code}, message="${error.message}"');
          ad.dispose();
          _interstitialAd = null;
          preloadAd();
          if (onAdClosed != null) onAdClosed();
        },
      );

      _interstitialAd!.show();
    } else {
      if (!_isAdLoading) {
        preloadAd();
      }
      if (onAdClosed != null) onAdClosed();
    }
  }
}
