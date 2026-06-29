import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'presentation/screens/provider_shell.dart';

void main() {
  runApp(const HubArenaProviderApp());
}

class HubArenaProviderApp extends StatelessWidget {
  const HubArenaProviderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HubArena Prestador',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const ProviderShell(),
    );
  }
}
