import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'state/app_state.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AppState())],
      child: const TreasuresOfJordanApp(),
    ),
  );
}

class TreasuresOfJordanApp extends StatelessWidget {
  const TreasuresOfJordanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'كنوز الأردن',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar', 'JO'), // Set Arabic locale primarily
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl, // RTL layout for Arabic
          child: child!,
        );
      },
      home: const HomeScreen(),
    );
  }
}
