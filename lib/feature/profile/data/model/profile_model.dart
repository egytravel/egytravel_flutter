class ProfileModel {
  final int userId;
  final String name;
  final String email;
  final String role;
  final String? phone;
  final String? nationality;
  final String? dateOfBirth;
  final String? profilePhotoUrl;
  final bool pushEnabled;
  final bool emailEnabled;
  final String? createdAt;

  ProfileModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.role,
    this.phone,
    this.nationality,
    this.dateOfBirth,
    this.profilePhotoUrl,
    this.pushEnabled = true,
    this.emailEnabled = true,
    this.createdAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final notifPrefs = json['notification_preferences'] as Map<String, dynamic>?;
    return ProfileModel(
      userId: json['user_id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'user',
      phone: json['phone'],
      nationality: json['nationality'],
      dateOfBirth: json['date_of_birth'],
      profilePhotoUrl: json['profile_photo_url'],
      pushEnabled: notifPrefs?['push_enabled'] ?? true,
      emailEnabled: notifPrefs?['email_enabled'] ?? true,
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'name': name,
        'email': email,
        'role': role,
        'phone': phone,
        'nationality': nationality,
        'date_of_birth': dateOfBirth,
        'profile_photo_url': profilePhotoUrl,
        'notification_preferences': {
          'push_enabled': pushEnabled,
          'email_enabled': emailEnabled,
        },
      };
}
