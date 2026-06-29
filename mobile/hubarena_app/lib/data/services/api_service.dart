import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/config/app_config.dart';
import '../models/arena.dart';
import '../models/court.dart';
import '../models/reservation.dart';
import '../models/user.dart';

class ApiService {
  Future<void> deleteArena(int arenaId) async {
    final response = await http
        .delete(_uri('/arenas/$arenaId'))
        .timeout(const Duration(seconds: 8));

    _validateResponse(response);
  }

  Future<void> deleteCourt(int courtId) async {
    final response = await http
        .delete(_uri('/courts/$courtId'))
        .timeout(const Duration(seconds: 8));

    _validateResponse(response);
  }

  Future<Court> createCourt({
    required int arenaId,
    required String name,
    required String sport,
    required String description,
    required double priceHour,
    required int capacity,
    bool available = true,
    String? imageUrl,
  }) async {
    final response = await http
        .post(
          _uri('/courts'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'arenaId': arenaId,
            'name': name,
            'sport': sport,
            'description': description,
            'priceHour': priceHour,
            'capacity': capacity,
            'available': available,
            'imageUrl': imageUrl,
          }),
        )
        .timeout(const Duration(seconds: 8));

    _validateResponse(response);

    return Court.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<Court> updateCourt({
    required int courtId,
    String? name,
    String? sport,
    String? description,
    double? priceHour,
    int? capacity,
    bool? available,
    String? imageUrl,
  }) async {
    final response = await http
        .put(
          _uri('/courts/$courtId'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'name': ?name,
            'sport': ?sport,
            'description': ?description,
            'priceHour': ?priceHour,
            'capacity': ?capacity,
            'available': ?available,
            'imageUrl': ?imageUrl,
          }),
        )
        .timeout(const Duration(seconds: 8));

    _validateResponse(response);

    return Court.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<List<Arena>> getArenas() async {
    final response = await http
        .get(_uri('/arenas'))
        .timeout(const Duration(seconds: 8));

    _validateResponse(response);

    final decoded = jsonDecode(response.body) as List<dynamic>;

    return decoded
        .map((item) => Arena.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Arena> createArena({
    required int providerId,
    required String name,
    required String sport,
    required String description,
    required String address,
    String? imageUrl,
  }) async {
    final response = await http
        .post(
          _uri('/arenas'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'providerId': providerId,
            'name': name,
            'sport': sport,
            'description': description,
            'address': address,
            'imageUrl': imageUrl,
          }),
        )
        .timeout(const Duration(seconds: 8));

    _validateResponse(response);

    return Arena.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<Arena> updateArena({
    required int arenaId,
    String? name,
    String? sport,
    String? description,
    String? address,
    String? imageUrl,
  }) async {
    final response = await http
        .put(
          _uri('/arenas/$arenaId'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'name': ?name,
            'sport': ?sport,
            'description': ?description,
            'address': ?address,
            'imageUrl': ?imageUrl,
          }),
        )
        .timeout(const Duration(seconds: 8));

    _validateResponse(response);

    return Arena.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<List<Reservation>> getReservationsByClient(int clientId) async {
    final response = await http
        .get(_uri('/reservations/client/$clientId'))
        .timeout(const Duration(seconds: 8));

    _validateResponse(response);

    final decoded = jsonDecode(response.body) as List<dynamic>;

    return decoded
        .map((item) => Reservation.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<Reservation>> getReservationsByProvider(int providerId) async {
    final response = await http
        .get(_uri('/reservations/provider/$providerId'))
        .timeout(const Duration(seconds: 8));

    _validateResponse(response);

    final decoded = jsonDecode(response.body) as List<dynamic>;

    return decoded
        .map((item) => Reservation.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<Reservation>> getReservationsByStatus(String status) async {
    final response = await http
        .get(_uri('/reservations/status/$status'))
        .timeout(const Duration(seconds: 8));

    _validateResponse(response);

    final decoded = jsonDecode(response.body) as List<dynamic>;

    return decoded
        .map((item) => Reservation.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Reservation> cancelReservation(int reservationId) async {
    final response = await http
        .put(_uri('/reservations/$reservationId/cancel'))
        .timeout(const Duration(seconds: 8));

    _validateResponse(response);

    return Reservation.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<Reservation> finishReservation(int reservationId) async {
    final response = await http
        .put(_uri('/reservations/$reservationId/finish'))
        .timeout(const Duration(seconds: 8));

    _validateResponse(response);

    return Reservation.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<User> getUser(int userId) async {
    final response = await http
        .get(_uri('/users/$userId'))
        .timeout(const Duration(seconds: 8));

    _validateResponse(response);

    return User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<User> updateUser({
    required int userId,
    required String name,
    required String email,
    String? profileType,
  }) async {
    final response = await http
        .put(
          _uri('/users/$userId'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'name': name,
            'email': email,
            'profileType': profileType,
          }),
        )
        .timeout(const Duration(seconds: 8));

    _validateResponse(response);

    return User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<User> updatePassword({
    required int userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    final response = await http
        .put(
          _uri('/users/$userId/password'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'currentPassword': currentPassword,
            'newPassword': newPassword,
          }),
        )
        .timeout(const Duration(seconds: 8));

    _validateResponse(response);

    return User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<User> updateProfilePhoto({
    required int userId,
    required String profilePhotoUrl,
  }) async {
    final response = await http
        .put(
          _uri('/users/$userId/profile-photo'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'profilePhotoUrl': profilePhotoUrl}),
        )
        .timeout(const Duration(seconds: 8));

    _validateResponse(response);

    return User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<User> deleteProfilePhoto(int userId) async {
    final response = await http
        .delete(_uri('/users/$userId/profile-photo'))
        .timeout(const Duration(seconds: 8));

    _validateResponse(response);

    return User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<User> createUser({
    required String name,
    required String email,
    required String password,
    required String role,
    String? profileType,
  }) async {
    final response = await http
        .post(
          _uri('/users'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'name': name,
            'email': email,
            'password': password,
            'role': role,
            'profileType': profileType,
          }),
        )
        .timeout(const Duration(seconds: 8));

    _validateResponse(response);

    return User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<User> login({required String email, required String password}) async {
    final response = await http
        .post(
          _uri('/users/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email, 'password': password}),
        )
        .timeout(const Duration(seconds: 8));

    _validateResponse(response);

    return User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Uri _uri(String path) {
    return Uri.parse('${AppConfig.apiBaseUrl}$path');
  }

  Future<List<Court>> getCourts() async {
    final response = await http
        .get(_uri('/courts'))
        .timeout(const Duration(seconds: 8));

    _validateResponse(response);

    final decoded = jsonDecode(response.body) as List<dynamic>;

    return decoded
        .map((item) => Court.fromJson(item as Map<String, dynamic>))
        .toList();
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

    return Reservation.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
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
