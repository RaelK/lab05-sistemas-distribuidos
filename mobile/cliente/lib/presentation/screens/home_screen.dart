import 'package:flutter/material.dart';

import '../../core/config/app_config.dart';
import '../../core/theme/app_theme.dart';
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
        title: const Text('🏟 HubArena'),
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
              padding: const EdgeInsets.all(16),
              children: [
                _HeroBanner(courtsCount: data.courts.length),
                const SizedBox(height: 16),
                const _SportIconsRow(),
                const SizedBox(height: 16),
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
                const SizedBox(height: 22),
                Row(
                  children: [
                    const Icon(
                      Icons.sports_score,
                      color: AppTheme.primaryGreen,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Quadras disponíveis',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
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

class _HeroBanner extends StatelessWidget {
  final int courtsCount;

  const _HeroBanner({required this.courtsCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppTheme.darkGreen,
            AppTheme.primaryGreen,
            Color(0xFF0E8F47),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -14,
            top: -18,
            child: Icon(
              Icons.sports_soccer,
              size: 128,
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '🏟 HUBARENA',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  letterSpacing: 1.4,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Reserve sua\nquadra esportiva',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontSize: 28,
                  height: 1.05,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Cliente ID ${AppConfig.clientId} • $courtsCount quadras disponíveis',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SportIconsRow extends StatelessWidget {
  const _SportIconsRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _SportIconCard(icon: Icons.sports_soccer, label: 'Futebol'),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _SportIconCard(
            icon: Icons.sports_basketball,
            label: 'Basquete',
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _SportIconCard(icon: Icons.sports_tennis, label: 'Tênis'),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _SportIconCard(icon: Icons.sports_volleyball, label: 'Vôlei'),
        ),
      ],
    );
  }
}

class _SportIconCard extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SportIconCard({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 13),
        child: Column(
          children: [
            Icon(icon, color: AppTheme.primaryGreen, size: 28),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
            ),
          ],
        ),
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
