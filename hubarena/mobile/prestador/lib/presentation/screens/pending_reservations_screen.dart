import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/config/app_config.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/reservation.dart';
import '../../data/services/api_service.dart';
import '../widgets/reservation_card.dart';
import 'reservation_details_screen.dart';

class PendingReservationsScreen extends StatefulWidget {
  const PendingReservationsScreen({super.key});

  @override
  State<PendingReservationsScreen> createState() =>
      _PendingReservationsScreenState();
}

class _PendingReservationsScreenState extends State<PendingReservationsScreen> {
  final ApiService _apiService = ApiService();

  List<Reservation> _pendingReservations = [];
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

      final pending = reservations.where((item) => item.isPending).toList()
        ..sort((a, b) => b.id.compareTo(a.id));

      if (!mounted) return;

      setState(() {
        _pendingReservations = pending;
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

  String _lastUpdateText() {
    final update = _lastUpdate;

    if (update == null) {
      return 'Aguardando atualização';
    }

    final hour = update.hour.toString().padLeft(2, '0');
    final minute = update.minute.toString().padLeft(2, '0');
    final second = update.second.toString().padLeft(2, '0');

    return 'Atualizado às $hour:$minute:$second';
  }

  Future<void> _openDetails(Reservation reservation) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ReservationDetailsScreen(reservation: reservation),
      ),
    );

    await _loadReservations();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _loadReservations(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _HeaderCard(total: _pendingReservations.length),
          const SizedBox(height: 14),
          _PollingCard(text: _lastUpdateText()),
          const SizedBox(height: 16),
          Text(
            'Solicitações pendentes',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_error != null)
            _ErrorCard(message: _error!, onRetry: () => _loadReservations())
          else if (_pendingReservations.isEmpty)
            const _EmptyCard()
          else
            ..._pendingReservations.map(
              (reservation) => ReservationCard(
                reservation: reservation,
                onTap: () => _openDetails(reservation),
              ),
            ),
        ],
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final int total;

  const _HeaderCard({required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          const Icon(Icons.notifications_active, color: Colors.white, size: 44),
          const SizedBox(height: 14),
          Text(
            'Novas solicitações',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$total reservas aguardando resposta',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _PollingCard extends StatelessWidget {
  final String text;

  const _PollingCard({required this.text});

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
                '$text\nNotificação automática via polling a cada ${AppConfig.pollingInterval.inSeconds} segundos.',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
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
            const Icon(Icons.error_outline, color: Colors.red, size: 46),
            const SizedBox(height: 10),
            Text(
              'Erro ao carregar solicitações',
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

class _EmptyCard extends StatelessWidget {
  const _EmptyCard();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(22),
        child: Text(
          'Nenhuma solicitação pendente no momento.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
