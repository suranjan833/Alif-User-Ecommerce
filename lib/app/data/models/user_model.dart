class UserModel {
  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? avatar;
  final String? role;
  final String? status;
  final String? referralCode;
  final String? createdAt;
  final String? updatedAt;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.avatar,
    this.role,
    this.status,
    this.referralCode,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? json['_id']?.toString(),
      name: json['name']?.toString() ?? json['fullName']?.toString(),
      email: json['email']?.toString(),
      phone: json['phone']?.toString() ?? json['phoneNumber']?.toString(),
      avatar: json['avatar']?.toString() ?? json['profileImage']?.toString(),
      role: json['role']?.toString(),
      status: json['status']?.toString(),
      referralCode: json['referralCode']?.toString() ?? json['referral_code']?.toString(),
      createdAt: json['createdAt']?.toString() ?? json['created_at']?.toString(),
      updatedAt: json['updatedAt']?.toString() ?? json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'role': role,
      'status': status,
      'referralCode': referralCode,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
