import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/governorate.dart';
import '../models/waiting_point.dart';
import '../models/vehicle.dart';
import '../models/booking.dart';
import '../providers/trip_provider.dart';

class StorageService {
  static const String _tripsKey = 'trips';
  static const String _bookingsKey = 'bookings';
  static const String _userKey = 'user';
  static const String _userTypeKey = 'userType';

  static SharedPreferences? _prefs;

  // Initialize SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception('StorageService not initialized. Call init() first.');
    }
    return _prefs!;
  }

  // === Trip Storage ===

  static Future<void> saveTrips(List<Trip> trips) async {
    final tripsJson = trips.map((trip) => _tripToJson(trip)).toList();
    await prefs.setString(_tripsKey, jsonEncode(tripsJson));
  }

  static List<Trip> loadTrips() {
    final tripsString = prefs.getString(_tripsKey);
    if (tripsString == null || tripsString.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> tripsJson = jsonDecode(tripsString);
      return tripsJson.map((json) => _tripFromJson(json)).toList();
    } catch (e) {
      print('Error loading trips: $e');
      return [];
    }
  }

  static Future<void> clearTrips() async {
    await prefs.remove(_tripsKey);
  }

  // === Booking Storage ===

  static Future<void> saveBookings(Map<String, List<Booking>> bookings) async {
    final bookingsJson = <String, dynamic>{};
    bookings.forEach((tripId, bookingList) {
      bookingsJson[tripId] = bookingList.map((b) => _bookingToJson(b)).toList();
    });
    await prefs.setString(_bookingsKey, jsonEncode(bookingsJson));
  }

  static Map<String, List<Booking>> loadBookings() {
    final bookingsString = prefs.getString(_bookingsKey);
    if (bookingsString == null || bookingsString.isEmpty) {
      return {};
    }

    try {
      final Map<String, dynamic> bookingsJson = jsonDecode(bookingsString);
      final result = <String, List<Booking>>{};
      
      bookingsJson.forEach((tripId, bookingList) {
        result[tripId] = (bookingList as List)
            .map((json) => _bookingFromJson(json))
            .toList();
      });
      
      return result;
    } catch (e) {
      print('Error loading bookings: $e');
      return {};
    }
  }

  static Future<void> clearBookings() async {
    await prefs.remove(_bookingsKey);
  }

  // === User Storage ===

  static Future<void> saveUser(Map<String, dynamic> user) async {
    await prefs.setString(_userKey, jsonEncode(user));
  }

  static Map<String, dynamic>? loadUser() {
    final userString = prefs.getString(_userKey);
    if (userString == null || userString.isEmpty) {
      return null;
    }

    try {
      return jsonDecode(userString);
    } catch (e) {
      print('Error loading user: $e');
      return null;
    }
  }

  static Future<void> saveUserType(String userType) async {
    await prefs.setString(_userTypeKey, userType);
  }

  static String? loadUserType() {
    return prefs.getString(_userTypeKey);
  }

  static Future<void> clearUser() async {
    await prefs.remove(_userKey);
    await prefs.remove(_userTypeKey);
  }

  // === Clear All Data ===

  static Future<void> clearAll() async {
    await prefs.clear();
  }

  // === Helper Methods ===

  static Map<String, dynamic> _tripToJson(Trip trip) {
    return {
      'id': trip.id,
      'fromGovernorate': {
        'id': trip.fromGovernorate.id,
        'name': trip.fromGovernorate.name,
        'nameEn': trip.fromGovernorate.nameEn,
        'latitude': trip.fromGovernorate.latitude,
        'longitude': trip.fromGovernorate.longitude,
      },
      'toGovernorate': {
        'id': trip.toGovernorate.id,
        'name': trip.toGovernorate.name,
        'nameEn': trip.toGovernorate.nameEn,
        'latitude': trip.toGovernorate.latitude,
        'longitude': trip.toGovernorate.longitude,
      },
      'fromWaitingPoint': trip.fromWaitingPoint != null
          ? {
              'id': trip.fromWaitingPoint!.id,
              'name': trip.fromWaitingPoint!.name,
              'governorateId': trip.fromWaitingPoint!.governorateId,
              'latitude': trip.fromWaitingPoint!.latitude,
              'longitude': trip.fromWaitingPoint!.longitude,
            }
          : null,
      'toWaitingPoint': trip.toWaitingPoint != null
          ? {
              'id': trip.toWaitingPoint!.id,
              'name': trip.toWaitingPoint!.name,
              'governorateId': trip.toWaitingPoint!.governorateId,
              'latitude': trip.toWaitingPoint!.latitude,
              'longitude': trip.toWaitingPoint!.longitude,
            }
          : null,
      'departureDate': trip.departureDate.toIso8601String(),
      'departureTime': trip.departureTime,
      'vehicleType': trip.vehicleType.toString().split('.').last,
      'availableSeats': trip.availableSeats,
      'totalSeats': trip.totalSeats,
      'pricePerSeat': trip.pricePerSeat,
      'status': trip.status.toString().split('.').last,
      'createdAt': trip.createdAt.toIso8601String(),
    };
  }

  static Trip _tripFromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'],
      fromGovernorate: Governorate(
        id: json['fromGovernorate']['id'],
        name: json['fromGovernorate']['name'],
        nameEn: json['fromGovernorate']['nameEn'],
        latitude: json['fromGovernorate']['latitude'],
        longitude: json['fromGovernorate']['longitude'],
      ),
      toGovernorate: Governorate(
        id: json['toGovernorate']['id'],
        name: json['toGovernorate']['name'],
        nameEn: json['toGovernorate']['nameEn'],
        latitude: json['toGovernorate']['latitude'],
        longitude: json['toGovernorate']['longitude'],
      ),
      fromWaitingPoint: json['fromWaitingPoint'] != null
          ? WaitingPoint(
              id: json['fromWaitingPoint']['id'],
              name: json['fromWaitingPoint']['name'],
              governorateId: json['fromWaitingPoint']['governorateId'],
              latitude: json['fromWaitingPoint']['latitude'],
              longitude: json['fromWaitingPoint']['longitude'],
            )
          : null,
      toWaitingPoint: json['toWaitingPoint'] != null
          ? WaitingPoint(
              id: json['toWaitingPoint']['id'],
              name: json['toWaitingPoint']['name'],
              governorateId: json['toWaitingPoint']['governorateId'],
              latitude: json['toWaitingPoint']['latitude'],
              longitude: json['toWaitingPoint']['longitude'],
            )
          : null,
      departureDate: DateTime.parse(json['departureDate']),
      departureTime: json['departureTime'],
      vehicleType: VehicleType.values.firstWhere(
        (e) => e.toString().split('.').last == json['vehicleType'],
      ),
      availableSeats: json['availableSeats'],
      totalSeats: json['totalSeats'],
      pricePerSeat: json['pricePerSeat'],
      status: TripStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
      ),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  static Map<String, dynamic> _bookingToJson(Booking booking) {
    return {
      'id': booking.id,
      'tripId': booking.tripId,
      'passengerId': booking.passengerId,
      'passengerName': booking.passengerName,
      'passengerPhone': booking.passengerPhone,
      'seatNumbers': booking.seatNumbers,
      'totalPrice': booking.totalPrice,
      'status': booking.status.toString().split('.').last,
      'paymentMethod': booking.paymentMethod.toString().split('.').last,
      'isPaid': booking.isPaid,
      'bookingDate': booking.bookingDate.toIso8601String(),
      'cancellationReason': booking.cancellationReason,
    };
  }

  static Booking _bookingFromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      tripId: json['tripId'],
      passengerId: json['passengerId'],
      passengerName: json['passengerName'],
      passengerPhone: json['passengerPhone'],
      seatNumbers: List<int>.from(json['seatNumbers']),
      totalPrice: json['totalPrice'],
      status: BookingStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
      ),
      paymentMethod: PaymentMethod.values.firstWhere(
        (e) => e.toString().split('.').last == json['paymentMethod'],
      ),
      isPaid: json['isPaid'],
      bookingDate: DateTime.parse(json['bookingDate']),
      cancellationReason: json['cancellationReason'],
    );
  }
}
