enum UserType {
  driver,
  passenger,
}

class User {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final String password; // Added password field
  final UserType userType;
  final String? profileImage;
  final double rating;
  final int totalTrips;
  final bool isVerified;
  final DateTime createdAt;
  
  // Driver specific fields
  final String? governorate;
  final String? address;
  final String? vehicleBrand;
  final String? vehicleModel;
  final String? vehicleColor;
  final String? plateNumber;
  final String? vehicleType;
  final int? totalSeats;
  final bool? hasAC;

  const User({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    required this.password,
    required this.userType,
    this.profileImage,
    this.rating = 0.0,
    this.totalTrips = 0,
    this.isVerified = false,
    required this.createdAt,
    this.governorate,
    this.address,
    this.vehicleBrand,
    this.vehicleModel,
    this.vehicleColor,
    this.plateNumber,
    this.vehicleType,
    this.totalSeats,
    this.hasAC,
  });
  
  bool get isDriver => userType == UserType.driver;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String?,
      password: json['password'] as String? ?? '',
      userType: UserType.values.firstWhere(
        (e) => e.toString() == 'UserType.${json['userType']}',
      ),
      profileImage: json['profileImage'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      totalTrips: json['totalTrips'] as int? ?? 0,
      isVerified: json['isVerified'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      governorate: json['governorate'] as String?,
      address: json['address'] as String?,
      vehicleBrand: json['vehicleBrand'] as String?,
      vehicleModel: json['vehicleModel'] as String?,
      vehicleColor: json['vehicleColor'] as String?,
      plateNumber: json['plateNumber'] as String?,
      vehicleType: json['vehicleType'] as String?,
      totalSeats: json['totalSeats'] as int?,
      hasAC: json['hasAC'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'password': password,
      'userType': userType.toString().split('.').last,
      'profileImage': profileImage,
      'rating': rating,
      'totalTrips': totalTrips,
      'isVerified': isVerified,
      'createdAt': createdAt.toIso8601String(),
      'governorate': governorate,
      'address': address,
      'vehicleBrand': vehicleBrand,
      'vehicleModel': vehicleModel,
      'vehicleColor': vehicleColor,
      'plateNumber': plateNumber,
      'vehicleType': vehicleType,
      'totalSeats': totalSeats,
      'hasAC': hasAC,
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? password,
    UserType? userType,
    String? profileImage,
    double? rating,
    int? totalTrips,
    bool? isVerified,
    DateTime? createdAt,
    String? governorate,
    String? address,
    String? vehicleBrand,
    String? vehicleModel,
    String? vehicleColor,
    String? plateNumber,
    String? vehicleType,
    int? totalSeats,
    bool? hasAC,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      password: password ?? this.password,
      userType: userType ?? this.userType,
      profileImage: profileImage ?? this.profileImage,
      rating: rating ?? this.rating,
      totalTrips: totalTrips ?? this.totalTrips,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      governorate: governorate ?? this.governorate,
      address: address ?? this.address,
      vehicleBrand: vehicleBrand ?? this.vehicleBrand,
      vehicleModel: vehicleModel ?? this.vehicleModel,
      vehicleColor: vehicleColor ?? this.vehicleColor,
      plateNumber: plateNumber ?? this.plateNumber,
      vehicleType: vehicleType ?? this.vehicleType,
      totalSeats: totalSeats ?? this.totalSeats,
      hasAC: hasAC ?? this.hasAC,
    );
  }
}
