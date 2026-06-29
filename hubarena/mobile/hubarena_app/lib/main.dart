import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'modules/auth/screens/profile_selection_screen.dart';

void main() {
  runApp(const HubArenaApp());
}

class HubArenaApp extends StatelessWidget {
  const HubArenaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HubArena',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const ProfileSelectionScreen(),
    );
  }
}
