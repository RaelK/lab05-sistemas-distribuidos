import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  Color get _color {
    switch (status.toUpperCase()) {
      case 'ACCEPTED':
        return const Color(0xFF0B7A3B);
      case 'REJECTED':
        return const Color(0xFFB3261E);
      case 'PENDING':
      default:
        return const Color(0xFFE69500);
    }
  }

  String get _label {
    switch (status.toUpperCase()) {
      case 'ACCEPTED':
        return 'ACEITA';
      case 'REJECTED':
        return 'RECUSADA';
      case 'PENDING':
      default:
        return 'PENDENTE';
    }
  }

  IconData get _icon {
    switch (status.toUpperCase()) {
      case 'ACCEPTED':
        return Icons.check_circle;
      case 'REJECTED':
        return Icons.cancel;
      case 'PENDING':
      default:
        return Icons.schedule;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(_icon, color: Colors.white, size: 18),
      label: Text(
        _label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: _color,
    );
  }
}
