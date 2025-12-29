import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Set user
  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  // Update user profile
  Future<bool> updateProfile({
    required String fullName,
    required String phone,
    String? profileImageUrl,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final body = {
        'full_name': fullName,
        'phone': phone,
      };

      if (profileImageUrl != null) {
        body['profile_image_url'] = profileImageUrl;
      }

      final response = await ApiService.put(
        'users/${_user?.id}',
        body,
        requiresAuth: true,
      );

      if (response.isSuccess) {
        _user = _user?.copyWith(
          fullName: fullName,
          phone: phone,
          profileImageUrl: profileImageUrl,
        );
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

  // Clear user
  void clearUser() {
    _user = null;
    notifyListeners();
  }
}

extension UserExtension on User {
  User copyWith({
    int? id,
    String? firebaseUid,
    String? email,
    String? fullName,
    String? phone,
    String? profileImageUrl,
    String? role,
    String? status,
  }) {
    return User(
      id: id ?? this.id,
      firebaseUid: firebaseUid ?? this.firebaseUid,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      role: role ?? this.role,
      status: status ?? this.status,
    );
  }
}
