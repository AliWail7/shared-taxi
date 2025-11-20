import 'governorate.dart';
import 'vehicle.dart';

enum TripStatus {
  scheduled,
  inProgress,
  completed,
  cancelled,
}

class Trip {
  final String id;
  final String driverId;
  final String driverName;
  final double driverRating;
  final Governorate fromGovernorate;
  final Governorate toGovernorate;
  final DateTime departureTime;
  final Vehicle vehicle;
  final int availableSeats;
  final int totalSeats;
  final List<int> bookedSeats;
  final double pricePerSeat;
  final TripStatus status;
  final String? notes;
  final DateTime createdAt;

  const Trip({
    required this.id,
    required this.driverId,
    required this.driverName,
    this.driverRating = 0.0,
    required this.fromGovernorate,
    required this.toGovernorate,
    required this.departureTime,
    required this.vehicle,
    required this.availableSeats,
    required this.totalSeats,
    this.bookedSeats = const [],
    required this.pricePerSeat,
    this.status = TripStatus.scheduled,
    this.notes,
    required this.createdAt,
  });

  bool get isFull => availableSeats == 0;
  
  bool get isActive => status == TripStatus.scheduled || status == TripStatus.inProgress;

  String get statusText {
    switch (status) {
      case TripStatus.scheduled:
        return 'مجدولة';
      case TripStatus.inProgress:
        return 'جارية';
      case TripStatus.completed:
        return 'مكتملة';
      case TripStatus.cancelled:
        return 'ملغاة';
    }
  }

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'] as String,
      driverId: json['driverId'] as String,
      driverName: json['driverName'] as String,
      driverRating: (json['driverRating'] as num?)?.toDouble() ?? 0.0,
      fromGovernorate: Governorate.fromJson(json['fromGovernorate'] as Map<String, dynamic>),
      toGovernorate: Governorate.fromJson(json['toGovernorate'] as Map<String, dynamic>),
      departureTime: DateTime.parse(json['departureTime'] as String),
      vehicle: Vehicle.fromJson(json['vehicle'] as Map<String, dynamic>),
      availableSeats: json['availableSeats'] as int,
      totalSeats: json['totalSeats'] as int,
      bookedSeats: (json['bookedSeats'] as List<dynamic>?)?.map((e) => e as int).toList() ?? [],
      pricePerSeat: (json['pricePerSeat'] as num).toDouble(),
      status: TripStatus.values.firstWhere(
        (e) => e.toString() == 'TripStatus.${json['status']}',
      ),
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'driverId': driverId,
      'driverName': driverName,
      'driverRating': driverRating,
      'fromGovernorate': fromGovernorate.toJson(),
      'toGovernorate': toGovernorate.toJson(),
      'departureTime': departureTime.toIso8601String(),
      'vehicle': vehicle.toJson(),
      'availableSeats': availableSeats,
      'totalSeats': totalSeats,
      'bookedSeats': bookedSeats,
      'pricePerSeat': pricePerSeat,
      'status': status.toString().split('.').last,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Trip copyWith({
    String? id,
    String? driverId,
    String? driverName,
    double? driverRating,
    Governorate? fromGovernorate,
    Governorate? toGovernorate,
    DateTime? departureTime,
    Vehicle? vehicle,
    int? availableSeats,
    int? totalSeats,
    List<int>? bookedSeats,
    double? pricePerSeat,
    TripStatus? status,
    String? notes,
    DateTime? createdAt,
  }) {
    return Trip(
      id: id ?? this.id,
      driverId: driverId ?? this.driverId,
      driverName: driverName ?? this.driverName,
      driverRating: driverRating ?? this.driverRating,
      fromGovernorate: fromGovernorate ?? this.fromGovernorate,
      toGovernorate: toGovernorate ?? this.toGovernorate,
      departureTime: departureTime ?? this.departureTime,
      vehicle: vehicle ?? this.vehicle,
      availableSeats: availableSeats ?? this.availableSeats,
      totalSeats: totalSeats ?? this.totalSeats,
      bookedSeats: bookedSeats ?? this.bookedSeats,
      pricePerSeat: pricePerSeat ?? this.pricePerSeat,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
