class UserProfile {
  final String firstName;
  final String lastName;
  final String email;
  final String? phoneNumber;
  final String? gender;
  final DateTime? birthday;
  final String? profileImageUrl;

  UserProfile({
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phoneNumber,
    this.gender,
    this.birthday,
    this.profileImageUrl,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      phoneNumber:
          json['phone_number'] != null ? json['phone_number'] as String : null,
      gender: json['gender'] != null ? json['gender'] as String : null,
      birthday: json['birth_date'] != null
          ? DateTime.tryParse(json['birth_date'])
          : null,
      profileImageUrl: json['photo'] != null ? json['photo'] as String : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone_number': phoneNumber,
      'gender': gender,
      'birth_date': birthday?.toIso8601String(),
      'photo': profileImageUrl,
    };
  }

  UserProfile copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? gender,
    DateTime? birthday,
    String? profileImageUrl,
  }) {
    return UserProfile(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      gender: gender ?? this.gender,
      birthday: birthday ?? this.birthday,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}
