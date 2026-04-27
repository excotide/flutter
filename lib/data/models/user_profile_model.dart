import '../../domain/entities/user_profile.dart';

class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.name,
    required super.username,
    required super.email,
    required super.phone,
    required super.website,
    required super.companyName,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      name: json['name'] as String? ?? '-',
      username: json['username'] as String? ?? '-',
      email: json['email'] as String? ?? '-',
      phone: json['phone'] as String? ?? '-',
      website: json['website'] as String? ?? '-',
      companyName: (json['company'] as Map<String, dynamic>?)?['name'] as String? ?? '-',
    );
  }
}
