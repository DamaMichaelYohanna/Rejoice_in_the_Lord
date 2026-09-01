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

  int _hymnViewCount = 0;

  // Strict Limits (User Requirements)
  static const int maxAdsPerDay = 2; // Strict limit: Max 2 interstitial ads per day per user
  static const int minHymnsBeforeAd = 5; // Show only after viewing at least 5 hymns

  static const String _keyAdDate = "interstitial_ad_last_date";
  static const String _keyAdCount = "interstitial_ad_daily_count";

  /// Call this when the app initializes to preload the first interstitial ad
  void preloadAd() async {
    if (kIsWeb || _isAdLoading || _interstitialAd != null) return;

    // Check if daily quota is already reached before loading from network
    bool isQuotaReached = await _isDailyQuotaReached();
    if (isQuotaReached) return;

    _isAdLoading = true;
    InterstitialAd.load(
      adUnitId: AdConfig.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isAdLoading = false;
        },
        onAdFailedToLoad: (error) {
          _interstitialAd = null;
          _isAdLoading = false;
        },
      ),
    );
  }

  /// Call this whenever a user opens/views a hymn
  void registerHymnView() {
    _hymnViewCount++;
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
      // New calendar day: reset counter
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
  }

  /// Attempts to display an interstitial ad if daily limit (max 2/day) and hymn count allow
  void tryShowAd({VoidCallback? onAdClosed}) async {
    bool quotaReached = await _isDailyQuotaReached();

    if (quotaReached) {
      if (onAdClosed != null) onAdClosed();
      return;
    }

    if (_hymnViewCount >= minHymnsBeforeAd && _interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) async {
          ad.dispose();
          _interstitialAd = null;
          _hymnViewCount = 0;
          await _recordAdShown();
          if (onAdClosed != null) onAdClosed();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _interstitialAd = null;
          if (onAdClosed != null) onAdClosed();
        },
      );

      _interstitialAd!.show();
    } else {
      if (onAdClosed != null) onAdClosed();
    }
  }
}
