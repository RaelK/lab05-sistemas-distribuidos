class Arena {
  final int id;
  final int providerId;
  final String name;
  final String? description;
  final String address;

  Arena({
    required this.id,
    required this.providerId,
    required this.name,
    required this.description,
    required this.address,
  });

  factory Arena.fromJson(Map<String, dynamic> json) {
    return Arena(
      id: json['id'] as int,
      providerId: json['providerId'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      address: json['address'] as String,
    );
  }
}
