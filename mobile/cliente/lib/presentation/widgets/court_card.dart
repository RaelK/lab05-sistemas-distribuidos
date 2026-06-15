import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    final currency = court.priceHour.toStringAsFixed(2).replaceAll('.', ',');

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  _sportIcon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 32,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      court.sport,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      arenaName,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'R\$ $currency/h • ${court.capacity} atletas',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Icon(
                court.available ? Icons.check_circle : Icons.block,
                color: court.available ? Colors.green : Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
