import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart';
import '../models/booking.dart';
import '../models/vehicle.dart';
import '../providers/trip_provider.dart';

class PassengerTripDetailsScreen extends StatefulWidget {
  final Trip trip;

  const PassengerTripDetailsScreen({
    super.key,
    required this.trip,
  });

  @override
  State<PassengerTripDetailsScreen> createState() =>
      _PassengerTripDetailsScreenState();
}

class _PassengerTripDetailsScreenState
    extends State<PassengerTripDetailsScreen> {
  int _selectedSeats = 1;
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppColors.primary,
        middle: const Text(
          'تفاصيل الرحلة',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(
            CupertinoIcons.back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      child: SafeArea(
        child: Consumer<TripProvider>(
          builder: (context, tripProvider, child) {
            final bookings = tripProvider.getBookingsForTrip(widget.trip.id);
            final bookedSeats = bookings.fold<int>(
                0, (sum, booking) => sum + booking.seatNumbers.length);
            final availableSeats = widget.trip.availableSeats - bookedSeats;

            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _buildTripInfoCard(),
                      const SizedBox(height: 16),
                      _buildRouteCard(),
                      const SizedBox(height: 16),
                      _buildSeatsCard(availableSeats),
                      const SizedBox(height: 16),
                      _buildBookingForm(),
                    ],
                  ),
                ),
                _buildBookButton(availableSeats),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTripInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'وقت المغادرة',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.trip.departureTime,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'التاريخ',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.trip.departureDate.day}/${widget.trip.departureDate.month}/${widget.trip.departureDate.year}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: Colors.white.withOpacity(0.3)),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(
                CupertinoIcons.car_detailed,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                _getVehicleTypeName(widget.trip.vehicleType),
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                '${widget.trip.pricePerSeat.toStringAsFixed(0)} د.ع / مقعد',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRouteCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'المسار',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // From
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        CupertinoIcons.location_fill,
                        color: AppColors.success,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'من',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.trip.fromGovernorate.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (widget.trip.fromWaitingPoint != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        widget.trip.fromWaitingPoint!.name,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Arrow
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: const Column(
                  children: [
                    Icon(
                      CupertinoIcons.arrow_right,
                      color: AppColors.secondary,
                      size: 32,
                    ),
                    SizedBox(height: 4),
                    Text(
                      '~150 كم',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // To
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        CupertinoIcons.location_solid,
                        color: AppColors.error,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'إلى',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.end,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.trip.toGovernorate.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.end,
                    ),
                    if (widget.trip.toWaitingPoint != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        widget.trip.toWaitingPoint!.name,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSeatsCard(int availableSeats) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'عدد المقاعد',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                'المقاعد المتاحة: ',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '$availableSeats من ${widget.trip.availableSeats}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: availableSeats > 0 ? AppColors.success : AppColors.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text(
                'عدد المقاعد المطلوبة:',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: _selectedSeats > 1
                    ? () => setState(() => _selectedSeats--)
                    : null,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _selectedSeats > 1
                        ? AppColors.primary
                        : AppColors.border,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    CupertinoIcons.minus,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _selectedSeats.toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: _selectedSeats < availableSeats
                    ? () => setState(() => _selectedSeats++)
                    : null,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _selectedSeats < availableSeats
                        ? AppColors.primary
                        : AppColors.border,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    CupertinoIcons.plus,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'المجموع:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '${(widget.trip.pricePerSeat * _selectedSeats).toStringAsFixed(0)} د.ع',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'معلومات الراكب',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          CupertinoTextField(
            controller: _nameController,
            placeholder: 'الاسم الكامل',
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 12),
          CupertinoTextField(
            controller: _phoneController,
            placeholder: 'رقم الهاتف',
            keyboardType: TextInputType.phone,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildBookButton(int availableSeats) {
    final canBook = availableSeats >= _selectedSeats &&
        _nameController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty;
    
    final isFull = availableSeats <= 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: isFull 
              ? _showFullMessage 
              : (canBook ? () => _confirmBooking() : null),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              gradient: canBook && !isFull
                  ? const LinearGradient(
                      colors: [AppColors.secondary, Color(0xFFFFD700)],
                    )
                  : null,
              color: canBook && !isFull ? null : (isFull ? AppColors.error : AppColors.border),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              isFull ? 'المقاعد ممتلئة' : 'تأكيد الحجز',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isFull ? Colors.white : AppColors.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showFullMessage() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('المقاعد ممتلئة'),
        content: const Text(
          'عذراً، جميع المقاعد في هذه الرحلة محجوزة. يرجى اختيار رحلة أخرى.',
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  void _confirmBooking() {
    final tripProvider = Provider.of<TripProvider>(context, listen: false);
    
    // الحصول على المقاعد المتاحة الحالية
    final bookings = tripProvider.getBookingsForTrip(widget.trip.id);
    final bookedSeats = bookings.fold<int>(
        0, (sum, booking) => sum + booking.seatNumbers.length);
    final availableSeats = widget.trip.availableSeats - bookedSeats;
    
    // التحقق من توفر المقاعد مرة أخرى
    if (availableSeats < _selectedSeats) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('غير متوفر'),
          content: Text(
            'عذراً، المقاعد المتاحة حالياً $availableSeats فقط.',
          ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => Navigator.pop(context),
              child: const Text('حسناً'),
            ),
          ],
        ),
      );
      return;
    }

    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('تأكيد الحجز'),
        content: Text(
          'هل تريد حجز $_selectedSeats ${_selectedSeats == 1 ? 'مقعد' : 'مقاعد'} بمبلغ ${(widget.trip.pricePerSeat * _selectedSeats).toStringAsFixed(0)} د.ع؟',
        ),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context); // Close confirmation dialog
              _processBooking();
            },
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );
  }

  void _processBooking() {
    final tripProvider = Provider.of<TripProvider>(context, listen: false);
    
    // الحصول على المقاعد المتاحة الحالية
    final bookings = tripProvider.getBookingsForTrip(widget.trip.id);
    final bookedSeats = bookings.fold<int>(
        0, (sum, booking) => sum + booking.seatNumbers.length);
    final availableSeats = widget.trip.availableSeats - bookedSeats;
    
    // التحقق النهائي من توفر المقاعد
    if (availableSeats < _selectedSeats) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('المقاعد ممتلئة'),
          content: Text(
            'عذراً، المقاعد المتاحة حالياً $availableSeats فقط.',
          ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => Navigator.pop(context),
              child: const Text('حسناً'),
            ),
          ],
        ),
      );
      return;
    }

    final booking = Booking(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      tripId: widget.trip.id,
      passengerId: 'passenger_${DateTime.now().millisecondsSinceEpoch}',
      passengerName: _nameController.text.trim(),
      passengerPhone: _phoneController.text.trim(),
      seatNumbers: List.generate(_selectedSeats, (index) => index + 1),
      totalPrice: widget.trip.pricePerSeat * _selectedSeats,
      bookingDate: DateTime.now(),
      status: BookingStatus.confirmed,
    );

    tripProvider.addBooking(booking);

    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Row(
          children: [
            Icon(
              CupertinoIcons.checkmark_circle_fill,
              color: AppColors.success,
              size: 28,
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Text('تم الحجز بنجاح'),
            ),
          ],
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            const Text(
              'تم حجز رحلتك بنجاح!',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'عدد المقاعد: $_selectedSeats',
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              'المبلغ الإجمالي: ${(widget.trip.pricePerSeat * _selectedSeats).toStringAsFixed(0)} د.ع',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            const Text(
              'سيتواصل معك السائق قريباً.',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              // الرجوع للصفحة الرئيسية للراكب
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/home',
                (route) => false,
              );
            },
            child: const Text('العودة للرئيسية'),
          ),
        ],
      ),
    );
  }

  String _getVehicleTypeName(VehicleType type) {
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
}
