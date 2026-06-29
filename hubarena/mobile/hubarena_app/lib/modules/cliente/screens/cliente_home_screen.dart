import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/arena.dart';
import '../../../data/services/api_service.dart';
import 'cliente_arena_courts_screen.dart';
import 'minhas_reservas_screen.dart';

class ClienteHomeScreen extends StatefulWidget {
  const ClienteHomeScreen({super.key});

  @override
  State<ClienteHomeScreen> createState() => _ClienteHomeScreenState();
}

class _ClienteHomeScreenState extends State<ClienteHomeScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();

  final List<_SportFilter> _filters = const [
    _SportFilter(label: 'Todos', emoji: '🌐', value: ''),
    _SportFilter(label: 'Futebol', emoji: '⚽', value: 'futebol'),
    _SportFilter(label: 'Basquete', emoji: '🏀', value: 'basquete'),
    _SportFilter(label: 'Tênis', emoji: '🎾', value: 'tenis'),
    _SportFilter(label: 'Vôlei', emoji: '🏐', value: 'volei'),
    _SportFilter(label: 'Beach Tennis', emoji: '🏖️', value: 'beach tennis'),
    _SportFilter(label: 'Natação', emoji: '🏊', value: 'natacao'),
  ];

  List<Arena> _arenas = [];
  String _selectedSport = '';
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadArenas();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadArenas() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final arenas = await _apiService.getArenas();

      if (!mounted) return;

      setState(() {
        _arenas = arenas;
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

  void _openArena(Arena arena) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ClienteArenaCourtsScreen(arena: arena)),
    );
  }

  void _openMyReservations() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const MinhasReservasScreen()));
  }

  String _normalize(String value) {
    return value
        .toLowerCase()
        .replaceAll('á', 'a')
        .replaceAll('à', 'a')
        .replaceAll('ã', 'a')
        .replaceAll('â', 'a')
        .replaceAll('é', 'e')
        .replaceAll('ê', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ô', 'o')
        .replaceAll('õ', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ç', 'c');
  }

  List<Arena> get _filteredArenas {
    final query = _normalize(_searchController.text.trim());
    final sport = _normalize(_selectedSport);

    return _arenas.where((arena) {
      final arenaSport = _normalize(arena.sport ?? '');
      final searchable = _normalize(
        '${arena.name} ${arena.sport ?? ''} ${arena.address} ${arena.description ?? ''}',
      );

      final matchesSport = sport.isEmpty || arenaSport.contains(sport);
      final matchesQuery = query.isEmpty || searchable.contains(query);

      return matchesSport && matchesQuery;
    }).toList();
  }

  Widget _arenaImage(Arena arena) {
    final url = arena.imageUrl;

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

  Widget _filterChip(_SportFilter filter) {
    final selected = _selectedSport == filter.value;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        selected: selected,
        label: Text('${filter.emoji} ${filter.label}'),
        onSelected: (_) {
          setState(() {
            _selectedSport = filter.value;
          });
        },
      ),
    );
  }

  Widget _arenaCard(Arena arena) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _openArena(arena),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 150,
              width: double.infinity,
              child: _arenaImage(arena),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    arena.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final arenas = _filteredArenas;

    return Scaffold(
      appBar: AppBar(
        title: const Text('HubArena Cliente'),
        actions: [
          IconButton(
            tooltip: 'Minhas Reservas',
            icon: const Icon(Icons.list_alt),
            onPressed: _openMyReservations,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadArenas,
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
                  const Icon(Icons.stadium, color: Colors.white, size: 46),
                  const SizedBox(height: 16),
                  Text(
                    'Encontre sua\narena ideal',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontSize: 30,
                      height: 1.05,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Escolha uma arena, veja as quadras disponíveis e faça sua reserva.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Buscar esporte, arena ou quadra',
                prefixIcon: const Icon(Icons.search, color: AppTheme.green),
                suffixIcon: _searchController.text.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                          });
                        },
                        icon: const Icon(Icons.close),
                      ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _filters.map(_filterChip).toList(),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Arenas disponíveis (${arenas.length})',
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
                  child: Column(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red),
                      const SizedBox(height: 8),
                      Text(_error!, textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: _loadArenas,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Tentar novamente'),
                      ),
                    ],
                  ),
                ),
              )
            else if (arenas.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(22),
                  child: Text(
                    'Nenhuma arena encontrada para os filtros selecionados.',
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else
              ...arenas.map(_arenaCard),
          ],
        ),
      ),
    );
  }
}

class _SportFilter {
  final String label;
  final String emoji;
  final String value;

  const _SportFilter({
    required this.label,
    required this.emoji,
    required this.value,
  });
}
