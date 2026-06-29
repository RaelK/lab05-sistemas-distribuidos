import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/arena.dart';
import '../../../data/models/court.dart';
import '../../../data/services/api_service.dart';

class ArenaCourtsScreen extends StatefulWidget {
  final Arena arena;

  const ArenaCourtsScreen({super.key, required this.arena});

  @override
  State<ArenaCourtsScreen> createState() => _ArenaCourtsScreenState();
}

class _ArenaCourtsScreenState extends State<ArenaCourtsScreen> {
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

  Future<void> _deleteArena() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir arena'),
        content: const Text(
          'Deseja realmente excluir esta arena? As quadras vinculadas também serão removidas.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await _apiService.deleteArena(widget.arena.id);

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
    }
  }

  Future<void> _editArena() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => _ArenaEditScreen(arena: widget.arena)),
    );

    if (!mounted) return;

    if (result == true) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _createCourt() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => _CourtFormScreen(arena: widget.arena)),
    );

    if (result == true) {
      await _loadCourts();
    }
  }

  Future<void> _editCourt(Court court) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => _CourtFormScreen(arena: widget.arena, court: court),
      ),
    );

    if (result == true) {
      await _loadCourts();
    }
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
        onTap: () => _editCourt(court),
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

  @override
  Widget build(BuildContext context) {
    final arena = widget.arena;

    return Scaffold(
      appBar: AppBar(title: const Text('Quadras da Arena')),
      body: RefreshIndicator(
        onRefresh: _loadCourts,
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
                    arena.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontSize: 28,
                      height: 1.05,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${_courts.length} quadras cadastradas',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            OutlinedButton.icon(
              onPressed: _editArena,
              icon: const Icon(Icons.edit),
              label: const Text('Editar arena'),
            ),
            const SizedBox(height: 10),

            OutlinedButton.icon(
              onPressed: _deleteArena,
              icon: const Icon(Icons.delete),
              label: const Text('Excluir arena'),
            ),
            const SizedBox(height: 10),

            ElevatedButton.icon(
              onPressed: _createCourt,
              icon: const Icon(Icons.add),
              label: const Text('Cadastrar quadra'),
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
            else if (_courts.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(22),
                  child: Text(
                    'Nenhuma quadra cadastrada para esta arena.',
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

class _CourtFormScreen extends StatefulWidget {
  final Arena arena;
  final Court? court;

  const _CourtFormScreen({required this.arena, this.court});

  @override
  State<_CourtFormScreen> createState() => _CourtFormScreenState();
}

class _CourtFormScreenState extends State<_CourtFormScreen> {
  final ApiService _apiService = ApiService();

  late final TextEditingController _nameController;
  late final TextEditingController _sportController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _capacityController;
  late final TextEditingController _imageUrlController;

  bool _available = true;
  bool _isSaving = false;

  bool get _isEditing => widget.court != null;

  @override
  void initState() {
    super.initState();

    final court = widget.court;

    _nameController = TextEditingController(text: court?.name ?? '');
    _sportController = TextEditingController(
      text: court?.sport ?? widget.arena.sport ?? 'Futebol',
    );
    _descriptionController = TextEditingController(
      text: court?.description ?? '',
    );
    _priceController = TextEditingController(
      text: court?.priceHour.toStringAsFixed(2) ?? '100.00',
    );
    _capacityController = TextEditingController(
      text: court?.capacity.toString() ?? '10',
    );
    _imageUrlController = TextEditingController(text: court?.imageUrl ?? '');
    _available = court?.available ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _sportController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _capacityController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() {
      _isSaving = true;
    });

    try {
      final price =
          double.tryParse(_priceController.text.replaceAll(',', '.')) ?? 0.0;
      final capacity = int.tryParse(_capacityController.text) ?? 0;
      final imageUrl = _imageUrlController.text.trim().isEmpty
          ? null
          : _imageUrlController.text.trim();

      if (_isEditing) {
        await _apiService.updateCourt(
          courtId: widget.court!.id,
          name: _nameController.text.trim(),
          sport: _sportController.text.trim(),
          description: _descriptionController.text.trim(),
          priceHour: price,
          capacity: capacity,
          available: _available,
          imageUrl: imageUrl,
        );
      } else {
        await _apiService.createCourt(
          arenaId: widget.arena.id,
          name: _nameController.text.trim(),
          sport: _sportController.text.trim(),
          description: _descriptionController.text.trim(),
          priceHour: price,
          capacity: capacity,
          available: _available,
          imageUrl: imageUrl,
        );
      }

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

  Future<void> _deleteCourt() async {
    if (!_isEditing) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir quadra'),
        content: const Text('Deseja realmente excluir esta quadra?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await _apiService.deleteCourt(widget.court!.id);

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
    }
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
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
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar quadra' : 'Cadastrar quadra'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _field(
            controller: _nameController,
            label: 'Nome da quadra',
            icon: Icons.sports,
          ),
          const SizedBox(height: 14),
          _field(
            controller: _sportController,
            label: 'Esporte',
            icon: Icons.sports_soccer,
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
            controller: _priceController,
            label: 'Preço por hora',
            icon: Icons.payments,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 14),
          _field(
            controller: _capacityController,
            label: 'Capacidade',
            icon: Icons.groups,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 14),
          _field(
            controller: _imageUrlController,
            label: 'URL da imagem (opcional)',
            icon: Icons.image,
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            value: _available,
            onChanged: (value) {
              setState(() {
                _available = value;
              });
            },
            title: const Text('Quadra disponível'),
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
            label: Text(_isEditing ? 'Salvar alterações' : 'Criar quadra'),
          ),

          if (_isEditing) ...[
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _isSaving ? null : _deleteCourt,
              icon: const Icon(Icons.delete),
              label: const Text('Excluir quadra'),
            ),
          ],
        ],
      ),
    );
  }
}

class _ArenaEditScreen extends StatefulWidget {
  final Arena arena;

  const _ArenaEditScreen({required this.arena});

  @override
  State<_ArenaEditScreen> createState() => _ArenaEditScreenState();
}

class _ArenaEditScreenState extends State<_ArenaEditScreen> {
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

    final arena = widget.arena;

    _nameController = TextEditingController(text: arena.name);
    _sportController = TextEditingController(text: arena.sport ?? 'Futebol');
    _descriptionController = TextEditingController(
      text: arena.description ?? '',
    );
    _addressController = TextEditingController(text: arena.address);
    _imageUrlController = TextEditingController(text: arena.imageUrl ?? '');
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
      await _apiService.updateArena(
        arenaId: widget.arena.id,
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
      appBar: AppBar(title: const Text('Editar arena')),
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
            'Se alterar o esporte e deixar a URL vazia, o backend selecionará automaticamente uma imagem padrão do novo esporte.',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _isSaving ? null : _save,
            icon: const Icon(Icons.save),
            label: const Text('Salvar alterações'),
          ),
        ],
      ),
    );
  }
}
