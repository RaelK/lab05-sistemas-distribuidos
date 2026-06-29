import 'package:flutter/material.dart';

import '../../../core/config/app_config.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/court.dart';
import '../../../data/services/api_service.dart';

class CreateReservationScreen extends StatefulWidget {
  final Court court;

  const CreateReservationScreen({super.key, required this.court});

  @override
  State<CreateReservationScreen> createState() =>
      _CreateReservationScreenState();
}

class _CreateReservationScreenState extends State<CreateReservationScreen> {
  final ApiService _apiService = ApiService();

  final TextEditingController _dateController = TextEditingController(
    text: '2026-07-20',
  );
  final TextEditingController _startTimeController = TextEditingController(
    text: '20:00',
  );
  final TextEditingController _endTimeController = TextEditingController(
    text: '21:00',
  );

  bool _isSubmitting = false;

  @override
  void dispose() {
    _dateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      final reservation = await _apiService.createReservation(
        clientId: AppConfig.clientId,
        courtId: widget.court.id,
        date: _dateController.text.trim(),
        startTime: _startTimeController.text.trim(),
        endTime: _endTimeController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Reserva #${reservation.id} criada com status ${reservation.status}.',
          ),
        ),
      );

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
          _isSubmitting = false;
        });
      }
    }
  }

  InputDecoration _decoration({required String label, required IconData icon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppTheme.green),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      filled: true,
      fillColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final court = widget.court;

    return Scaffold(
      appBar: AppBar(title: const Text('Criar reserva')),
      body: ListView(
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
                const Icon(
                  Icons.event_available,
                  color: Colors.white,
                  size: 44,
                ),
                const SizedBox(height: 16),
                Text(
                  court.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Cliente ID ${AppConfig.clientId} • Quadra ID ${court.id}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          TextField(
            controller: _dateController,
            decoration: _decoration(
              label: 'Data da reserva',
              icon: Icons.calendar_month,
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _startTimeController,
            decoration: _decoration(
              label: 'Horário inicial',
              icon: Icons.schedule,
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _endTimeController,
            decoration: _decoration(
              label: 'Horário final',
              icon: Icons.schedule_send,
            ),
          ),
          const SizedBox(height: 22),
          ElevatedButton.icon(
            onPressed: _isSubmitting ? null : _submit,
            icon: _isSubmitting
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.check_circle),
            label: const Text('Confirmar solicitação'),
          ),
          const SizedBox(height: 12),
          const Text(
            'A reserva será criada como PENDING e enviada ao prestador automaticamente.',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
