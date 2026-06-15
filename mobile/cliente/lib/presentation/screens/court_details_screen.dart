import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    final currency = court.priceHour.toStringAsFixed(2).replaceAll('.', ',');

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes da quadra')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF063B1E),
              borderRadius: BorderRadius.circular(26),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.stadium, color: Colors.white, size: 52),
                const SizedBox(height: 18),
                Text(
                  court.sport,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  arenaName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _InfoTile(
            icon: Icons.payments,
            title: 'Valor por hora',
            value: 'R\$ $currency',
          ),
          _InfoTile(
            icon: Icons.groups,
            title: 'Capacidade',
            value: '${court.capacity} atletas',
          ),
          _InfoTile(
            icon: court.available ? Icons.check_circle : Icons.block,
            title: 'Disponibilidade',
            value: court.available ? 'Disponível para reserva' : 'Indisponível',
          ),
          const SizedBox(height: 22),
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
            icon: const Icon(Icons.event),
            label: const Text('Reservar esta quadra'),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title),
        subtitle: Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
