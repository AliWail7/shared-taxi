import 'package:flutter/foundation.dart';
import '../models/governorate.dart';
import '../models/waiting_point.dart';
import '../models/vehicle.dart';
import '../models/booking.dart';
import '../services/storage_service.dart';

enum TripStatus {
  upcoming,    // قادمة
  ongoing,     // جارية
  completed,   // مكتملة
  cancelled,   // ملغاة
}

class Trip {
  final String id;
  final Governorate fromGovernorate;
  final Governorate toGovernorate;
  final WaitingPoint? fromWaitingPoint;
  final WaitingPoint? toWaitingPoint;
  final DateTime departureDate;
  final String departureTime;
  final VehicleType vehicleType;
  final int availableSeats;
  final int totalSeats;
  final double pricePerSeat;
  final TripStatus status;
  final DateTime createdAt;

  Trip({
    required this.id,
    required this.fromGovernorate,
    required this.toGovernorate,
    this.fromWaitingPoint,
    this.toWaitingPoint,
    required this.departureDate,
    required this.departureTime,
    required this.vehicleType,
    required this.availableSeats,
    required this.totalSeats,
    required this.pricePerSeat,
    required this.status,
    required this.createdAt,
  });

  int get bookedSeats => totalSeats - availableSeats;

  double get totalEarnings => bookedSeats * pricePerSeat;

