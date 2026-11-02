import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'screens/main_nav_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const AgriChiliApp());
}

class AgriChiliApp extends StatelessWidget {
  const AgriChiliApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgriChili Monitor',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      home: const MainNavScreen(),
    );
  }
}
