class UserModel {
  final String id;
  final String name;
  final String email;
  final String
  password; // Note: In production, never fetch raw passwords to the frontend
  final String profilePic;
  final String profession;
  final String role; // e.g., 'Admin', 'Editor', 'User'
  final bool isVerified;
  final String deviceId;
  final String fcmToken;
  final List<String> recentBlogs;
  final List<String> recentProducts;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    this.profilePic = '',
    this.profession = 'Unspecified',
    this.role = 'User',
    this.isVerified = false,
    this.deviceId = '',
    this.fcmToken = '',
    this.recentBlogs = const [],
    this.recentProducts = const [],
    required this.createdAt,
    required this.updatedAt,
  });
}
