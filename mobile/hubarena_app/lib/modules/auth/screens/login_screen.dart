import 'package:flutter/material.dart';

import 'register_screen.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/user.dart';
import '../../../data/services/api_service.dart';
import '../../cliente/screens/cliente_shell_screen.dart';
import '../../prestador/screens/prestador_home_screen.dart';

class LoginScreen extends StatefulWidget {
  final String role;

  const LoginScreen({super.key, required this.role});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final ApiService _apiService = ApiService();

  late final TextEditingController _emailController;
  final TextEditingController _passwordController = TextEditingController(
    text: '123456',
  );

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController(
      text: widget.role == 'CLIENT'
          ? 'cliente@hubarena.com'
          : 'prestador@hubarena.com',
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = await _apiService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;

      if (widget.role == 'CLIENT' && !user.isClient) {
        _showError('Este usuário não possui perfil de cliente.');
        return;
      }

      if (widget.role == 'PROVIDER' && !user.isProvider) {
        _showError('Este usuário não possui perfil de prestador.');
        return;
      }

      _openHome(user);
    } catch (error) {
      if (!mounted) return;

      _showError(error.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _openHome(User user) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) {
          if (user.isClient) {
            return const ClienteShellScreen();
          }

          return const PrestadorHomeScreen();
        },
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );

    setState(() {
      _isLoading = false;
    });
  }

  String get _title {
    return widget.role == 'CLIENT' ? 'Login Cliente' : 'Login Prestador';
  }

  String get _subtitle {
    return widget.role == 'CLIENT'
        ? 'Acesse para reservar quadras e acompanhar solicitações.'
        : 'Acesse para gerenciar reservas recebidas.';
  }

  IconData get _icon {
    return widget.role == 'CLIENT'
        ? Icons.sports_soccer
        : Icons.admin_panel_settings;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: Text(_title)),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
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
                Icon(_icon, color: Colors.white, size: 52),
                const SizedBox(height: 18),
                Text(
                  _title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _subtitle,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'E-mail',
              prefixIcon: const Icon(Icons.email),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Senha',
              prefixIcon: const Icon(Icons.lock),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _isLoading ? null : _login,
            icon: _isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.login),
            label: const Text('Entrar'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => RegisterScreen(role: widget.role),
                ),
              );
            },
            icon: const Icon(Icons.person_add),
            label: const Text('Criar conta'),
          ),
        ],
      ),
    );
  }
}
