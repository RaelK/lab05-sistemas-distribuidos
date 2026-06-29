import 'package:flutter/material.dart';

import 'prestador_active_screen.dart';
import 'prestador_arenas_screen.dart';
import 'prestador_dashboard_screen.dart';
import 'prestador_history_screen.dart';
import 'prestador_notifications_screen.dart';
import 'prestador_pending_screen.dart';
import 'prestador_profile_screen.dart';

class PrestadorHomeScreen extends StatefulWidget {
  const PrestadorHomeScreen({super.key});

  @override
  State<PrestadorHomeScreen> createState() => _PrestadorHomeScreenState();
}

class _PrestadorHomeScreenState extends State<PrestadorHomeScreen> {
  int _index = 0;

  void _goToTab(int index) {
    setState(() {
      _index = index;
    });
  }

  late final List<Widget> _screens = [
    const PrestadorDashboardScreen(),
    const PrestadorPendingScreen(),
    const PrestadorActiveScreen(),
    const PrestadorArenasScreen(),
    const PrestadorNotificationsScreen(),
    PrestadorProfileScreen(onNavigate: _goToTab),
    const PrestadorHistoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HubArena Prestador')),
      body: _screens[_index],
      bottomNavigationBar: NavigationBar(
        height: 74,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        selectedIndex: _index,
        onDestinationSelected: _goToTab,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard), label: 'Painel'),
          NavigationDestination(
            icon: Icon(Icons.notifications_active),
            label: 'Solic.',
          ),
          NavigationDestination(icon: Icon(Icons.sports), label: 'Reservas'),
          NavigationDestination(icon: Icon(Icons.stadium), label: 'Arenas'),
          NavigationDestination(
            icon: Icon(Icons.notifications),
            label: 'Avisos',
          ),
          NavigationDestination(icon: Icon(Icons.person), label: 'Perfil'),
          NavigationDestination(icon: Icon(Icons.history), label: 'Hist.'),
        ],
      ),
    );
  }
}
