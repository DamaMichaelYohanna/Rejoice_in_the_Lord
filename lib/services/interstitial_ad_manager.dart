import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../config/ad_config.dart';

class InterstitialAdManager {
  static final InterstitialAdManager _instance = InterstitialAdManager._internal();
  factory InterstitialAdManager() => _instance;
  InterstitialAdManager._internal();

  InterstitialAd? _interstitialAd;
  bool _isAdLoading = false;

  int _hymnViewCount = 0;
  DateTime? _lastAdShownTime;

  // Capping parameters (UX Best Practice)
  static const int minHymnsBeforeAd = 5; // Show at most every 5 hymn views
  static const Duration minCooldownDuration = Duration(minutes: 3); // 3 minutes cooldown

  /// Call this when the app initializes to preload the first interstitial ad
  void preloadAd() {
    if (kIsWeb || _isAdLoading || _interstitialAd != null) return;

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

  /// Attempts to display an interstitial ad if conditions & cooldown allow
  void tryShowAd({VoidCallback? onAdClosed}) {
    // Check if frequency threshold and cooldown time have passed
    final now = DateTime.now();
    final isCooldownPassed = _lastAdShownTime == null ||
        now.difference(_lastAdShownTime!) >= minCooldownDuration;

    if (_hymnViewCount >= minHymnsBeforeAd && isCooldownPassed && _interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _interstitialAd = null;
          _hymnViewCount = 0;
          _lastAdShownTime = DateTime.now();
          preloadAd(); // Preload next ad
          if (onAdClosed != null) onAdClosed();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _interstitialAd = null;
          preloadAd();
          if (onAdClosed != null) onAdClosed();
        },
      );

      _interstitialAd!.show();
    } else {
      if (onAdClosed != null) onAdClosed();
    }
  }
}
