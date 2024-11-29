class UserModel {
  final String username;
  final String email;
  final String id;

  UserModel({required this.username, required this.email, required this.id});

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'id': id,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map,) {
    return UserModel(
      username: map['username'] ?? 'N/A',
      email: map['email'] ?? 'N/A',
      id: map['id'] ?? 'N/A',
    );
  }
}
