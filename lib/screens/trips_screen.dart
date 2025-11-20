import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../utils/app_colors.dart';

class TripsScreen extends StatefulWidget {
  const TripsScreen({super.key});

  @override
  State<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppColors.primary,
        middle: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🏎️'),
            const SizedBox(width: 8),
            const Text(
              'رحلاتي عبر بلاد الرافدين',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 8),
            const Text('🌙'),
          ],
        ),
        border: null,
      ),
      child: Column(
        children: [
          // Tab Bar
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildTabButton(
                    title: 'الرحلات الحالية',
                    index: 0,
                    icon: Icons.directions_car,
                  ),
                ),
                Expanded(
                  child: _buildTabButton(
                    title: 'رحلات سابقة',
                    index: 1,
                    icon: Icons.history,
                  ),
                ),
              ],
            ),
          ),
          
          // Content
          Expanded(
            child: _selectedTab == 0 
              ? _buildCurrentTrips()
              : _buildPastTrips(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton({
    required String title,
    required int index,
    required IconData icon,
  }) {
    final isSelected = _selectedTab == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentTrips() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildTripCard(
          from: 'بغداد',
          to: 'البصرة',
          date: '2024/12/21',
          time: '08:00 ص',
          status: 'مؤكدة',
          statusColor: AppColors.success,
          passengers: 3,
          maxPassengers: 4,
        ),
        _buildTripCard(
          from: 'أربيل',
          to: 'بغداد',
          date: '2024/12/22',
          time: '02:00 م',
          status: 'في الانتظار',
          statusColor: AppColors.warning,
          passengers: 1,
          maxPassengers: 4,
        ),
      ],
    );
  }

  Widget _buildPastTrips() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildTripCard(
          from: 'النجف',
          to: 'كربلاء',
          date: '2024/12/15',
          time: '10:00 ص',
          status: 'مكتملة',
          statusColor: AppColors.success,
          passengers: 4,
          maxPassengers: 4,
          isPast: true,
        ),
        _buildTripCard(
          from: 'بغداد',
          to: 'الموصل',
          date: '2024/12/10',
          time: '06:00 ص',
          status: 'ملغية',
          statusColor: AppColors.error,
          passengers: 2,
          maxPassengers: 4,
          isPast: true,
        ),
      ],
    );
  }

  Widget _buildTripCard({
    required String from,
    required String to,
    required String date,
    required String time,
    required String status,
    required Color statusColor,
    required int passengers,
    required int maxPassengers,
    bool isPast = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.route,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$from ← $to',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Date and time
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: AppColors.textSecondary,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                date,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.access_time,
                color: AppColors.textSecondary,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                time,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Passengers info
          Row(
            children: [
              Icon(
                Icons.people,
                color: AppColors.textSecondary,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                '$passengers/$maxPassengers راكب',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Action buttons
          if (!isPast) ...[
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // View trip details
                    },
                    child: const Text('تفاصيل الرحلة'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Contact passengers or driver
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: const Text(
                      'التواصل',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // View trip details
                    },
                    child: const Text('عرض التفاصيل'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Rate trip
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                    ),
                    child: const Text(
                      'تقييم الرحلة',
                      style: TextStyle(color: AppColors.textPrimary),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

