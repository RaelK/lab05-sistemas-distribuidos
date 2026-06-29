import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/config/app_config.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/reservation.dart';
import '../../../data/services/api_service.dart';

class MinhasReservasScreen extends StatefulWidget {
  const MinhasReservasScreen({super.key});

  @override
  State<MinhasReservasScreen> createState() => _MinhasReservasScreenState();
}

class _MinhasReservasScreenState extends State<MinhasReservasScreen> {
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
      final allReservations = await _apiService.getReservations();

      final clientReservations =
          allReservations
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

  String _lastUpdateText() {
    final update = _lastUpdate;

    if (update == null) return 'Aguardando atualização';

    final hour = update.hour.toString().padLeft(2, '0');
    final minute = update.minute.toString().padLeft(2, '0');
    final second = update.second.toString().padLeft(2, '0');

    return 'Atualizado às $hour:$minute:$second';
  }

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return Colors.orange;
      case 'ACCEPTED':
        return Colors.green;
      case 'REJECTED':
        return Colors.red;
      case 'CANCELLED':
        return Colors.grey;
      case 'FINISHED':
        return AppTheme.green;
      default:
        return Colors.grey;
    }
  }

  String _statusLabel(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return 'PENDENTE';
      case 'ACCEPTED':
        return 'ACEITA';
      case 'REJECTED':
        return 'RECUSADA';
      case 'CANCELLED':
        return 'CANCELADA';
      case 'FINISHED':
        return 'FINALIZADA';
      default:
        return status;
    }
  }

  IconData _statusIcon(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return Icons.schedule;
      case 'ACCEPTED':
        return Icons.check_circle;
      case 'REJECTED':
        return Icons.cancel;
      case 'CANCELLED':
        return Icons.block;
      case 'FINISHED':
        return Icons.flag_circle;
      default:
        return Icons.info;
    }
  }

  Widget _statusBadge(Reservation reservation) {
    final color = _statusColor(reservation.status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_statusIcon(reservation.status), color: color, size: 16),
          const SizedBox(width: 5),
          Text(
            _statusLabel(reservation.status),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w900,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _cancelReservation(Reservation reservation) async {
    try {
      await _apiService.cancelReservation(reservation.id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Reserva #${reservation.id} cancelada com sucesso.'),
        ),
      );

      await _loadReservations();
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _reservationCard(Reservation reservation) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: AppTheme.green.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(Icons.event, color: AppTheme.green, size: 32),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _statusBadge(reservation),
                  const SizedBox(height: 10),
                  Text(
                    'Reserva #${reservation.id}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Quadra ${reservation.courtId}',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${reservation.date} • ${reservation.startTime} às ${reservation.endTime}',
                  ),
                  if (reservation.isPending) ...[
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () => _cancelReservation(reservation),
                      icon: const Icon(Icons.cancel),
                      label: const Text('Cancelar reserva'),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  int get _pending => _reservations.where((item) => item.isPending).length;
  int get _accepted => _reservations.where((item) => item.isAccepted).length;
  int get _rejected => _reservations.where((item) => item.isRejected).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minhas Reservas')),
      body: RefreshIndicator(
        onRefresh: () => _loadReservations(),
        child: ListView(
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
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.list_alt, color: Colors.white, size: 44),
                  const SizedBox(height: 16),
                  Text(
                    'Acompanhe suas\nreservas',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontSize: 30,
                      height: 1.05,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '$_pending pendentes • $_accepted aceitas • $_rejected recusadas',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Card(
              color: const Color(0xFFEAF7EF),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.sync, color: AppTheme.green),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '${_lastUpdateText()}\nAtualização automática a cada ${AppConfig.pollingInterval.inSeconds} segundos.',
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_error != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red),
                      const SizedBox(height: 8),
                      Text(_error!, textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () => _loadReservations(),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Tentar novamente'),
                      ),
                    ],
                  ),
                ),
              )
            else if (_reservations.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(22),
                  child: Text(
                    'Você ainda não possui reservas.',
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else
              ..._reservations.map(_reservationCard),
          ],
        ),
      ),
    );
  }
}
