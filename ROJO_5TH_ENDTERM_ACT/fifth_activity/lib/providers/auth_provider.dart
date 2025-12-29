import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/firebase_auth_service.dart';
import '../services/api_service.dart';
import '../services/local_storage_service.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  // Register
  Future<bool> register({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String role,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Firebase registration
      final userCredential = await FirebaseAuthService.registerUser(email, password);
      final firebaseUid = userCredential.user?.uid ?? '';
      final token = await FirebaseAuthService.getIdToken();

      // API registration
      final response = await ApiService.post('auth/register', {
        'email': email,
        'full_name': fullName,
        'phone': phone,
        'firebase_uid': firebaseUid,
        'role': role,
      });

      if (response.isSuccess && response.data != null) {
        _user = User.fromJson(response.data);
        await LocalStorageService.saveUser(_user!);
        await LocalStorageService.saveToken(token ?? '');
        await ApiService.saveAuthToken(token ?? '');
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response.message;
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Login
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Firebase login
      final userCredential = await FirebaseAuthService.loginUser(email, password);
      final token = await FirebaseAuthService.getIdToken();

      // API login
      final response = await ApiService.post('auth/login', {
        'firebase_token': token,
      });

      if (response.isSuccess && response.data != null) {
        _user = User.fromJson(response.data['user']);
        await LocalStorageService.saveUser(_user!);
        await LocalStorageService.saveToken(token ?? '');
        await ApiService.saveAuthToken(token ?? '');
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response.message;
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await FirebaseAuthService.logout();
      await LocalStorageService.clearAll();
      _user = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Load user from local storage
  Future<void> loadUserFromStorage() async {
    try {
      final user = await LocalStorageService.getUser();
      _user = user;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Forgot password
  Future<bool> forgotPassword(String email) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await FirebaseAuthService.sendPasswordResetEmail(email);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
