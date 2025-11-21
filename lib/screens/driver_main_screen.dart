import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart';
import '../providers/trip_provider.dart';
import 'create_trip_screen.dart';
import 'trip_details_screen.dart';
import 'driver_map_screen.dart';

class DriverMainScreen extends StatefulWidget {
  const DriverMainScreen({super.key});

  @override
  State<DriverMainScreen> createState() => _DriverMainScreenState();
}

class _DriverMainScreenState extends State<DriverMainScreen> {
  int _currentIndex = 0;

  List<Widget> _getScreens() {
    return [
      const DriverHomeScreen(),
      const DriverMapScreen(),
      CreateTripScreen(
        onTripCreated: () {
          setState(() {
            _currentIndex = 0; // الرجوع إلى الشاشة الرئيسية
          });
        },
      ),
      const DriverEarningsScreen(),
      const DriverProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final screens = _getScreens();
    
    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.primary,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: CupertinoIcons.home,
                  label: 'الرئيسية',
                  index: 0,
                ),
                _buildNavItem(
                  icon: CupertinoIcons.map_fill,
                  label: 'الخريطة',
                  index: 1,
                ),
                _buildNavItem(
                  icon: CupertinoIcons.add_circled,
                  label: 'إضافة',
                  index: 2,
                  isCenter: true,
                ),
                _buildNavItem(
                  icon: CupertinoIcons.money_dollar_circle,
                  label: 'الأرباح',
                  index: 3,
                ),
                _buildNavItem(
                  icon: CupertinoIcons.person,
                  label: 'حسابي',
                  index: 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    bool isCenter = false,
  }) {
    final isActive = _currentIndex == index;
    
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isCenter ? 16 : 12,
          vertical: isCenter ? 12 : 8,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? (isCenter ? AppColors.secondary : Colors.white.withOpacity(0.2))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(isCenter ? 16 : 12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isCenter && isActive ? AppColors.primary : Colors.white,
              size: isCenter ? 28 : 24,
            ),
            if (!isCenter) ...[
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// شاشة الرئيسية للسائق
class DriverHomeScreen extends StatelessWidget {
  const DriverHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: AppColors.primary,
        middle: Text(
          'مرحباً أيها السائق',
          style: TextStyle(color: Colors.white),
        ),
        border: null,
      ),
      child: SafeArea(
        child: Consumer<TripProvider>(
          builder: (context, tripProvider, child) {
            final upcomingTrips = tripProvider.upcomingTrips;
            final completedTrips = tripProvider.completedTrips;
            
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // إحصائيات اليوم
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryLight],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'إحصائيات اليوم',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatItem(
                              'الرحلات',
                              tripProvider.todayTripsCount.toString(),
                              CupertinoIcons.car,
                            ),
                            _buildStatItem(
                              'الركاب',
                              tripProvider.todayPassengersCount.toString(),
                              CupertinoIcons.person_2,
                            ),
                            _buildStatItem(
                              'الأرباح',
                              '${(tripProvider.todayEarnings / 1000).toStringAsFixed(0)}K',
                              CupertinoIcons.money_dollar,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  const Text(
                    'الرحلات القادمة',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // عرض الرحلات القادمة
                  if (upcomingTrips.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          children: [
                            Icon(
                              CupertinoIcons.car_detailed,
                              size: 60,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'لا توجد رحلات قادمة',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ...upcomingTrips.map((trip) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildTripCard(
                        context: context,
                        trip: trip,
                        isCompleted: false,
                      ),
                    )),
                  
                  if (completedTrips.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const Text(
                      'الرحلات المكتملة',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...completedTrips.take(3).map((trip) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildTripCard(
                        context: context,
                        trip: trip,
                        isCompleted: true,
                      ),
                    )),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.secondary, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildTripCard({
    required BuildContext context,
    required Trip trip,
    required bool isCompleted,
  }) {
    final fromLocation = trip.fromWaitingPoint?.name ?? trip.fromGovernorate.name;
    final toLocation = trip.toWaitingPoint?.name ?? trip.toGovernorate.name;
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => TripDetailsScreen(trip: trip),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: isCompleted ? Border.all(color: AppColors.success, width: 2) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isCompleted 
                        ? AppColors.success.withOpacity(0.1)
                        : AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    isCompleted 
                        ? CupertinoIcons.checkmark_circle_fill
                        : CupertinoIcons.location_solid,
                    color: isCompleted ? AppColors.success : AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '$fromLocation ← $toLocation',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (isCompleted)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.success,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'مكتملة',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${trip.departureDate.day}/${trip.departureDate.month} - ${trip.departureTime}',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildInfoChip(
                  '${trip.bookedSeats} ركاب',
                  CupertinoIcons.person_2,
                ),
                const SizedBox(width: 8),
                _buildInfoChip(
                  '${trip.availableSeats} متاح',
                  CupertinoIcons.checkmark_seal,
                ),
                const SizedBox(width: 8),
                _buildInfoChip(
                  '${(trip.totalEarnings / 1000).toStringAsFixed(0)}K',
                  CupertinoIcons.money_dollar,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// شاشة رحلات السائق
class DriverTripsScreen extends StatelessWidget {
  const DriverTripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: AppColors.primary,
        middle: Text(
          'رحلاتي',
          style: TextStyle(color: Colors.white),
        ),
        border: null,
      ),
      child: const Center(
        child: Text('قائمة رحلات السائق'),
      ),
    );
  }
}

// شاشة الأرباح
class DriverEarningsScreen extends StatelessWidget {
  const DriverEarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: AppColors.primary,
        middle: Text(
          'أرباحي',
          style: TextStyle(color: Colors.white),
        ),
        border: null,
      ),
      child: const Center(
        child: Text('إحصائيات الأرباح'),
      ),
    );
  }
}

// شاشة الملف الشخصي للسائق
class DriverProfileScreen extends StatelessWidget {
  const DriverProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: AppColors.primary,
        middle: Text(
          'حسابي',
          style: TextStyle(color: Colors.white),
        ),
        border: null,
      ),
      child: const Center(
        child: Text('الملف الشخصي للسائق'),
      ),
    );
  }
}
