class UserModel {
  final String name;
  final String email;
  final String? userRole;
  final String? token;

  UserModel({
    required this.name,
    required this.email,
    this.userRole,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      email: json['email'],
      userRole: json['role'],
      token: json['token'],
    );
  }
}
