import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'screens/user_type_selection_screen.dart';
import 'screens/register_screen.dart';
import 'screens/main_screen.dart';
import 'screens/driver_main_screen.dart';
import 'providers/trip_provider.dart';
import 'services/storage_service.dart';
import 'services/auth_service.dart';
import 'utils/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // تهيئة التخزين المحلي
  await StorageService.init();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TripProvider()),
        ChangeNotifierProvider(create: (_) => AuthService()..init()),
      ],
      child: const SharedTaxiApp(),
    ),
  );
}

class SharedTaxiApp extends StatelessWidget {
  const SharedTaxiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'تكسي مشاركة العراق',
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(
        primaryColor: AppColors.primary,
        primaryContrastingColor: Colors.white,
        scaffoldBackgroundColor: AppColors.background,
        barBackgroundColor: AppColors.primary,
        brightness: Brightness.light,
        textTheme: CupertinoTextThemeData(
          primaryColor: AppColors.primary,
          textStyle: TextStyle(
            fontFamily: '.SF UI Text',
            color: AppColors.textPrimary,
          ),
        ),
      ),

      // Localization
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', 'IQ'), // Arabic Iraq
        Locale('en', 'US'), // English
      ],
      locale: const Locale('ar', 'IQ'),

      home: const SplashScreen(),

      // Routes
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/splash':
            return CupertinoPageRoute(builder: (_) => const SplashScreen());
          case '/user-type':
            return CupertinoPageRoute(
              builder: (_) => const UserTypeSelectionScreen(),
            );
          case '/register':
            final isDriver = settings.arguments as bool? ?? false;
            return CupertinoPageRoute(
              builder: (_) => RegisterScreen(isDriver: isDriver),
            );
          case '/home':
            return CupertinoPageRoute(builder: (_) => const MainScreen());
          case '/driver-main':
            return CupertinoPageRoute(builder: (_) => const DriverMainScreen());
          default:
            return CupertinoPageRoute(builder: (_) => const SplashScreen());
        }
      },
    );
  }
}
