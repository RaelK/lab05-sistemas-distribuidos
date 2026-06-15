import 'package:flutter/material.dart';

import '../../core/config/app_config.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/court.dart';
import '../../data/services/api_service.dart';
import 'reservations_screen.dart';

class CreateReservationScreen extends StatefulWidget {
  final Court court;
  final String arenaName;

  const CreateReservationScreen({
    super.key,
    required this.court,
    required this.arenaName,
  });

  @override
  State<CreateReservationScreen> createState() =>
      _CreateReservationScreenState();
}

class _CreateReservationScreenState extends State<CreateReservationScreen> {
  final ApiService _apiService = ApiService();

  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _startTime = const TimeOfDay(hour: 18, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 19, minute: 0);

  bool _isLoading = false;

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: now,
      lastDate: now.add(const Duration(days: 60)),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _pickStartTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );

    if (pickedTime != null) {
      setState(() {
        _startTime = pickedTime;
      });
    }
  }

  Future<void> _pickEndTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _endTime,
    );

    if (pickedTime != null) {
      setState(() {
        _endTime = pickedTime;
      });
    }
  }

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _apiService.createReservation(
        clientId: AppConfig.clientId,
        courtId: widget.court.id,
        date: _formatDate(_selectedDate),
        startTime: _formatTime(_startTime),
        endTime: _formatTime(_endTime),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reserva criada com sucesso. Status: PENDENTE.'),
        ),
      );

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const ReservationsScreen()),
        (route) => route.isFirst,
      );
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
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateText = _formatDate(_selectedDate);
    final startText = _formatTime(_startTime);
    final endText = _formatTime(_endTime);

    return Scaffold(
      appBar: AppBar(title: const Text('Nova reserva')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.darkGreen, AppTheme.primaryGreen],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(26),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.sports_score, color: Colors.white, size: 42),
                const SizedBox(height: 14),
                Text(
                  widget.court.sport,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.arenaName,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Cliente ID ${AppConfig.clientId}',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.85)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _PickerTile(
            icon: Icons.calendar_month,
            title: 'Data da reserva',
            value: dateText,
            onTap: _pickDate,
          ),
          _PickerTile(
            icon: Icons.access_time,
            title: 'Horário de início',
            value: startText,
            onTap: _pickStartTime,
          ),
          _PickerTile(
            icon: Icons.timer,
            title: 'Horário de término',
            value: endText,
            onTap: _pickEndTime,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _isLoading ? null : _submit,
            icon: _isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.check_circle),
            label: Text(
              _isLoading ? 'Criando reserva...' : 'Confirmar reserva',
            ),
          ),
        ],
      ),
    );
  }
}

class _PickerTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;

  const _PickerTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primaryGreen),
        title: Text(title),
        subtitle: Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        trailing: const Icon(Icons.edit_calendar),
        onTap: onTap,
      ),
    );
  }
}
