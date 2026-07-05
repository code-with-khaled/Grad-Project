class User {
  final int? id;
  final String? name;
  final String? phone;
  final String? role;

  User({this.id, this.name, this.phone, this.role});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      role: json['role'],
    );
  }
}
