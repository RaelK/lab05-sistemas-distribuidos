import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/config/app_config.dart';
import '../../data/models/reservation.dart';
import '../../data/services/api_service.dart';
import '../widgets/status_badge.dart';

class ReservationsScreen extends StatefulWidget {
  const ReservationsScreen({super.key});

  @override
  State<ReservationsScreen> createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> {
  final ApiService _apiService = ApiService();

  List<Reservation> _reservations = [];
  bool _isLoading = true;
  String? _error;
  Timer? _timer;
  DateTime? _lastUpdate;

  @override
  void initState() {
    super.initState();
    _loadReservations();
    _timer = Timer.periodic(
      AppConfig.pollingInterval,
      (_) => _loadReservations(silent: true),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadReservations({bool silent = false}) async {
    if (!silent) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    }

    try {
      final reservations = await _apiService.getReservations();

      final clientReservations =
          reservations
              .where((item) => item.clientId == AppConfig.clientId)
              .toList()
            ..sort((a, b) => b.id.compareTo(a.id));

      if (!mounted) return;

      setState(() {
        _reservations = clientReservations;
        _lastUpdate = DateTime.now();
        _isLoading = false;
        _error = null;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _error = error.toString();
        _isLoading = false;
      });
    }
  }

  String _formatLastUpdate() {
    final lastUpdate = _lastUpdate;

    if (lastUpdate == null) {
      return 'Aguardando atualização';
    }

    final hour = lastUpdate.hour.toString().padLeft(2, '0');
    final minute = lastUpdate.minute.toString().padLeft(2, '0');
    final second = lastUpdate.second.toString().padLeft(2, '0');

    return 'Atualizado automaticamente às $hour:$minute:$second';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minhas reservas')),
      body: RefreshIndicator(
        onRefresh: () => _loadReservations(),
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            _PollingInfoCard(text: _formatLastUpdate()),
            const SizedBox(height: 14),
            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_error != null)
              _ErrorCard(message: _error!, onRetry: () => _loadReservations())
            else if (_reservations.isEmpty)
              const _EmptyReservationsCard()
            else
              ..._reservations.map(
                (reservation) => _ReservationCard(reservation: reservation),
              ),
          ],
        ),
      ),
    );
  }
}

class _PollingInfoCard extends StatelessWidget {
  final String text;

  const _PollingInfoCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFE7F5EC),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.sync, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '$text\nPolling ativo a cada ${AppConfig.pollingInterval.inSeconds} segundos.',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReservationCard extends StatelessWidget {
  final Reservation reservation;

  const _ReservationCard({required this.reservation});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StatusBadge(status: reservation.status),
            const SizedBox(height: 12),
            Text(
              'Reserva #${reservation.id}',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Text('Quadra ID: ${reservation.courtId}'),
            Text('Data: ${reservation.date}'),
            Text('Horário: ${reservation.startTime} às ${reservation.endTime}'),
          ],
        ),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorCard({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 12),
            Text(
              'Erro ao carregar reservas',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 14),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyReservationsCard extends StatelessWidget {
  const _EmptyReservationsCard();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(22),
        child: Text(
          'Nenhuma reserva encontrada para este cliente.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
