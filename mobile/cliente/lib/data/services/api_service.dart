import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/config/app_config.dart';
import '../models/arena.dart';
import '../models/court.dart';
import '../models/reservation.dart';

class ApiService {
  ApiService();

  final String _baseUrl = AppConfig.apiBaseUrl.replaceAll(RegExp(r'/$'), '');

  Uri _uri(String path) {
    return Uri.parse('$_baseUrl$path');
  }

  dynamic _decodeResponse(http.Response response) {
    if (response.bodyBytes.isEmpty) {
      return null;
    }

    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  void _validateResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }

    final decoded = _decodeResponse(response);

    if (decoded is Map<String, dynamic> && decoded.containsKey('error')) {
      throw Exception(decoded['error']);
    }

    throw Exception(
      'Erro HTTP ${response.statusCode} ao comunicar com o backend.',
    );
  }

  Future<List<Arena>> getArenas() async {
    final response = await http
        .get(_uri('/arenas'))
        .timeout(const Duration(seconds: 8));
    _validateResponse(response);

    final decoded = _decodeResponse(response) as List<dynamic>;

    return decoded
        .map((item) => Arena.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<Court>> getCourts() async {
    final response = await http
        .get(_uri('/courts'))
        .timeout(const Duration(seconds: 8));
    _validateResponse(response);

    final decoded = _decodeResponse(response) as List<dynamic>;

    return decoded
        .map((item) => Court.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<Reservation>> getReservations() async {
    final response = await http
        .get(_uri('/reservations'))
        .timeout(const Duration(seconds: 8));
    _validateResponse(response);

    final decoded = _decodeResponse(response) as List<dynamic>;

    return decoded
        .map((item) => Reservation.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Reservation> createReservation({
    required int clientId,
    required int courtId,
    required String date,
    required String startTime,
    required String endTime,
  }) async {
    final response = await http
        .post(
          _uri('/reservations'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'clientId': clientId,
            'courtId': courtId,
            'date': date,
            'startTime': startTime,
            'endTime': endTime,
          }),
        )
        .timeout(const Duration(seconds: 8));

    _validateResponse(response);

    final decoded = _decodeResponse(response) as Map<String, dynamic>;

    return Reservation.fromJson(decoded);
  }
}
