import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/config/app_config.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/reservation.dart';
import '../../data/services/api_service.dart';
import '../widgets/hubarena_header.dart';
import '../widgets/stat_card.dart';
import '../widgets/sync_info_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ApiService _apiService = ApiService();

  List<Reservation> _reservations = [];
  bool _isLoading = true;
  String? _error;
  Timer? _timer;
  DateTime? _lastUpdate;

  @override
  void initState() {
    super.initState();
    _loadDashboard();

    _timer = Timer.periodic(
      AppConfig.pollingInterval,
      (_) => _loadDashboard(silent: true),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadDashboard({bool silent = false}) async {
    if (!silent) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    }

    try {
      final reservations = await _apiService.getReservations();

      if (!mounted) return;

      setState(() {
        _reservations = reservations;
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

  int get _pending => _reservations
      .where((item) => item.status.toUpperCase() == 'PENDING')
      .length;

  int get _accepted => _reservations
      .where((item) => item.status.toUpperCase() == 'ACCEPTED')
      .length;

  int get _rejected => _reservations
      .where((item) => item.status.toUpperCase() == 'REJECTED')
      .length;

  int get _total => _reservations.length;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HubArena Prestador')),
      body: RefreshIndicator(
        onRefresh: () => _loadDashboard(),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            HubArenaHeader(
              label: 'HUBARENA PRO',
              title: 'Painel do\nprestador',
              subtitle:
                  '$_pending solicitações pendentes • atualizado às ${_lastUpdateText()}',
              icon: Icons.sports_soccer,
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_error != null)
              _ErrorCard(message: _error!, onRetry: () => _loadDashboard())
            else ...[
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.45,
                children: [
                  StatCard(
                    title: 'Pendentes',
                    value: '$_pending',
                    icon: Icons.notifications_active,
                    color: Colors.orange,
                  ),
                  StatCard(
                    title: 'Aceitas',
                    value: '$_accepted',
                    icon: Icons.check_circle,
                    color: Colors.green,
                  ),
                  StatCard(
                    title: 'Recusadas',
                    value: '$_rejected',
                    icon: Icons.cancel,
                    color: Colors.red,
                  ),
                  StatCard(
                    title: 'Total',
                    value: '$_total',
                    icon: Icons.analytics,
                    color: AppTheme.green,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                'Resumo operacional',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              SyncInfoCard(
                text:
                    'Atualização automática a cada ${AppConfig.pollingInterval.inSeconds} segundos. O app do prestador acompanha novas solicitações sem atualização manual.',
              ),
              const SizedBox(height: 12),
              const _OperationalCard(
                title: 'Fluxo de atendimento',
                description:
                    'Receba solicitações pendentes, analise os detalhes e aceite ou recuse pelo app do prestador.',
                icon: Icons.route,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _OperationalCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const _OperationalCard({
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: AppTheme.green),
        title: Text(title),
        subtitle: Text(description),
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
            const Icon(Icons.cloud_off, color: Colors.red, size: 48),
            const SizedBox(height: 12),
            Text(
              'Erro ao carregar dashboard',
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
