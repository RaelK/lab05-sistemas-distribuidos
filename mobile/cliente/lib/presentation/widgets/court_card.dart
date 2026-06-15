import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/court.dart';

class CourtCard extends StatelessWidget {
  final Court court;
  final String arenaName;
  final VoidCallback onTap;

  const CourtCard({
    super.key,
    required this.court,
    required this.arenaName,
    required this.onTap,
  });

  IconData get _sportIcon {
    final sport = court.sport.toLowerCase();

    if (sport.contains('fut')) return Icons.sports_soccer;
    if (sport.contains('bas')) return Icons.sports_basketball;
    if (sport.contains('ten')) return Icons.sports_tennis;
    if (sport.contains('volei') || sport.contains('vôlei')) {
      return Icons.sports_volleyball;
    }

    return Icons.sports;
  }

  String get _sportLabel {
    final sport = court.sport.trim();

    if (sport.isEmpty) {
      return 'Quadra esportiva';
    }

    return sport;
  }

  @override
  Widget build(BuildContext context) {
    final currency = court.priceHour.toStringAsFixed(2).replaceAll('.', ',');

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.darkGreen, AppTheme.primaryGreen],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Icon(_sportIcon, color: Colors.white, size: 36),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _sportLabel,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(
                          Icons.stadium,
                          size: 16,
                          color: AppTheme.primaryGreen,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            arenaName,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 9),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _MiniBadge(
                          icon: Icons.groups,
                          text: '${court.capacity} atletas',
                        ),
                        _MiniBadge(
                          icon: Icons.payments,
                          text: 'R\$ $currency/h',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                court.available ? Icons.arrow_forward_ios : Icons.block,
                color: court.available ? AppTheme.primaryGreen : Colors.red,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniBadge extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MiniBadge({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppTheme.primaryGreen),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
