class Reservation {
  final int id;
  final int clientId;
  final int courtId;
  final String date;
  final String startTime;
  final String endTime;
  final String status;
  final String? createdAt;
  final String? updatedAt;

  Reservation({
    required this.id,
    required this.clientId,
    required this.courtId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'] as int,
      clientId: json['clientId'] as int,
      courtId: json['courtId'] as int,
      date: json['date'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      status: json['status'] as String,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }
}
