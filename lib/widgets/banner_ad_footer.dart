import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../config/ad_config.dart';
import '../theme/app_theme.dart';

class BannerAdFooter extends StatefulWidget {
  const BannerAdFooter({super.key});

  @override
  State<BannerAdFooter> createState() => _BannerAdFooterState();
}

class _BannerAdFooterState extends State<BannerAdFooter> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  int _currentAdIndex = 0;
  Timer? _adRotateTimer;

  static const List<Map<String, String>> _sampleAds = [
    {
      "title": "Catholic Liturgical Calendar 2026",
      "subtitle": "Daily Mass readings & Saint feast days",
      "sponsor": "Catholic Daily Grace",
      "cta": "INSTALL",
    },
    {
      "title": "Divine Office & Breviary App",
      "subtitle": "Pray the Liturgy of the Hours anywhere",
      "sponsor": "Liturgy Media",
      "cta": "OPEN",
    },
    {
      "title": "Support 'Rejoice in the Lord' Hymnal",
      "subtitle": "Keep Catholic hymnody ad-supported and free",
      "sponsor": "Rejoice Community",
      "cta": "LEARN MORE",
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadGoogleBannerAd();

    // Fallback rotation timer for web/desktop or pending load
    _adRotateTimer = Timer.periodic(const Duration(seconds: 8), (timer) {
      if (mounted) {
        setState(() {
          _currentAdIndex = (_currentAdIndex + 1) % _sampleAds.length;
        });
      }
    });
  }

  void _loadGoogleBannerAd() {
    // Only attempt native AdMob load on mobile platforms
    if (kIsWeb) return;

    _bannerAd = BannerAd(
      adUnitId: AdConfig.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('🟢 [AdMob] Banner Ad loaded successfully: ${ad.adUnitId}');
          if (mounted) {
            setState(() {
              _isAdLoaded = true;
            });
          }
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('🔴 [AdMob] Banner Ad failed to load: code=${error.code}, message="${error.message}", domain="${error.domain}"');
          ad.dispose();
          if (mounted) {
            setState(() {
              _isAdLoaded = false;
            });
          }
        },
        onAdOpened: (ad) => debugPrint('ℹ️ [AdMob] Banner Ad opened.'),
        onAdClosed: (ad) => debugPrint('ℹ️ [AdMob] Banner Ad closed.'),
        onAdImpression: (ad) => debugPrint('ℹ️ [AdMob] Banner Ad impression recorded.'),
      ),
    );

    _bannerAd?.load();
  }

  @override
  void dispose() {
    _adRotateTimer?.cancel();
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface : Colors.grey.shade100,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.white10 : Colors.grey.shade300,
            width: 1,
          ),
        ),
      ),
      child: Center(
        child: _isAdLoaded && _bannerAd != null
            // Render Live Google Mobile Ad Widget
            ? SizedBox(
                width: _bannerAd!.size.width.toDouble(),
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              )
            // Render Ad Placeholder Container
            : _buildFallbackBannerAd(isDark),
      ),
    );
  }

  Widget _buildFallbackBannerAd(bool isDark) {
    final currentAd = _sampleAds[_currentAdIndex];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        children: [
          // AdMob Gold Badge Indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFFBC02D),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              "Ad",
              style: TextStyle(
                color: Colors.black,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Ad Content Text
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: Column(
                key: ValueKey<int>(_currentAdIndex),
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    currentAd["title"]!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  Text(
                    "${currentAd["sponsor"]} • ${currentAd["subtitle"]}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      color: isDark ? Colors.white60 : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          // CTA Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.cyanPrimary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              minimumSize: const Size(60, 28),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              elevation: 0,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Ad Action: ${currentAd["title"]}"),
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Text(
              currentAd["cta"]!,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 4),
          // Ad Info Icon
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Row(
                    children: [
                      Icon(Icons.info_outline, color: AppTheme.cyanPrimary),
                      SizedBox(width: 8),
                      Text("Google AdMob Active"),
                    ],
                  ),
                  content: const Text(
                    "Google Mobile Ads SDK is integrated into the footer of all screens.\n\nTo view your live AdMob ads, configure your Production AdMob App ID and Banner Unit ID in lib/config/ad_config.dart.",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("OK"),
                    ),
                  ],
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(
                Icons.info_outline,
                size: 14,
                color: isDark ? Colors.white54 : Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
