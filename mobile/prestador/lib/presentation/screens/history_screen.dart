import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/config/app_config.dart';
import '../../data/models/reservation.dart';
import '../../data/services/api_service.dart';
import '../widgets/hubarena_header.dart';
import '../widgets/reservation_card.dart';
import '../widgets/sync_info_card.dart';
import 'reservation_details_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final ApiService _apiService = ApiService();

  List<Reservation> _history = [];
  bool _isLoading = true;
  String? _error;
  Timer? _timer;
  DateTime? _lastUpdate;

  @override
  void initState() {
    super.initState();
    _loadHistory();

    _timer = Timer.periodic(
      AppConfig.pollingInterval,
      (_) => _loadHistory(silent: true),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadHistory({bool silent = false}) async {
    if (!silent) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    }

    try {
      final reservations = await _apiService.getReservations();

      final history =
          reservations
              .where((item) => item.isAccepted || item.isRejected)
              .toList()
            ..sort((a, b) => b.id.compareTo(a.id));

      if (!mounted) return;

      setState(() {
        _history = history;
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

  int get _accepted => _history.where((item) => item.isAccepted).length;

  int get _rejected => _history.where((item) => item.isRejected).length;

  String _lastUpdateText() {
    final update = _lastUpdate;

    if (update == null) {
      return 'Aguardando atualização';
    }

    final hour = update.hour.toString().padLeft(2, '0');
    final minute = update.minute.toString().padLeft(2, '0');
    final second = update.second.toString().padLeft(2, '0');

    return '$hour:$minute:$second';
  }

  Future<void> _openDetails(Reservation reservation) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ReservationDetailsScreen(reservation: reservation),
      ),
    );

    await _loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Histórico')),
      body: RefreshIndicator(
        onRefresh: () => _loadHistory(),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            HubArenaHeader(
              label: 'HISTÓRICO',
              title: 'Reservas\nrespondidas',
              subtitle:
                  '$_accepted aceitas • $_rejected recusadas • atualizado às ${_lastUpdateText()}',
              icon: Icons.history,
            ),
            const SizedBox(height: 14),
            SyncInfoCard(
              text:
                  'Histórico sincronizado automaticamente a cada ${AppConfig.pollingInterval.inSeconds} segundos.',
            ),
            const SizedBox(height: 18),
            Text(
              'Últimas solicitações',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_error != null)
              _ErrorCard(message: _error!, onRetry: () => _loadHistory())
            else if (_history.isEmpty)
              const _EmptyCard()
            else
              ..._history.map(
                (reservation) => ReservationCard(
                  reservation: reservation,
                  onTap: () => _openDetails(reservation),
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
              'Erro ao carregar histórico',
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
          'Nenhuma reserva respondida ainda.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
