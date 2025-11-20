enum VehicleType {
  sedan,
  suv,
  van,
  minibus,
}

class Vehicle {
  final String id;
  final String driverId;
  final VehicleType type;
  final String brand;
  final String model;
  final int year;
  final String color;
  final String plateNumber;
  final int totalSeats;
  final bool hasAC;
  final String? image;
  final bool isVerified;

  const Vehicle({
    required this.id,
    required this.driverId,
    required this.type,
    required this.brand,
    required this.model,
    required this.year,
    required this.color,
    required this.plateNumber,
    required this.totalSeats,
    this.hasAC = true,
    this.image,
    this.isVerified = false,
  });

  String get vehicleTypeName {
    switch (type) {
      case VehicleType.sedan:
        return 'سيدان';
      case VehicleType.suv:
        return 'دفع رباعي';
      case VehicleType.van:
        return 'فان';
      case VehicleType.minibus:
        return 'باص صغير';
    }
  }

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'] as String,
      driverId: json['driverId'] as String,
      type: VehicleType.values.firstWhere(
        (e) => e.toString() == 'VehicleType.${json['type']}',
      ),
      brand: json['brand'] as String,
      model: json['model'] as String,
      year: json['year'] as int,
      color: json['color'] as String,
      plateNumber: json['plateNumber'] as String,
      totalSeats: json['totalSeats'] as int,
      hasAC: json['hasAC'] as bool? ?? true,
      image: json['image'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'driverId': driverId,
      'type': type.toString().split('.').last,
      'brand': brand,
      'model': model,
      'year': year,
      'color': color,
      'plateNumber': plateNumber,
      'totalSeats': totalSeats,
      'hasAC': hasAC,
      'image': image,
      'isVerified': isVerified,
    };
  }
}
