import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class SyncInfoCard extends StatelessWidget {
  final String text;

  const SyncInfoCard({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFEAF7EF),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.sync, color: AppTheme.green),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
