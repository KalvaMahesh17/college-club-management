// lib/main.dart
// College Club Management - Flutter Lab Project
// Entry point of the application

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'services/storage_service.dart';
import 'utils/app_theme.dart';
import 'screens/splash_screen.dart';

void main() async {
  // Ensure Flutter bindings are initialized before any async operations
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences storage
  await StorageService.init();

  // Set preferred orientations (portrait only for a cleaner experience)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set status bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const CollegeClubApp());
}

class CollegeClubApp extends StatelessWidget {
  const CollegeClubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'College Club Management',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
