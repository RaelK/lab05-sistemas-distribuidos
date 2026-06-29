import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/config/app_config.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/reservation.dart';
import '../../../data/services/api_service.dart';

class PrestadorDashboardScreen extends StatefulWidget {
  const PrestadorDashboardScreen({super.key});

  @override
  State<PrestadorDashboardScreen> createState() =>
      _PrestadorDashboardScreenState();
}

class _PrestadorDashboardScreenState extends State<PrestadorDashboardScreen> {
  final ApiService _apiService = ApiService();

  List<Reservation> _reservations = [];
  bool _isLoading = true;
  String? _error;
  Timer? _timer;
  DateTime? _lastUpdate;

  @override
  void initState() {
    super.initState();
    _loadData();
    _timer = Timer.periodic(
      AppConfig.pollingInterval,
      (_) => _loadData(silent: true),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadData({bool silent = false}) async {
    if (!silent) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    }

    try {
      final reservations = await _apiService.getReservationsByProvider(
        AppConfig.providerId,
      );

      if (!mounted) return;

      setState(() {
        _reservations = reservations;
        _lastUpdate = DateTime.now();
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

  int get _pending => _reservations.where((item) => item.isPending).length;
  int get _accepted => _reservations.where((item) => item.isAccepted).length;
  int get _rejected => _reservations.where((item) => item.isRejected).length;
  int get _total => _reservations.length;

  String _lastUpdateText() {
    final update = _lastUpdate;
    if (update == null) return 'Aguardando atualização';

    final h = update.hour.toString().padLeft(2, '0');
    final m = update.minute.toString().padLeft(2, '0');
    final s = update.second.toString().padLeft(2, '0');

    return '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _loadData(),
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
                const Icon(Icons.sports_score, color: Colors.white, size: 44),
                const SizedBox(height: 16),
                Text(
                  'Painel do\nprestador',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontSize: 30,
                    height: 1.05,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '$_pending pendentes • atualizado às ${_lastUpdateText()}',
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
          else
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.45,
              children: [
                _MetricCard(
                  label: 'Pendentes',
                  value: '$_pending',
                  icon: Icons.notifications_active,
                  color: Colors.orange,
                ),
                _MetricCard(
                  label: 'Aceitas',
                  value: '$_accepted',
                  icon: Icons.check_circle,
                  color: Colors.green,
                ),
                _MetricCard(
                  label: 'Recusadas',
                  value: '$_rejected',
                  icon: Icons.cancel,
                  color: Colors.red,
                ),
                _MetricCard(
                  label: 'Total',
                  value: '$_total',
                  icon: Icons.analytics,
                  color: AppTheme.green,
                ),
              ],
            ),
          const SizedBox(height: 18),
          Card(
            color: const Color(0xFFEAF7EF),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'O prestador recebe novas solicitações automaticamente a cada ${AppConfig.pollingInterval.inSeconds} segundos.',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const Spacer(),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
            ),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }
}
