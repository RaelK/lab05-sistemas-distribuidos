import 'package:flutter/material.dart';

import '../../core/config/app_config.dart';
import '../../data/models/arena.dart';
import '../../data/models/court.dart';
import '../../data/services/api_service.dart';
import '../widgets/court_card.dart';
import 'court_details_screen.dart';
import 'reservations_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();

  late Future<_HomeData> _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = _loadData();
  }

  Future<_HomeData> _loadData() async {
    final results = await Future.wait([
      _apiService.getArenas(),
      _apiService.getCourts(),
    ]);

    return _HomeData(
      arenas: results[0] as List<Arena>,
      courts: results[1] as List<Court>,
    );
  }

  Future<void> _refresh() async {
    setState(() {
      _futureData = _loadData();
    });

    await _futureData;
  }

  String _arenaNameForCourt(Court court, List<Arena> arenas) {
    final arena = arenas.where((item) => item.id == court.arenaId).firstOrNull;
    return arena?.name ?? 'Arena não identificada';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HubArena Cliente'),
        actions: [
          IconButton(
            tooltip: 'Minhas reservas',
            icon: const Icon(Icons.event_available),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ReservationsScreen()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<_HomeData>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return _ErrorState(
              message: snapshot.error.toString(),
              onRetry: _refresh,
            );
          }

          final data = snapshot.data!;

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              padding: const EdgeInsets.all(18),
              children: [
                _SportHeader(courtsCount: data.courts.length),
                const SizedBox(height: 18),
                FilledButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ReservationsScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.notifications_active),
                  label: const Text('Acompanhar minhas reservas'),
                ),
                const SizedBox(height: 18),
                Text(
                  'Quadras disponíveis',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 12),
                if (data.courts.isEmpty)
                  const _EmptyState()
                else
                  ...data.courts.map(
                    (court) => CourtCard(
                      court: court,
                      arenaName: _arenaNameForCourt(court, data.arenas),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => CourtDetailsScreen(
                              court: court,
                              arenaName: _arenaNameForCourt(court, data.arenas),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _HomeData {
  final List<Arena> arenas;
  final List<Court> courts;

  _HomeData({required this.arenas, required this.courts});
}

class _SportHeader extends StatelessWidget {
  final int courtsCount;

  const _SportHeader({required this.courtsCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF063B1E), Color(0xFF0B7A3B)],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.sports_soccer, color: Colors.white, size: 44),
          const SizedBox(height: 14),
          Text(
            'Reserve sua quadra esportiva',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Cliente ID ${AppConfig.clientId} • $courtsCount quadras carregadas',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 58, color: Colors.red),
            const SizedBox(height: 12),
            Text(
              'Não foi possível carregar os dados.',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
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

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(22),
        child: Text(
          'Nenhuma quadra cadastrada. Cadastre dados pelo Postman para testar o app.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
