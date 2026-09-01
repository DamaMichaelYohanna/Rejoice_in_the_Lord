import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class BannerAdFooter extends StatefulWidget {
  const BannerAdFooter({super.key});

  @override
  State<BannerAdFooter> createState() => _BannerAdFooterState();
}

class _BannerAdFooterState extends State<BannerAdFooter> {
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
    {
      "title": "Catholic Hymns Audio & Melodies",
      "subtitle": "Listen to organ & choir recordings for all 700 hymns",
      "sponsor": "Sacred Music Press",
      "cta": "LISTEN NOW",
    },
  ];

  @override
  void initState() {
    super.initState();
    // Rotate sample banner ads every 8 seconds
    _adRotateTimer = Timer.periodic(const Duration(seconds: 8), (timer) {
      if (mounted) {
        setState(() {
          _currentAdIndex = (_currentAdIndex + 1) % _sampleAds.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _adRotateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currentAd = _sampleAds[_currentAdIndex];

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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Row(
          children: [
            // Standard "Ad" Badge Indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFFBC02D), // AdMob Gold Badge
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
            // Info Icon
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Row(
                      children: [
                        Icon(Icons.info_outline, color: AppTheme.cyanPrimary),
                        SizedBox(width: 8),
                        Text("Ad Information"),
                      ],
                    ),
                    content: const Text(
                      "This app displays banner ads powered by Google Mobile Ads (AdMob) at the footer of all screens to support free Catholic hymnody distribution.\n\nProduction AdMob Banner Unit ID can be configured in your environment.",
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
      ),
    );
  }
}
