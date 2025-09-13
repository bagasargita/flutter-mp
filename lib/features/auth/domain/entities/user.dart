class User {
  final String id;
  final String email;
  final String name;
  final String? phoneNumber;
  final String? profilePicture;
  final String memberStatus;
  final String roleMobile;
  final String? branchId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.phoneNumber,
    this.profilePicture,
    required this.memberStatus,
    required this.roleMobile,
    this.branchId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      email: json['email'] as String,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      profilePicture: json['profile_picture'] as String?,
      memberStatus: json['member_status'] as String? ?? 'active',
      roleMobile: json['roleMobile'] as String? ?? 'CUSTOMER',
      branchId: json['branch'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone_number': phoneNumber,
      'profile_picture': profilePicture,
      'member_status': memberStatus,
      'roleMobile': roleMobile,
      'branch': branchId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? phoneNumber,
    String? profilePicture,
    String? memberStatus,
    String? roleMobile,
    String? branchId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePicture: profilePicture ?? this.profilePicture,
      memberStatus: memberStatus ?? this.memberStatus,
      roleMobile: roleMobile ?? this.roleMobile,
      branchId: branchId ?? this.branchId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
