enum BookingStatus {
  pending,
  confirmed,
  cancelled,
  completed,
}

enum PaymentMethod {
  cash,
  card,
  wallet,
}

class Booking {
  final String id;
  final String tripId;
  final String passengerId;
  final String passengerName;
  final String passengerPhone;
  final List<int> seatNumbers;
  final double totalPrice;
  final BookingStatus status;
  final PaymentMethod paymentMethod;
  final bool isPaid;
  final DateTime bookingDate;
  final String? cancellationReason;

  const Booking({
    required this.id,
    required this.tripId,
    required this.passengerId,
    required this.passengerName,
    required this.passengerPhone,
    required this.seatNumbers,
    required this.totalPrice,
    this.status = BookingStatus.pending,
    this.paymentMethod = PaymentMethod.cash,
    this.isPaid = false,
    required this.bookingDate,
    this.cancellationReason,
  });

  String get statusText {
    switch (status) {
      case BookingStatus.pending:
        return 'قيد الانتظار';
      case BookingStatus.confirmed:
        return 'مؤكد';
      case BookingStatus.cancelled:
        return 'ملغى';
      case BookingStatus.completed:
        return 'مكتمل';
    }
  }

  String get paymentMethodText {
    switch (paymentMethod) {
      case PaymentMethod.cash:
        return 'نقداً';
      case PaymentMethod.card:
        return 'بطاقة';
      case PaymentMethod.wallet:
        return 'محفظة';
    }
  }

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as String,
      tripId: json['tripId'] as String,
      passengerId: json['passengerId'] as String,
      passengerName: json['passengerName'] as String,
      passengerPhone: json['passengerPhone'] as String,
      seatNumbers: (json['seatNumbers'] as List<dynamic>).map((e) => e as int).toList(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      status: BookingStatus.values.firstWhere(
        (e) => e.toString() == 'BookingStatus.${json['status']}',
      ),
      paymentMethod: PaymentMethod.values.firstWhere(
        (e) => e.toString() == 'PaymentMethod.${json['paymentMethod']}',
      ),
      isPaid: json['isPaid'] as bool? ?? false,
      bookingDate: DateTime.parse(json['bookingDate'] as String),
      cancellationReason: json['cancellationReason'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tripId': tripId,
      'passengerId': passengerId,
      'passengerName': passengerName,
      'passengerPhone': passengerPhone,
      'seatNumbers': seatNumbers,
      'totalPrice': totalPrice,
      'status': status.toString().split('.').last,
      'paymentMethod': paymentMethod.toString().split('.').last,
      'isPaid': isPaid,
      'bookingDate': bookingDate.toIso8601String(),
      'cancellationReason': cancellationReason,
    };
  }

  Booking copyWith({
    String? id,
    String? tripId,
    String? passengerId,
    String? passengerName,
    String? passengerPhone,
    List<int>? seatNumbers,
    double? totalPrice,
    BookingStatus? status,
    PaymentMethod? paymentMethod,
    bool? isPaid,
    DateTime? bookingDate,
    String? cancellationReason,
  }) {
    return Booking(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      passengerId: passengerId ?? this.passengerId,
      passengerName: passengerName ?? this.passengerName,
      passengerPhone: passengerPhone ?? this.passengerPhone,
      seatNumbers: seatNumbers ?? this.seatNumbers,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      isPaid: isPaid ?? this.isPaid,
      bookingDate: bookingDate ?? this.bookingDate,
      cancellationReason: cancellationReason ?? this.cancellationReason,
    );
  }
}
