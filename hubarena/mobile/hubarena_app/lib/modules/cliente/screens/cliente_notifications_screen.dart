import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/config/app_config.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/reservation.dart';
import '../../../data/services/api_service.dart';

class ClienteNotificationsScreen extends StatefulWidget {
  const ClienteNotificationsScreen({super.key});

  @override
  State<ClienteNotificationsScreen> createState() =>
      _ClienteNotificationsScreenState();
}

class _ClienteNotificationsScreenState
    extends State<ClienteNotificationsScreen> {
  final ApiService _apiService = ApiService();

  List<Reservation> _reservations = [];
  static bool _notificationsCleared = false;
  bool _isLoading = true;
  String? _error;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _load();

    _timer = Timer.periodic(
      AppConfig.pollingInterval,
      (_) => _load(silent: true),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _load({bool silent = false}) async {
    if (!silent) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    }

    try {
      final reservations = await _apiService.getReservationsByClient(
        AppConfig.clientId,
      );

      if (!mounted) return;

      setState(() {
        _reservations = reservations;
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

  List<Reservation> get _notifications {
    if (_notificationsCleared) return [];

    return _reservations
        .where(
          (item) =>
              item.isAccepted ||
              item.isRejected ||
              item.isCancelled ||
              item.isFinished,
        )
        .toList();
  }

  void _clearNotifications() {
    setState(() {
      _notificationsCleared = true;
    });
  }

  String _title(Reservation reservation) {
    if (reservation.isAccepted) return 'Reserva aceita';
    if (reservation.isRejected) return 'Reserva recusada';
    if (reservation.isCancelled) return 'Reserva cancelada';
    if (reservation.isFinished) return 'Reserva finalizada';
    return 'Atualização de reserva';
  }

  String _description(Reservation reservation) {
    return 'Reserva #${reservation.id} • Quadra ${reservation.courtId} • ${reservation.date} das ${reservation.startTime} às ${reservation.endTime}';
  }

  IconData _icon(Reservation reservation) {
    if (reservation.isAccepted) return Icons.check_circle;
    if (reservation.isRejected) return Icons.cancel;
    if (reservation.isCancelled) return Icons.block;
    if (reservation.isFinished) return Icons.flag_circle;
    return Icons.notifications;
  }

  Color _color(Reservation reservation) {
    if (reservation.isAccepted) return Colors.green;
    if (reservation.isRejected) return Colors.red;
    if (reservation.isCancelled) return Colors.grey;
    if (reservation.isFinished) return AppTheme.green;
    return AppTheme.green;
  }

  Widget _notificationCard(Reservation reservation) {
    final color = _color(reservation);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(_icon(reservation), color: color, size: 34),
        title: Text(
          _title(reservation),
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        subtitle: Text(_description(reservation)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notifications = _notifications;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificações'),
        actions: [
          IconButton(
            tooltip: 'Limpar notificações',
            icon: const Icon(Icons.delete_sweep),
            onPressed: _clearNotifications,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _load(),
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
                  const Icon(
                    Icons.notifications,
                    color: Colors.white,
                    size: 44,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Atualizações\ndas reservas',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontSize: 30,
                      height: 1.05,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${notifications.length} notificações encontradas',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
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
                  child: Text(_error!, textAlign: TextAlign.center),
                ),
              )
            else if (notifications.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(22),
                  child: Text(
                    'Nenhuma notificação encontrada.',
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else
              ...notifications.map(_notificationCard),
          ],
        ),
      ),
    );
  }
}
