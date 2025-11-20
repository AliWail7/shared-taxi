enum UserType {
  driver,
  passenger,
}

class User {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final UserType userType;
  final String? profileImage;
  final double rating;
  final int totalTrips;
  final bool isVerified;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    required this.userType,
    this.profileImage,
    this.rating = 0.0,
    this.totalTrips = 0,
    this.isVerified = false,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String?,
      userType: UserType.values.firstWhere(
        (e) => e.toString() == 'UserType.${json['userType']}',
      ),
      profileImage: json['profileImage'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      totalTrips: json['totalTrips'] as int? ?? 0,
      isVerified: json['isVerified'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'userType': userType.toString().split('.').last,
      'profileImage': profileImage,
      'rating': rating,
      'totalTrips': totalTrips,
      'isVerified': isVerified,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    UserType? userType,
    String? profileImage,
    double? rating,
    int? totalTrips,
    bool? isVerified,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      userType: userType ?? this.userType,
      profileImage: profileImage ?? this.profileImage,
      rating: rating ?? this.rating,
      totalTrips: totalTrips ?? this.totalTrips,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
