import 'package:flutter/material.dart';

import '../../../core/config/app_config.dart';
import '../../../core/theme/app_theme.dart';
import 'minhas_reservas_screen.dart';
import '../../profile/screens/edit_profile_screen.dart';

class ClienteProfileScreen extends StatelessWidget {
  const ClienteProfileScreen({super.key});

  void _openEditProfile(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const EditProfileScreen(
          userId: AppConfig.clientId,
          title: 'Editar Perfil Cliente',
        ),
      ),
    );
  }

  void _openReservations(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const MinhasReservasScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
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
              const CircleAvatar(
                radius: 38,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: AppTheme.green, size: 42),
              ),
              const SizedBox(height: 16),
              Text(
                'Cliente HubArena',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Cliente ID ${AppConfig.clientId}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        _ProfileOption(
          icon: Icons.edit,
          title: 'Editar perfil',
          subtitle: 'Nome, e-mail, tipo, foto e senha',
          onTap: () => _openEditProfile(context),
        ),

        _ProfileOption(
          icon: Icons.list_alt,
          title: 'Minhas reservas',
          subtitle: 'Acompanhar solicitações',
          onTap: () => _openReservations(context),
        ),
        _ProfileOption(
          icon: Icons.logout,
          title: 'Sair do app',
          subtitle: 'Voltar para escolha de perfil',
          onTap: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

class _ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ProfileOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.green),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
