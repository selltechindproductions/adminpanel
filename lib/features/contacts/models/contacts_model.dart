class ContactMessageModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String message;
  final DateTime createdAt;
  bool isRead;

  ContactMessageModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.message,
    required this.createdAt,
    this.isRead = false,
  });
}
