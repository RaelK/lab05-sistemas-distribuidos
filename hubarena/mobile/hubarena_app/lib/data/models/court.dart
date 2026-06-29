class Court {
  final int id;
  final int arenaId;
  final String name;
  final String sport;
  final String? description;
  final String? imageUrl;
  final double priceHour;
  final int capacity;
  final bool available;

  Court({
    required this.id,
    required this.arenaId,
    required this.name,
    required this.sport,
    this.description,
    this.imageUrl,
    required this.priceHour,
    required this.capacity,
    required this.available,
  });

  factory Court.fromJson(Map<String, dynamic> json) {
    return Court(
      id: json['id'] as int,
      arenaId: json['arenaId'] as int? ?? 0,
      name: json['name'] as String? ?? 'Quadra esportiva',
      sport: json['sport'] as String? ?? 'Futebol',
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      priceHour: (json['priceHour'] as num?)?.toDouble() ?? 0.0,
      capacity: json['capacity'] as int? ?? 0,
      available: json['available'] as bool? ?? true,
    );
  }
}
