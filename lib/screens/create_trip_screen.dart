import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart';
import '../models/governorate.dart';
import '../models/vehicle.dart';
import '../models/waiting_point.dart';
import '../providers/trip_provider.dart';

class CreateTripScreen extends StatefulWidget {
  final VoidCallback? onTripCreated;
  
  const CreateTripScreen({super.key, this.onTripCreated});

  @override
  State<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  final _formKey = GlobalKey<FormState>();
  
  Governorate? _fromGovernorate;
  Governorate? _toGovernorate;
  WaitingPoint? _fromWaitingPoint;
  WaitingPoint? _toWaitingPoint;
  DateTime? _departureDate;
  TimeOfDay? _departureTime;
  int _availableSeats = 3;
  double _pricePerSeat = 10000;

  final List<Governorate> _governorates = Governorate.iraqiGovernorates;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppColors.primary,
        middle: const Text(
          'إنشاء رحلة جديدة',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        border: null,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryLight],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Column(
                    children: [
                      Icon(
                        CupertinoIcons.car_detailed,
                        color: Colors.white,
                        size: 40,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'املأ تفاصيل الرحلة',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'ستظهر رحلتك للركاب بعد النشر',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                const Text(
                  'مسار الرحلة',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // From Location
                _buildLocationField(
                  label: 'من',
                  icon: CupertinoIcons.location_fill,
                  iconColor: AppColors.primary,
                  value: _fromGovernorate?.name,
                  onTap: () => _showGovernoratePickerFrom(),
                ),
                
                const SizedBox(height: 12),
                
                // From Waiting Point (يظهر فقط عند اختيار المحافظة)
                if (_fromGovernorate != null)
                  _buildLocationField(
                    label: 'نقطة الانطلاق',
                    icon: CupertinoIcons.map_pin_ellipse,
                    iconColor: AppColors.secondary,
                    value: _fromWaitingPoint?.name,
                    onTap: () => _showWaitingPointPicker(true),
                  ),
                
                const SizedBox(height: 16),
                
                // To Location
                _buildLocationField(
                  label: 'إلى',
                  icon: CupertinoIcons.placemark_fill,
                  iconColor: AppColors.error,
                  value: _toGovernorate?.name,
                  onTap: () => _showGovernoratePickerTo(),
                ),
                
                const SizedBox(height: 12),
                
                // To Waiting Point (يظهر فقط عند اختيار المحافظة)
                if (_toGovernorate != null)
                  _buildLocationField(
                    label: 'نقطة الوصول',
                    icon: CupertinoIcons.map_pin_ellipse,
                    iconColor: AppColors.secondary,
                    value: _toWaitingPoint?.name,
                    onTap: () => _showWaitingPointPicker(false),
                  ),
                
                const SizedBox(height: 24),
                
                const Text(
                  'موعد الانطلاق',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Date and Time
                Row(
                  children: [
                    Expanded(
                      child: _buildDateTimeField(
                        label: 'التاريخ',
                        icon: CupertinoIcons.calendar,
                        value: _departureDate != null
                            ? '${_departureDate!.day}/${_departureDate!.month}/${_departureDate!.year}'
                            : null,
                        onTap: () => _selectDate(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDateTimeField(
                        label: 'الوقت',
                        icon: CupertinoIcons.time,
                        value: _departureTime != null
                            ? '${_departureTime!.hour}:${_departureTime!.minute.toString().padLeft(2, '0')}'
                            : null,
                        onTap: () => _selectTime(),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                const Text(
                  'تفاصيل المركبة',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Available Seats
                _buildSeatsSelector(),
                
                const SizedBox(height: 24),
                
                const Text(
                  'السعر',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Price Per Seat
                _buildPriceField(),
                
                const SizedBox(height: 24),
                
                // Notes (Optional)
                const Text(
                  'ملاحظات (اختياري)',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                Material(
                  color: Colors.transparent,
                  child: TextFormField(
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'مثال: التوقف في محطة الوقود، لا تدخين، الخ...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Create Trip Button
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _createTrip,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryLight],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.4),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.checkmark_circle_fill,
                            color: Colors.white,
                            size: 24,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'نشر الرحلة',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationField({
    required String label,
    required IconData icon,
    required Color iconColor,
    String? value,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value ?? 'اختر المحافظة',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: value != null ? AppColors.textPrimary : AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(CupertinoIcons.chevron_down, color: AppColors.textHint),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimeField({
    required String label,
    required IconData icon,
    String? value,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: AppColors.primary, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                value ?? 'اختر $label',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: value != null ? AppColors.textPrimary : AppColors.textHint,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeatsSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(CupertinoIcons.person_2_fill, color: AppColors.primary, size: 20),
              SizedBox(width: 8),
              Text(
                'عدد المقاعد المتاحة',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Material(
                color: Colors.transparent,
                child: IconButton(
                  onPressed: _availableSeats > 1 ? () => setState(() => _availableSeats--) : null,
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _availableSeats > 1 ? AppColors.primary : AppColors.border,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(CupertinoIcons.minus, color: Colors.white, size: 20),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$_availableSeats',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Material(
                color: Colors.transparent,
                child: IconButton(
                  onPressed: _availableSeats < 15 ? () => setState(() => _availableSeats++) : null,
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _availableSeats < 15 ? AppColors.primary : AppColors.border,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(CupertinoIcons.plus, color: Colors.white, size: 20),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceField() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(CupertinoIcons.money_dollar_circle_fill, color: AppColors.success, size: 20),
              SizedBox(width: 8),
              Text(
                'سعر المقعد الواحد (دينار عراقي)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Material(
            color: Colors.transparent,
            child: TextFormField(
              initialValue: _pricePerSeat.toStringAsFixed(0),
              keyboardType: TextInputType.number,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.success,
              ),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.success.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                suffixText: 'IQD',
                suffixStyle: const TextStyle(
                  fontSize: 18,
                  color: AppColors.success,
                ),
              ),
              onChanged: (value) {
                final price = double.tryParse(value);
                if (price != null) {
                  setState(() => _pricePerSeat = price);
                }
              },
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'إجمالي الأرباح المتوقعة:',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  '${(_pricePerSeat * _availableSeats).toStringAsFixed(0)} IQD',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showGovernoratePickerFrom() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 300,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: const Text('إلغاء'),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text('اختر نقطة الانطلاق', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  CupertinoButton(
                    child: const Text('تم'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CupertinoPicker(
                itemExtent: 50,
                onSelectedItemChanged: (index) {
                  setState(() {
                    _fromGovernorate = _governorates[index];
                    _fromWaitingPoint = null; // إعادة تعيين نقطة الانتظار عند تغيير المحافظة
                  });
                },
                children: _governorates.map((gov) => Center(child: Text(gov.name, style: const TextStyle(fontSize: 18)))).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showGovernoratePickerTo() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 300,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: const Text('إلغاء'),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text('اختر الوجهة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  CupertinoButton(
                    child: const Text('تم'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CupertinoPicker(
                itemExtent: 50,
                onSelectedItemChanged: (index) {
                  setState(() {
                    _toGovernorate = _governorates[index];
                    _toWaitingPoint = null; // إعادة تعيين نقطة الانتظار عند تغيير المحافظة
                  });
                },
                children: _governorates.map((gov) => Center(child: Text(gov.name, style: const TextStyle(fontSize: 18)))).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // دالة جديدة لاختيار نقطة الانتظار
  void _showWaitingPointPicker(bool isFrom) {
    final governorate = isFrom ? _fromGovernorate : _toGovernorate;
    if (governorate == null) return;

    final waitingPoints = WaitingPoint.getPointsByGovernorate(governorate.id);
    
    if (waitingPoints.isEmpty) {
      // في حالة عدم وجود نقاط انتظار
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('تنبيه'),
          content: Text('لا توجد نقاط انتظار محددة لـ ${governorate.name}'),
          actions: [
            CupertinoDialogAction(
              child: const Text('حسناً'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
      return;
    }

    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 300,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: const Text('إلغاء'),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    isFrom ? 'نقطة الانطلاق - ${governorate.name}' : 'نقطة الوصول - ${governorate.name}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  CupertinoButton(
                    child: const Text('تم'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CupertinoPicker(
                itemExtent: 50,
                onSelectedItemChanged: (index) {
                  setState(() {
                    if (isFrom) {
                      _fromWaitingPoint = waitingPoints[index];
                    } else {
                      _toWaitingPoint = waitingPoints[index];
                    }
                  });
                },
                children: waitingPoints.map((point) => 
                  Center(
                    child: Text(
                      point.name,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectDate() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 300,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: const Text('إلغاء'),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text('اختر التاريخ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  CupertinoButton(
                    child: const Text('تم'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: DateTime.now(),
                minimumDate: DateTime.now(),
                onDateTimeChanged: (date) => setState(() => _departureDate = date),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectTime() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 300,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: const Text('إلغاء'),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text('اختر الوقت', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  CupertinoButton(
                    child: const Text('تم'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                initialDateTime: DateTime.now(),
                use24hFormat: true,
                onDateTimeChanged: (time) => setState(() => _departureTime = TimeOfDay.fromDateTime(time)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _createTrip() {
    if (_fromGovernorate == null || _toGovernorate == null) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('تنبيه'),
          content: const Text('الرجاء اختيار نقطة الانطلاق والوجهة'),
          actions: [
            CupertinoDialogAction(
              child: const Text('حسناً'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
      return;
    }

    if (_departureDate == null || _departureTime == null) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('تنبيه'),
          content: const Text('الرجاء اختيار تاريخ ووقت الانطلاق'),
          actions: [
            CupertinoDialogAction(
              child: const Text('حسناً'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
      return;
    }

    // إنشاء الرحلة وإضافتها إلى Provider
    final tripProvider = Provider.of<TripProvider>(context, listen: false);
    final newTrip = Trip(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fromGovernorate: _fromGovernorate!,
      toGovernorate: _toGovernorate!,
      fromWaitingPoint: _fromWaitingPoint,
      toWaitingPoint: _toWaitingPoint,
      departureDate: _departureDate!,
      departureTime: '${_departureTime!.hour}:${_departureTime!.minute.toString().padLeft(2, '0')}',
      vehicleType: VehicleType.sedan,
      availableSeats: _availableSeats,
      totalSeats: _availableSeats,
      pricePerSeat: _pricePerSeat,
      status: TripStatus.upcoming,
      createdAt: DateTime.now(),
    );

    tripProvider.addTrip(newTrip);

    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('نجاح'),
        content: const Text('تم نشر الرحلة بنجاح!\nسيتم إشعارك عند حجز الركاب.'),
        actions: [
          CupertinoDialogAction(
            child: const Text('حسناً'),
            onPressed: () {
              Navigator.pop(context); // إغلاق الـ dialog
              
              // إعادة تعيين النموذج
              setState(() {
                _fromGovernorate = null;
                _toGovernorate = null;
                _fromWaitingPoint = null;
                _toWaitingPoint = null;
                _departureDate = null;
                _departureTime = null;
                _availableSeats = 3;
                _pricePerSeat = 10000;
              });
              
              // استدعاء callback للرجوع إلى الشاشة الرئيسية
              if (widget.onTripCreated != null) {
                widget.onTripCreated!();
              }
            },
          ),
        ],
      ),
    );
  }
}
