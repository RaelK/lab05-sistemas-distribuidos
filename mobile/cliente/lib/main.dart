import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'presentation/screens/home_screen.dart';

void main() {
  runApp(const HubArenaClienteApp());
}

class HubArenaClienteApp extends StatelessWidget {
  const HubArenaClienteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HubArena Cliente',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const HomeScreen(),
    );
  }
}
