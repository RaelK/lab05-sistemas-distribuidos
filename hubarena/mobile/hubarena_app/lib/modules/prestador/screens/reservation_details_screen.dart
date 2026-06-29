import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/reservation.dart';
import '../../../data/services/api_service.dart';
import '../widgets/status_badge.dart';

class ReservationDetailsScreen extends StatefulWidget {
  final Reservation reservation;

  const ReservationDetailsScreen({super.key, required this.reservation});

  @override
  State<ReservationDetailsScreen> createState() =>
      _ReservationDetailsScreenState();
}

class _ReservationDetailsScreenState extends State<ReservationDetailsScreen> {
  final ApiService _apiService = ApiService();

  late Reservation _reservation;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _reservation = widget.reservation;
  }

  Future<void> _accept() async {
    await _submit(
      action: () => _apiService.acceptReservation(_reservation.id),
      successMessage: 'Reserva aceita com sucesso.',
    );
  }

  Future<void> _reject() async {
    await _submit(
      action: () => _apiService.rejectReservation(_reservation.id),
      successMessage: 'Reserva recusada com sucesso.',
    );
  }

  Future<void> _finish() async {
    await _submit(
      action: () => _apiService.finishReservation(_reservation.id),
      successMessage: 'Reserva finalizada com sucesso.',
    );
  }

  Future<void> _submit({
    required Future<Reservation> Function() action,
    required String successMessage,
  }) async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      final updated = await action();

      if (!mounted) return;

      setState(() {
        _reservation = updated;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(successMessage)));
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  bool get _canRespond => _reservation.isPending && !_isSubmitting;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes da solicitação')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.dark, AppTheme.green],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(26),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StatusBadge(status: _reservation.status),
                const SizedBox(height: 18),
                Text(
                  'Reserva #${_reservation.id}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Solicitação enviada pelo cliente',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _InfoTile(
            icon: Icons.person,
            title: 'Cliente',
            value: 'Cliente ID ${_reservation.clientId}',
          ),
          _InfoTile(
            icon: Icons.stadium,
            title: 'Quadra',
            value: 'Quadra ID ${_reservation.courtId}',
          ),
          _InfoTile(
            icon: Icons.calendar_month,
            title: 'Data',
            value: _reservation.date,
          ),
          _InfoTile(
            icon: Icons.access_time,
            title: 'Horário',
            value: '${_reservation.startTime} às ${_reservation.endTime}',
          ),
          const SizedBox(height: 20),
          if (_reservation.isPending) ...[
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _canRespond ? _reject : null,
                    icon: const Icon(Icons.cancel),
                    label: const Text('Recusar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _canRespond ? _accept : null,
                    icon: const Icon(Icons.check_circle),
                    label: const Text('Aceitar'),
                  ),
                ),
              ],
            ),
          ] else if (_reservation.isAccepted) ...[
            ElevatedButton.icon(
              onPressed: _isSubmitting ? null : _finish,
              icon: const Icon(Icons.flag_circle),
              label: const Text('Finalizar reserva'),
            ),
          ] else
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Text(
                  'Esta solicitação já foi encerrada.',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ),
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
        leading: Icon(icon, color: AppTheme.green),
        title: Text(title),
        subtitle: Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
