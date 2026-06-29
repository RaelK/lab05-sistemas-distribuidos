import 'package:flutter/material.dart';

import 'cliente_home_screen.dart';
import 'cliente_notifications_screen.dart';
import 'cliente_profile_screen.dart';
import 'minhas_reservas_screen.dart';

class ClienteShellScreen extends StatefulWidget {
  const ClienteShellScreen({super.key});

  @override
  State<ClienteShellScreen> createState() => _ClienteShellScreenState();
}

class _ClienteShellScreenState extends State<ClienteShellScreen> {
  int _index = 0;

  final List<Widget> _screens = const [
    ClienteHomeScreen(),
    MinhasReservasScreen(),
    ClienteNotificationsScreen(),
    ClienteProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) {
          setState(() {
            _index = value;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Início'),
          NavigationDestination(
            icon: Icon(Icons.calendar_month),
            label: 'Reservas',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications),
            label: 'Avisos',
          ),
          NavigationDestination(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
