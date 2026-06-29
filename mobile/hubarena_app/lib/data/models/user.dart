class User {
  final int id;
  final String name;
  final String email;
  final String role;
  final String? profilePhotoUrl;
  final String? profileType;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.profilePhotoUrl,
    this.profileType,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String? ?? 'Usuário',
      email: json['email'] as String? ?? '',
      role: json['role'] as String? ?? 'CLIENT',
      profilePhotoUrl: json['profilePhotoUrl'] as String?,
      profileType: json['profileType'] as String?,
    );
  }

  bool get isClient => role.toUpperCase() == 'CLIENT';
  bool get isProvider => role.toUpperCase() == 'PROVIDER';
}
