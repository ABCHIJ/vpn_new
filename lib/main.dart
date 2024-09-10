import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vpnapp/allScreens/home_screen.dart';
import 'package:vpnapp/appPreferences/appPreferences.dart';

late Size sizeScreen; // Ensure this is initialized appropriately if used later.

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppPreferences.initHive(); // Initializing Hive for preference storage.

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Free Vpn',
      theme: ThemeData(
        appBarTheme: AppBarTheme(centerTitle: true, elevation: 3),
        // Consider adding primaryColor, buttonTheme, etc., for full theme consistency
      ),
      themeMode: AppPreferences.isModeDark ? ThemeMode.dark : ThemeMode.light,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        appBarTheme: AppBarTheme(centerTitle: true, elevation: 3),
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(), // Ensure HomeScreen is set up to use themes properly.
    );
  }
}

extension AppTheme on ThemeData {
  Color get lightTextColor =>
      AppPreferences.isModeDark ? Colors.white70 : Colors.black54;
  Color get bottomNavigationColor =>
      AppPreferences.isModeDark ? Colors.white12 : Colors.redAccent;
}
