import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/config/app_config.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/reservation.dart';
import '../../../data/services/api_service.dart';
import '../widgets/reservation_card.dart';
import 'reservation_details_screen.dart';

class PrestadorPendingScreen extends StatefulWidget {
  const PrestadorPendingScreen({super.key});

  @override
  State<PrestadorPendingScreen> createState() => _PrestadorPendingScreenState();
}

class _PrestadorPendingScreenState extends State<PrestadorPendingScreen> {
  final ApiService _apiService = ApiService();

  List<Reservation> _reservations = [];
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
      final all = await _apiService.getReservationsByProvider(
        AppConfig.providerId,
      );
      final pending = all.where((item) => item.isPending).toList()
        ..sort((a, b) => b.id.compareTo(a.id));

      if (!mounted) return;

      setState(() {
        _reservations = pending;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _error = error.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _openDetails(Reservation reservation) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ReservationDetailsScreen(reservation: reservation),
      ),
    );

    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
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
                  Icons.notifications_active,
                  color: Colors.white,
                  size: 44,
                ),
                const SizedBox(height: 16),
                Text(
                  'Solicitações\npendentes',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontSize: 30,
                    height: 1.05,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${_reservations.length} reservas aguardando resposta',
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
          else if (_reservations.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(22),
                child: Text(
                  'Nenhuma solicitação pendente.',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            ..._reservations.map(
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
