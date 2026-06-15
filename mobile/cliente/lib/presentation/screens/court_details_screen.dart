import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/court.dart';
import 'create_reservation_screen.dart';

class CourtDetailsScreen extends StatelessWidget {
  final Court court;
  final String arenaName;

  const CourtDetailsScreen({
    super.key,
    required this.court,
    required this.arenaName,
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

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes da quadra')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppTheme.darkGreen,
                  AppTheme.primaryGreen,
                  Color(0xFF0E8F47),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 16,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -18,
                  top: -20,
                  child: Icon(
                    _sportIcon,
                    size: 128,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(_sportIcon, color: Colors.white, size: 54),
                    const SizedBox(height: 18),
                    Text(
                      court.sport,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      arenaName,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _DetailStatCard(
                  icon: Icons.payments,
                  label: 'Preço',
                  value: 'R\$ $currency/h',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _DetailStatCard(
                  icon: Icons.groups,
                  label: 'Capacidade',
                  value: '${court.capacity}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _InfoCard(
            icon: court.available ? Icons.check_circle : Icons.block,
            title: 'Disponibilidade',
            value: court.available
                ? 'Quadra disponível para reserva'
                : 'Quadra indisponível no momento',
            positive: court.available,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: court.available
                ? () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => CreateReservationScreen(
                          court: court,
                          arenaName: arenaName,
                        ),
                      ),
                    );
                  }
                : null,
            icon: const Icon(Icons.event_available),
            label: const Text('Reservar esta quadra'),
          ),
        ],
      ),
    );
  }
}

class _DetailStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailStatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: AppTheme.primaryGreen, size: 30),
            const SizedBox(height: 10),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final bool positive;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.positive,
  });

  @override
  Widget build(BuildContext context) {
    final color = positive ? AppTheme.primaryGreen : Colors.red;

    return Card(
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title),
        subtitle: Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
