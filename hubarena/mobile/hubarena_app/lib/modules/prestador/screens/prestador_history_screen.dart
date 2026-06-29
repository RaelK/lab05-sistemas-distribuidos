import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/config/app_config.dart';
import '../../../data/models/reservation.dart';
import '../../../data/services/api_service.dart';
import '../widgets/reservation_card.dart';
import 'reservation_details_screen.dart';

class PrestadorHistoryScreen extends StatefulWidget {
  const PrestadorHistoryScreen({super.key});

  @override
  State<PrestadorHistoryScreen> createState() => _PrestadorHistoryScreenState();
}

class _PrestadorHistoryScreenState extends State<PrestadorHistoryScreen> {
  final ApiService _apiService = ApiService();

  List<Reservation> _reservations = [];
  bool _isLoading = true;
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
    if (!silent) setState(() => _isLoading = true);

    final all = await _apiService.getReservationsByProvider(
      AppConfig.providerId,
    );
    final history =
        all.where((item) => item.isAccepted || item.isRejected).toList()
          ..sort((a, b) => b.id.compareTo(a.id));

    if (!mounted) return;

    setState(() {
      _reservations = history;
      _isLoading = false;
    });
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
          Text(
            'Histórico de solicitações',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 14),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_reservations.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(22),
                child: Text(
                  'Nenhuma solicitação respondida.',
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
