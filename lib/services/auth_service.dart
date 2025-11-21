import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService extends ChangeNotifier {
  static const String _usersKey = 'registered_users';
  static const String _currentUserKey = 'current_user';
  static const String _isLoggedInKey = 'is_logged_in';

  User? _currentUser;
  bool _isLoggedIn = false;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  bool get isDriver => _currentUser?.isDriver ?? false;

  // Initialize and check if user is logged in
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;

    if (_isLoggedIn) {
      final userJson = prefs.getString(_currentUserKey);
      if (userJson != null) {
        _currentUser = User.fromJson(jsonDecode(userJson));
        notifyListeners();
      }
    }
  }

  // Register new user
  Future<Map<String, dynamic>> register(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Get existing users
      final List<User> users = await _getAllUsers();

      // Check if phone already exists
      final existingUser = users.firstWhere(
        (u) => u.phone == user.phone,
        orElse: () => User(
          id: '',
          name: '',
          phone: '',
          email: '',
          password: '',
          userType: UserType.passenger,
          createdAt: DateTime.now(),
        ),
      );

      if (existingUser.id.isNotEmpty) {
        return {
          'success': false,
          'message': 'رقم الهاتف مسجل مسبقاً',
        };
      }

      // Check if email already exists
      final existingEmail = users.firstWhere(
        (u) => u.email == user.email,
        orElse: () => User(
          id: '',
          name: '',
          phone: '',
          email: '',
          password: '',
          userType: UserType.passenger,
          createdAt: DateTime.now(),
        ),
      );

      if (existingEmail.id.isNotEmpty) {
        return {
          'success': false,
          'message': 'البريد الإلكتروني مسجل مسبقاً',
        };
      }

      // Add new user
      users.add(user);

      // Save users
      final usersJson = users.map((u) => u.toJson()).toList();
      await prefs.setString(_usersKey, jsonEncode(usersJson));

      return {
        'success': true,
        'message': 'تم إنشاء الحساب بنجاح',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'حدث خطأ أثناء إنشاء الحساب',
      };
    }
  }

  // Login with phone and password
  Future<Map<String, dynamic>> login(String phone, String password, bool isDriver) async {
    try {
      final users = await _getAllUsers();

      // Find user by phone
      final user = users.firstWhere(
        (u) => u.phone == phone,
        orElse: () => User(
          id: '',
          name: '',
          phone: '',
          email: '',
          password: '',
          userType: UserType.passenger,
          createdAt: DateTime.now(),
        ),
      );

      if (user.id.isEmpty) {
        return {
          'success': false,
          'message': 'رقم الهاتف غير مسجل',
        };
      }

      // Check password
      if (user.password != password) {
        return {
          'success': false,
          'message': 'كلمة المرور غير صحيحة',
        };
      }

      // Check user type
      final expectedUserType = isDriver ? UserType.driver : UserType.passenger;
      if (user.userType != expectedUserType) {
        return {
          'success': false,
          'message': isDriver
              ? 'هذا الحساب مسجل كراكب وليس سائق'
              : 'هذا الحساب مسجل كسائق وليس راكب',
        };
      }

      // Login successful
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_currentUserKey, jsonEncode(user.toJson()));
      await prefs.setBool(_isLoggedInKey, true);

      _currentUser = user;
      _isLoggedIn = true;
      notifyListeners();

      return {
        'success': true,
        'message': 'تم تسجيل الدخول بنجاح',
        'user': user,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'حدث خطأ أثناء تسجيل الدخول',
      };
    }
  }

  // Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
    await prefs.setBool(_isLoggedInKey, false);

    _currentUser = null;
    _isLoggedIn = false;
    notifyListeners();
  }

  // Get all registered users
  Future<List<User>> _getAllUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);

    if (usersJson == null || usersJson.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> usersList = jsonDecode(usersJson);
      return usersList.map((json) => User.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  // Update user profile
  Future<Map<String, dynamic>> updateProfile(User updatedUser) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final users = await _getAllUsers();

      final index = users.indexWhere((u) => u.id == updatedUser.id);
      if (index != -1) {
        users[index] = updatedUser;

        // Save updated users
        final usersJson = users.map((u) => u.toJson()).toList();
        await prefs.setString(_usersKey, jsonEncode(usersJson));

        // Update current user if it's the same
        if (_currentUser?.id == updatedUser.id) {
          _currentUser = updatedUser;
          await prefs.setString(_currentUserKey, jsonEncode(updatedUser.toJson()));
          notifyListeners();
        }

        return {
          'success': true,
          'message': 'تم تحديث البيانات بنجاح',
        };
      }

      return {
        'success': false,
        'message': 'المستخدم غير موجود',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'حدث خطأ أثناء التحديث',
      };
    }
  }

  // Delete account
  Future<Map<String, dynamic>> deleteAccount(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final users = await _getAllUsers();

      users.removeWhere((u) => u.id == userId);

      // Save updated users
      final usersJson = users.map((u) => u.toJson()).toList();
      await prefs.setString(_usersKey, jsonEncode(usersJson));

      // If deleting current user, logout
      if (_currentUser?.id == userId) {
        await logout();
      }

      return {
        'success': true,
        'message': 'تم حذف الحساب بنجاح',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'حدث خطأ أثناء حذف الحساب',
      };
    }
  }

  // Check if phone exists
  Future<bool> phoneExists(String phone) async {
    final users = await _getAllUsers();
    return users.any((u) => u.phone == phone);
  }

  // Check if email exists
  Future<bool> emailExists(String email) async {
    final users = await _getAllUsers();
    return users.any((u) => u.email == email);
  }
}
