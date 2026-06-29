import 'package:flutter/material.dart';

import '../../../core/config/app_config.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/arena.dart';
import '../../../data/services/api_service.dart';
import 'arena_courts_screen.dart';

class PrestadorArenasScreen extends StatefulWidget {
  const PrestadorArenasScreen({super.key});

  @override
  State<PrestadorArenasScreen> createState() => _PrestadorArenasScreenState();
}

class _PrestadorArenasScreenState extends State<PrestadorArenasScreen> {
  final ApiService _apiService = ApiService();

  List<Arena> _arenas = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadArenas();
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
        _arenas = arenas
            .where((arena) => arena.providerId == AppConfig.providerId)
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

  Future<void> _createArena() async {
    final result = await Navigator.of(
      context,
    ).push<bool>(MaterialPageRoute(builder: (_) => const _ArenaFormScreen()));

    if (result == true) {
      await _loadArenas();
    }
  }

  Future<void> _openArenaCourts(Arena arena) async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => ArenaCourtsScreen(arena: arena)));

    await _loadArenas();
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

  Widget _arenaCard(Arena arena) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _openArenaCourts(arena),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 145,
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
    return RefreshIndicator(
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
                const Icon(Icons.stadium, color: Colors.white, size: 44),
                const SizedBox(height: 16),
                Text(
                  'Minhas\narenas',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontSize: 30,
                    height: 1.05,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${_arenas.length} arenas cadastradas',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _createArena,
            icon: const Icon(Icons.add),
            label: const Text('Cadastrar arena'),
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
          else if (_arenas.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(22),
                child: Text(
                  'Nenhuma arena cadastrada para este prestador.',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            ..._arenas.map(_arenaCard),
        ],
      ),
    );
  }
}

class _ArenaFormScreen extends StatefulWidget {
  const _ArenaFormScreen();

  @override
  State<_ArenaFormScreen> createState() => _ArenaFormScreenState();
}

class _ArenaFormScreenState extends State<_ArenaFormScreen> {
  final ApiService _apiService = ApiService();

  late final TextEditingController _nameController;
  late final TextEditingController _sportController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _addressController;
  late final TextEditingController _imageUrlController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController();
    _sportController = TextEditingController(text: 'Futebol');
    _descriptionController = TextEditingController();
    _addressController = TextEditingController(text: 'Belo Horizonte, MG');
    _imageUrlController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _sportController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() {
      _isSaving = true;
    });

    try {
      await _apiService.createArena(
        providerId: AppConfig.providerId,
        name: _nameController.text.trim(),
        sport: _sportController.text.trim(),
        description: _descriptionController.text.trim(),
        address: _addressController.text.trim(),
        imageUrl: _imageUrlController.text.trim().isEmpty
            ? null
            : _imageUrlController.text.trim(),
      );

      if (!mounted) return;

      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppTheme.green),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar arena')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _field(
            controller: _nameController,
            label: 'Nome da arena',
            icon: Icons.stadium,
          ),
          const SizedBox(height: 14),
          _field(
            controller: _sportController,
            label: 'Esporte principal',
            icon: Icons.sports_soccer,
          ),
          const SizedBox(height: 14),
          _field(
            controller: _addressController,
            label: 'Endereço',
            icon: Icons.location_on,
          ),
          const SizedBox(height: 14),
          _field(
            controller: _descriptionController,
            label: 'Descrição',
            icon: Icons.description,
            maxLines: 3,
          ),
          const SizedBox(height: 14),
          _field(
            controller: _imageUrlController,
            label: 'URL da imagem (opcional)',
            icon: Icons.image,
          ),
          const SizedBox(height: 12),
          const Text(
            'Se a URL da imagem ficar vazia, o backend selecionará automaticamente uma imagem padrão de acordo com o esporte.',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _isSaving ? null : _save,
            icon: const Icon(Icons.save),
            label: const Text('Criar arena'),
          ),
        ],
      ),
    );
  }
}
