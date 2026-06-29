import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/user.dart';
import '../../../data/services/api_service.dart';

class EditProfileScreen extends StatefulWidget {
  final int userId;
  final String title;

  const EditProfileScreen({
    super.key,
    required this.userId,
    required this.title,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final ApiService _apiService = ApiService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _profileTypeController = TextEditingController();
  final TextEditingController _photoUrlController = TextEditingController();

  final TextEditingController _currentPasswordController =
      TextEditingController(text: '123456');
  final TextEditingController _newPasswordController = TextEditingController(
    text: '123456',
  );

  User? _user;
  bool _isLoading = true;
  bool _isSaving = false;
  String? _error;

  bool get _isClientProfile => widget.title.toLowerCase().contains('cliente');

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _profileTypeController.dispose();
    _photoUrlController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  Future<void> _loadUser() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final user = await _apiService.getUser(widget.userId);

      if (!mounted) return;

      setState(() {
        _user = user;
        _nameController.text = user.name;
        _emailController.text = user.email;
        _profileTypeController.text = user.profileType ?? user.role;
        _photoUrlController.text = user.profilePhotoUrl ?? '';
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

  Future<void> _saveProfile() async {
    setState(() {
      _isSaving = true;
    });

    try {
      final user = await _apiService.updateUser(
        userId: widget.userId,
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        profileType: _isClientProfile
            ? 'CONSUMIDOR'
            : _profileTypeController.text.trim(),
      );

      if (!mounted) return;

      setState(() {
        _user = user;
      });

      _showSuccess('Perfil atualizado com sucesso.');
    } catch (error) {
      if (!mounted) return;
      _showError(error.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _updatePhoto() async {
    final url = _photoUrlController.text.trim();

    if (url.isEmpty) {
      _showError('Informe a URL da foto.');
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final user = await _apiService.updateProfilePhoto(
        userId: widget.userId,
        profilePhotoUrl: url,
      );

      if (!mounted) return;

      setState(() {
        _user = user;
      });

      _showSuccess('Foto atualizada com sucesso.');
    } catch (error) {
      if (!mounted) return;
      _showError(error.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _deletePhoto() async {
    setState(() {
      _isSaving = true;
    });

    try {
      final user = await _apiService.deleteProfilePhoto(widget.userId);

      if (!mounted) return;

      setState(() {
        _user = user;
        _photoUrlController.clear();
      });

      _showSuccess('Foto removida com sucesso.');
    } catch (error) {
      if (!mounted) return;
      _showError(error.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _changePassword() async {
    setState(() {
      _isSaving = true;
    });

    try {
      await _apiService.updatePassword(
        userId: widget.userId,
        currentPassword: _currentPasswordController.text.trim(),
        newPassword: _newPasswordController.text.trim(),
      );

      if (!mounted) return;

      _showSuccess('Senha alterada com sucesso.');
    } catch (error) {
      if (!mounted) return;
      _showError(error.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  ImageProvider? _avatarImage() {
    final user = _user;
    final url = user?.profilePhotoUrl;

    if (url == null || url.isEmpty) {
      return null;
    }

    return NetworkImage(url);
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
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
    final user = _user;

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text(_error!))
          : ListView(
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
                    children: [
                      CircleAvatar(
                        radius: 44,
                        backgroundColor: Colors.white,
                        backgroundImage: _avatarImage(),
                        child: _avatarImage() == null
                            ? const Icon(
                                Icons.person,
                                color: AppTheme.green,
                                size: 44,
                              )
                            : null,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        user?.name ?? 'Usuário',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        user?.email ?? '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                _field(
                  controller: _nameController,
                  label: 'Nome',
                  icon: Icons.person,
                ),
                const SizedBox(height: 14),
                _field(
                  controller: _emailController,
                  label: 'E-mail',
                  icon: Icons.email,
                ),
                const SizedBox(height: 14),
                _field(
                  controller: _profileTypeController,
                  label: 'Tipo de perfil',
                  icon: Icons.badge,
                ),
                const SizedBox(height: 14),
                ElevatedButton.icon(
                  onPressed: _isSaving ? null : _saveProfile,
                  icon: const Icon(Icons.save),
                  label: const Text('Salvar perfil'),
                ),
                const SizedBox(height: 22),
                Text(
                  'Foto de perfil',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                _field(
                  controller: _photoUrlController,
                  label: 'URL da foto',
                  icon: Icons.link,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isSaving ? null : _updatePhoto,
                        icon: const Icon(Icons.photo_camera),
                        label: const Text('Atualizar'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _isSaving ? null : _deletePhoto,
                        icon: const Icon(Icons.delete),
                        label: const Text('Excluir'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                Text(
                  'Alterar senha',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                _field(
                  controller: _currentPasswordController,
                  label: 'Senha atual',
                  icon: Icons.lock,
                  obscureText: true,
                ),
                const SizedBox(height: 14),
                _field(
                  controller: _newPasswordController,
                  label: 'Nova senha',
                  icon: Icons.lock_reset,
                  obscureText: true,
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: _isSaving ? null : _changePassword,
                  icon: const Icon(Icons.lock_reset),
                  label: const Text('Alterar senha'),
                ),
              ],
            ),
    );
  }
}
