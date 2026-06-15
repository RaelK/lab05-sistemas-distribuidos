class Court {
  final int id;
  final int arenaId;
  final String sport;
  final double priceHour;
  final int capacity;
  final bool available;

  Court({
    required this.id,
    required this.arenaId,
    required this.sport,
    required this.priceHour,
    required this.capacity,
    required this.available,
  });

  factory Court.fromJson(Map<String, dynamic> json) {
    return Court(
      id: json['id'] as int,
      arenaId: json['arenaId'] as int,
      sport: json['sport'] as String,
      priceHour: (json['priceHour'] as num).toDouble(),
      capacity: json['capacity'] as int,
      available: json['available'] as bool,
    );
  }
}
