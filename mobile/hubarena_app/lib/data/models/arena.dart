class Arena {
  final int id;
  final int providerId;
  final String name;
  final String? sport;
  final String? description;
  final String address;
  final String? imageUrl;
  final String? createdAt;

  Arena({
    required this.id,
    required this.providerId,
    required this.name,
    this.sport,
    this.description,
    required this.address,
    this.imageUrl,
    this.createdAt,
  });

  factory Arena.fromJson(Map<String, dynamic> json) {
    return Arena(
      id: json['id'] as int,
      providerId: json['providerId'] as int? ?? 0,
      name: json['name'] as String? ?? 'Arena esportiva',
      sport: json['sport'] as String?,
      description: json['description'] as String?,
      address: json['address'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      createdAt: json['createdAt'] as String?,
    );
  }
}
