import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/arena.dart';
import '../../../data/models/court.dart';
import '../../../data/services/api_service.dart';
import 'create_reservation_screen.dart';

class ClienteArenaCourtsScreen extends StatefulWidget {
  final Arena arena;

  const ClienteArenaCourtsScreen({super.key, required this.arena});

  @override
  State<ClienteArenaCourtsScreen> createState() =>
      _ClienteArenaCourtsScreenState();
}

class _ClienteArenaCourtsScreenState extends State<ClienteArenaCourtsScreen> {
  final ApiService _apiService = ApiService();

  List<Court> _courts = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCourts();
  }

  Future<void> _loadCourts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final courts = await _apiService.getCourts();

      if (!mounted) return;

      setState(() {
        _courts = courts
            .where((court) => court.arenaId == widget.arena.id)
            .toList();
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

  Future<void> _openCreateReservation(Court court) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => CreateReservationScreen(court: court)),
    );
  }

  Widget _courtImage(Court court) {
    final url = court.imageUrl;

    if (url == null || url.isEmpty) {
      return const ColoredBox(
        color: Color(0xFFEAF7EF),
        child: Center(
          child: Icon(Icons.sports_soccer, color: AppTheme.green, size: 46),
        ),
      );
    }

    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) {
        return const ColoredBox(
          color: Color(0xFFEAF7EF),
          child: Center(
            child: Icon(Icons.sports_soccer, color: AppTheme.green, size: 46),
          ),
        );
      },
    );
  }

  Widget _courtCard(Court court) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _openCreateReservation(court),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 135,
              width: double.infinity,
              child: _courtImage(court),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    court.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    court.sport,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Capacidade: ${court.capacity} • R\$ ${court.priceHour.toStringAsFixed(2)} / hora',
                  ),
                  if (court.description != null &&
                      court.description!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      court.description!,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
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

  Widget _arenaImage() {
    final url = widget.arena.imageUrl;

    if (url == null || url.isEmpty) {
      return const ColoredBox(
        color: Color(0xFFEAF7EF),
        child: Center(
          child: Icon(Icons.stadium, color: AppTheme.green, size: 46),
        ),
      );
    }

    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) {
        return const ColoredBox(
          color: Color(0xFFEAF7EF),
          child: Center(
            child: Icon(Icons.stadium, color: AppTheme.green, size: 46),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final arena = widget.arena;

    return Scaffold(
      appBar: AppBar(title: Text(arena.name)),
      body: RefreshIndicator(
        onRefresh: _loadCourts,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 170,
                    width: double.infinity,
                    child: _arenaImage(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          arena.name,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          arena.sport ?? 'Esporte não informado',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 6),
                        Text(arena.address),
                        if (arena.description != null &&
                            arena.description!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            arena.description!,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Quadras disponíveis',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
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
            else if (_courts.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(22),
                  child: Text(
                    'Nenhuma quadra disponível nesta arena.',
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else
              ..._courts.map(_courtCard),
          ],
        ),
      ),
    );
  }
}
