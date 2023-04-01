import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'theming/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MES Project',
      theme: AppTheme.themeData,
      home: const HomeScreen(),
    );
  }
}
