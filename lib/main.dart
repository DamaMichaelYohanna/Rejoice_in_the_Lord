import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Google Mobile Ads SDK
  await MobileAds.instance.initialize();
  runApp(const RejoiceInTheLordApp());
}

class RejoiceInTheLordApp extends StatelessWidget {
  const RejoiceInTheLordApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rejoice in the Lord',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
    );
  }
}
