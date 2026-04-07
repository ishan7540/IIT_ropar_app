import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aahar_app/theme.dart';
import 'package:aahar_app/screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppTheme.surfaceContainerLowest,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const AaharApp());
}

class AaharApp extends StatelessWidget {
  const AaharApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aahar - Precision Agriculture',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
    );
  }
}
