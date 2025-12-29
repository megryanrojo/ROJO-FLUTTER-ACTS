class User {
  final int? id;
  final String firebaseUid;
  final String email;
  final String fullName;
  final String? phone;
  final String? profileImageUrl;
  final String role;
  final String status;

  User({
    this.id,
    required this.firebaseUid,
    required this.email,
    required this.fullName,
    this.phone,
    this.profileImageUrl,
    required this.role,
    required this.status,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firebaseUid: json['firebase_uid'] ?? '',
      email: json['email'] ?? '',
      fullName: json['full_name'] ?? '',
      phone: json['phone'],
      profileImageUrl: json['profile_image_url'],
      role: json['role'] ?? 'buyer',
      status: json['status'] ?? 'active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firebase_uid': firebaseUid,
      'email': email,
      'full_name': fullName,
      'phone': phone,
      'profile_image_url': profileImageUrl,
      'role': role,
      'status': status,
    };
  }
}
