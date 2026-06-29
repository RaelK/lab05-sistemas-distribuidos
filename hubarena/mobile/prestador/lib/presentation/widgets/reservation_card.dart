import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/reservation.dart';
import 'status_badge.dart';

class ReservationCard extends StatelessWidget {
  final Reservation reservation;
  final VoidCallback onTap;

  const ReservationCard({
    super.key,
    required this.reservation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: AppTheme.green.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.event_available,
                  color: AppTheme.green,
                  size: 30,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StatusBadge(status: reservation.status),
                    const SizedBox(height: 10),
                    Text(
                      'Reserva #${reservation.id}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Quadra ${reservation.courtId} • Cliente ${reservation.clientId}',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${reservation.date} • ${reservation.startTime} às ${reservation.endTime}',
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
