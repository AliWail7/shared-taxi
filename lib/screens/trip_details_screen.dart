import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart';
import '../providers/trip_provider.dart';
import '../models/booking.dart';

class TripDetailsScreen extends StatelessWidget {
  final Trip trip;

  const TripDetailsScreen({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return Consumer<TripProvider>(
      builder: (context, tripProvider, child) {
        final bookings = tripProvider.getBookingsForTrip(trip.id);
        final confirmedBookings = bookings.where((b) => b.status == BookingStatus.confirmed).toList();
        final isFullyBooked = trip.availableSeats == 0;
        final canStartTrip = isFullyBooked && trip.status == TripStatus.upcoming;

        return CupertinoPageScaffold(
          backgroundColor: AppColors.background,
          navigationBar: CupertinoNavigationBar(
            backgroundColor: AppColors.primary,
            middle: const Text(
              'تفاصيل الرحلة',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
            leading: CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(CupertinoIcons.back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(CupertinoIcons.ellipsis_vertical, color: Colors.white),
              onPressed: () => _showOptionsMenu(context, tripProvider),
            ),
            border: null,
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // بطاقة معلومات الرحلة
                  _buildTripInfoCard(),

                  const SizedBox(height: 24),

                  // حالة الحجز
                  _buildBookingStatusCard(isFullyBooked),

                  const SizedBox(height: 24),

                  // قائمة الركاب
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'الركاب المحجوزون',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${confirmedBookings.length} راكب',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // عرض الركاب أو رسالة فارغة
                  if (confirmedBookings.isEmpty)
                    _buildEmptyState()
                  else
                    ...confirmedBookings.map((booking) => _buildPassengerCard(booking)),

                  const SizedBox(height: 24),

                  // أزرار الإجراءات
                  if (trip.status == TripStatus.upcoming) ...[
                    if (canStartTrip)
                      _buildActionButton(
                        context: context,
                        label: 'بدء الرحلة',
                        icon: CupertinoIcons.play_circle_fill,
                        color: AppColors.success,
                        onPressed: () => _startTrip(context, tripProvider),
                      ),
                    const SizedBox(height: 12),
                    _buildActionButton(
                      context: context,
                      label: 'إلغاء الرحلة',
                      icon: CupertinoIcons.xmark_circle_fill,
                      color: AppColors.error,
                      onPressed: () => _cancelTrip(context, tripProvider),
                    ),
                  ],

                  if (trip.status == TripStatus.ongoing) ...[
                    _buildActionButton(
                      context: context,
                      label: 'إنهاء الرحلة',
                      icon: CupertinoIcons.checkmark_circle_fill,
                      color: AppColors.success,
                      onPressed: () => _completeTrip(context, tripProvider),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTripInfoCard() {
    final fromLocation = trip.fromWaitingPoint?.name ?? trip.fromGovernorate.name;
    final toLocation = trip.toWaitingPoint?.name ?? trip.toGovernorate.name;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          CupertinoIcons.location_solid,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            fromLocation,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Center(
                      child: Icon(
                        CupertinoIcons.arrow_down,
                        color: Colors.white70,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(
                          CupertinoIcons.placemark_fill,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            toLocation,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Icon(
                      CupertinoIcons.calendar,
                      color: Colors.white,
                      size: 28,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${trip.departureDate.day}/${trip.departureDate.month}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      trip.departureTime,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: Colors.white.withOpacity(0.3)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildInfoItem(
                CupertinoIcons.person_2,
                '${trip.bookedSeats}/${trip.totalSeats}',
              ),
              _buildInfoItem(
                CupertinoIcons.money_dollar,
                '${trip.pricePerSeat.toStringAsFixed(0)} د.ع',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 18),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildBookingStatusCard(bool isFullyBooked) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isFullyBooked ? AppColors.success.withOpacity(0.1) : AppColors.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isFullyBooked ? AppColors.success : AppColors.secondary,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isFullyBooked ? CupertinoIcons.checkmark_seal_fill : CupertinoIcons.info_circle_fill,
            color: isFullyBooked ? AppColors.success : AppColors.secondary,
            size: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isFullyBooked ? 'المقاعد محجوزة بالكامل' : 'متاح للحجز',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isFullyBooked ? AppColors.success : AppColors.secondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isFullyBooked
                      ? 'جميع المقاعد محجوزة - يمكنك بدء الرحلة'
                      : '${trip.availableSeats} مقعد متاح للحجز',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              CupertinoIcons.person_2,
              size: 60,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'لا يوجد ركاب محجوزون بعد',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'سيظهر الركاب هنا عند الحجز',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPassengerCard(Booking booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              CupertinoIcons.person_fill,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.passengerName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      CupertinoIcons.phone_fill,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      booking.passengerPhone,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${booking.seatNumbers.length} مقعد',
                  style: const TextStyle(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${booking.totalPrice.toStringAsFixed(0)} د.ع',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 24),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showOptionsMenu(BuildContext context, TripProvider tripProvider) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('خيارات الرحلة'),
        actions: [
          CupertinoActionSheetAction(
            child: const Text('تعديل الرحلة'),
            onPressed: () {
              Navigator.pop(context);
              // TODO: Navigate to edit trip screen
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('مشاركة الرحلة'),
            onPressed: () {
              Navigator.pop(context);
              // TODO: Share trip
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          child: const Text('إلغاء'),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  void _startTrip(BuildContext context, TripProvider tripProvider) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('بدء الرحلة'),
        content: const Text('هل أنت متأكد من بدء الرحلة؟\nسيتم إشعار جميع الركاب.'),
        actions: [
          CupertinoDialogAction(
            child: const Text('إلغاء'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('بدء'),
            onPressed: () {
              tripProvider.updateTripStatus(trip.id, TripStatus.ongoing);
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _completeTrip(BuildContext context, TripProvider tripProvider) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('إنهاء الرحلة'),
        content: const Text('هل أنت متأكد من إنهاء الرحلة؟'),
        actions: [
          CupertinoDialogAction(
            child: const Text('إلغاء'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('إنهاء'),
            onPressed: () {
              tripProvider.updateTripStatus(trip.id, TripStatus.completed);
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _cancelTrip(BuildContext context, TripProvider tripProvider) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('إلغاء الرحلة'),
        content: const Text('هل أنت متأكد من إلغاء الرحلة؟\nسيتم إشعار جميع الركاب وإرجاع مبالغهم.'),
        actions: [
          CupertinoDialogAction(
            child: const Text('رجوع'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('إلغاء الرحلة'),
            onPressed: () {
              tripProvider.updateTripStatus(trip.id, TripStatus.cancelled);
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
