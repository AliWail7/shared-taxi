import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../utils/app_colors.dart';
import 'home_screen.dart';
import 'trips_screen.dart';
import 'map_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: Colors.white,
        activeColor: AppColors.primary,
        inactiveColor: AppColors.textSecondary,
        iconSize: 26,
        height: 60,
        border: const Border(
          top: BorderSide(
            color: AppColors.border,
            width: 0.5,
          ),
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 4),
              child: Icon(CupertinoIcons.home),
            ),
            activeIcon: Padding(
              padding: EdgeInsets.only(top: 4),
              child: Icon(CupertinoIcons.house_fill),
            ),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 4),
              child: Icon(CupertinoIcons.car),
            ),
            activeIcon: Padding(
              padding: EdgeInsets.only(top: 4),
              child: Icon(CupertinoIcons.car_fill),
            ),
            label: 'رحلاتي',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 4),
              child: Icon(CupertinoIcons.map),
            ),
            activeIcon: Padding(
              padding: EdgeInsets.only(top: 4),
              child: Icon(CupertinoIcons.map_fill),
            ),
            label: 'الخريطة',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 4),
              child: Icon(CupertinoIcons.person),
            ),
            activeIcon: Padding(
              padding: EdgeInsets.only(top: 4),
              child: Icon(CupertinoIcons.person_fill),
            ),
            label: 'حسابي',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        late Widget screen;
        switch (index) {
          case 0:
            screen = const HomeScreen();
            break;
          case 1:
            screen = const TripsScreen();
            break;
          case 2:
            screen = const MapScreen();
            break;
          case 3:
            screen = const ProfileScreen();
            break;
          default:
            screen = const HomeScreen();
        }
        return CupertinoTabView(
          builder: (context) => screen,
        );
      },
    );
  }
}
