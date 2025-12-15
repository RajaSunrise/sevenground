class AppUser {
  final int? id;
  final String email;
  final String password;
  final String name;

  AppUser({
    this.id,
    required this.email,
    required this.password,
    this.name = 'User',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'name': name,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'],
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      name: map['name'] ?? 'User',
    );
  }
}
