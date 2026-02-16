import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/mock_data.dart';

class AuthProvider extends ChangeNotifier {
  AppUser? _currentUser;
  bool _isLoggedIn = false;
  bool _isAdmin = false;
  bool _isLoading = false;

  AppUser? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  bool get isAdmin => _isAdmin;
  bool get isLoading => _isLoading;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));

    // Mock login
    if (email.isNotEmpty && password.isNotEmpty) {
      _currentUser = MockData.users.first;
      _isLoggedIn = true;
      _isAdmin = false;
      _isLoading = false;
      notifyListeners();
      return true;
    }
    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> adminLogin(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));

    if (email == 'admin@newsportal.com' && password == 'admin123') {
      _currentUser = MockData.users.firstWhere((u) => u.isAdmin);
      _isLoggedIn = true;
      _isAdmin = true;
      _isLoading = false;
      notifyListeners();
      return true;
    }
    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));

    _currentUser = AppUser(
      id: 'new_user',
      name: name,
      email: email,
      avatarUrl: 'https://i.pravatar.cc/150?img=70',
      joinedAt: DateTime.now(),
    );
    _isLoggedIn = true;
    _isAdmin = false;
    _isLoading = false;
    notifyListeners();
    return true;
  }

  void logout() {
    _currentUser = null;
    _isLoggedIn = false;
    _isAdmin = false;
    notifyListeners();
  }

  Future<void> forgotPassword(String email) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    _isLoading = false;
    notifyListeners();
  }
}
