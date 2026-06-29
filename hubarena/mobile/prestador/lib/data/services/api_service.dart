import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/config/app_config.dart';
import '../models/reservation.dart';

class ApiService {
  Uri _uri(String path) {
    return Uri.parse('${AppConfig.apiBaseUrl}$path');
  }

  Future<List<Reservation>> getReservations() async {
    final response = await http
        .get(_uri('/reservations'))
        .timeout(const Duration(seconds: 8));

    _validateResponse(response);

    final decoded = jsonDecode(response.body) as List<dynamic>;

    return decoded
        .map((item) => Reservation.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Reservation> acceptReservation(int reservationId) async {
    final response = await http
        .put(_uri('/reservations/$reservationId/accept'))
        .timeout(const Duration(seconds: 8));

    _validateResponse(response);

    return Reservation.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<Reservation> rejectReservation(int reservationId) async {
    final response = await http
        .put(_uri('/reservations/$reservationId/reject'))
        .timeout(const Duration(seconds: 8));

    _validateResponse(response);

    return Reservation.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  void _validateResponse(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Erro ${response.statusCode}: ${response.body}');
    }
  }
}