  Trip copyWith({
    String? id,
    Governorate? fromGovernorate,
    Governorate? toGovernorate,
    WaitingPoint? fromWaitingPoint,
    WaitingPoint? toWaitingPoint,
    DateTime? departureDate,
    String? departureTime,
    VehicleType? vehicleType,
    int? availableSeats,
    int? totalSeats,
    double? pricePerSeat,
    TripStatus? status,
    DateTime? createdAt,
  }) {
    return Trip(
      id: id ?? this.id,
      fromGovernorate: fromGovernorate ?? this.fromGovernorate,
      toGovernorate: toGovernorate ?? this.toGovernorate,
      fromWaitingPoint: fromWaitingPoint ?? this.fromWaitingPoint,
      toWaitingPoint: toWaitingPoint ?? this.toWaitingPoint,
      departureDate: departureDate ?? this.departureDate,
      departureTime: departureTime ?? this.departureTime,
      vehicleType: vehicleType ?? this.vehicleType,
      availableSeats: availableSeats ?? this.availableSeats,
      totalSeats: totalSeats ?? this.totalSeats,
      pricePerSeat: pricePerSeat ?? this.pricePerSeat,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class TripProvider extends ChangeNotifier {
  final List<Trip> _trips = [];
  final Map<String, List<Booking>> _tripBookings = {}; // الحجوزات لكل رحلة
  bool _isInitialized = false;

  TripProvider() {
    _loadFromStorage();
  }

  // تحميل البيانات من التخزين المحلي
  Future<void> _loadFromStorage() async {
    if (_isInitialized) return;

    try {
      final savedTrips = StorageService.loadTrips();
      final savedBookings = StorageService.loadBookings();

      _trips.clear();
      _trips.addAll(savedTrips);
      _tripBookings.clear();
      _tripBookings.addAll(savedBookings);

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      print('Error loading data from storage: $e');
    }
  }

  // حفظ البيانات في التخزين المحلي
  Future<void> _saveToStorage() async {
    try {
      await StorageService.saveTrips(_trips);
      await StorageService.saveBookings(_tripBookings);
    } catch (e) {
      print('Error saving data to storage: $e');
    }
  }

  List<Trip> get trips => List.unmodifiable(_trips);
  List<Trip> get allTrips => List.unmodifiable(_trips);

  List<Trip> get upcomingTrips =>
      _trips.where((trip) => trip.status == TripStatus.upcoming).toList();

  List<Trip> get ongoingTrips =>
      _trips.where((trip) => trip.status == TripStatus.ongoing).toList();

  List<Trip> get completedTrips =>
      _trips.where((trip) => trip.status == TripStatus.completed).toList();

  List<Trip> get cancelledTrips =>
      _trips.where((trip) => trip.status == TripStatus.cancelled).toList();

  // الحصول على حجوزات رحلة معينة
  List<Booking> getBookingsForTrip(String tripId) {
    return _tripBookings[tripId] ?? [];
  }

  // إضافة حجز جديد (للتجربة)
  void addBooking(Booking booking) {
    if (_tripBookings[booking.tripId] == null) {
      _tripBookings[booking.tripId] = [];
    }
    _tripBookings[booking.tripId]!.add(booking);
    
    // تحديث المقاعد المتاحة
    final tripIndex = _trips.indexWhere((t) => t.id == booking.tripId);
    if (tripIndex != -1) {
      final trip = _trips[tripIndex];
      _trips[tripIndex] = trip.copyWith(
        availableSeats: trip.availableSeats - booking.seatNumbers.length,
      );
    }
    
    _saveToStorage();
    notifyListeners();
  }

  // إلغاء حجز
  void cancelBooking(String bookingId, String tripId) {
    final bookings = _tripBookings[tripId];
    if (bookings != null) {
      final bookingIndex = bookings.indexWhere((b) => b.id == bookingId);
      if (bookingIndex != -1) {
        final booking = bookings[bookingIndex];
        bookings[bookingIndex] = booking.copyWith(status: BookingStatus.cancelled);
        
        // إعادة المقاعد المتاحة
        final tripIndex = _trips.indexWhere((t) => t.id == tripId);
        if (tripIndex != -1) {
          final trip = _trips[tripIndex];
          _trips[tripIndex] = trip.copyWith(
            availableSeats: trip.availableSeats + booking.seatNumbers.length,
          );
        }
        
        _saveToStorage();
        notifyListeners();
      }
    }
  }

  // إحصائيات اليوم
  int get todayTripsCount {
    final today = DateTime.now();
    return _trips.where((trip) {
      return trip.departureDate.year == today.year &&
          trip.departureDate.month == today.month &&
          trip.departureDate.day == today.day &&
          (trip.status == TripStatus.completed || trip.status == TripStatus.ongoing);
    }).length;
  }

  int get todayPassengersCount {
    final today = DateTime.now();
    return _trips.where((trip) {
      return trip.departureDate.year == today.year &&
          trip.departureDate.month == today.month &&
          trip.departureDate.day == today.day &&
          (trip.status == TripStatus.completed || trip.status == TripStatus.ongoing);
    }).fold(0, (sum, trip) => sum + trip.bookedSeats);
  }

  double get todayEarnings {
    final today = DateTime.now();
    return _trips.where((trip) {
      return trip.departureDate.year == today.year &&
          trip.departureDate.month == today.month &&
          trip.departureDate.day == today.day &&
          trip.status == TripStatus.completed;
    }).fold(0.0, (sum, trip) => sum + trip.totalEarnings);
  }

  double get totalEarnings {
    return _trips
        .where((trip) => trip.status == TripStatus.completed)
        .fold(0.0, (sum, trip) => sum + trip.totalEarnings);
  }

  // إضافة رحلة جديدة
  void addTrip(Trip trip) {
    _trips.add(trip);
    
    // إضافة حجوزات تجريبية للرحلة (للتجربة)
    _addSampleBookings(trip.id);
    
    _saveToStorage();
    notifyListeners();
  }

  // إضافة حجوزات تجريبية
  void _addSampleBookings(String tripId) {
    final sampleBookings = [
      Booking(
        id: 'booking_${DateTime.now().millisecondsSinceEpoch}_1',
        tripId: tripId,
        passengerId: 'passenger_1',
        passengerName: 'أحمد محمد',
        passengerPhone: '07701234567',
        seatNumbers: [1],
        totalPrice: 25000,
        bookingDate: DateTime.now(),
        status: BookingStatus.confirmed,
      ),
      Booking(
        id: 'booking_${DateTime.now().millisecondsSinceEpoch}_2',
        tripId: tripId,
        passengerId: 'passenger_2',
        passengerName: 'علي حسن',
        passengerPhone: '07712345678',
        seatNumbers: [2],
        totalPrice: 25000,
        bookingDate: DateTime.now(),
        status: BookingStatus.confirmed,
      ),
    ];

    _tripBookings[tripId] = sampleBookings;
  }

  // تحديث حالة الرحلة
  void updateTripStatus(String tripId, TripStatus newStatus) {
    final index = _trips.indexWhere((trip) => trip.id == tripId);
    if (index != -1) {
      _trips[index] = _trips[index].copyWith(status: newStatus);
      _saveToStorage();
      notifyListeners();
    }
  }

  // حذف رحلة
  void deleteTrip(String tripId) {
    _trips.removeWhere((trip) => trip.id == tripId);
    _saveToStorage();
    notifyListeners();
  }

  // تحديث بيانات الرحلة
  void updateTrip(Trip updatedTrip) {
    final index = _trips.indexWhere((trip) => trip.id == updatedTrip.id);
    if (index != -1) {
      _trips[index] = updatedTrip;
      _saveToStorage();
      notifyListeners();
    }
  }

  // الحصول على رحلة بالمعرف
  Trip? getTripById(String id) {
    try {
      return _trips.firstWhere((trip) => trip.id == id);
    } catch (e) {
      return null;
    }
  }
}
