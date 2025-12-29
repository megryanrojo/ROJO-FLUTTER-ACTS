class AppConstants {
  // API
  static const String apiBaseUrl = 'http://localhost:8000/api';

  // User Roles
  static const String roleAdmin = 'admin';
  static const String roleSeller = 'seller';
  static const String roleBuyer = 'buyer';

  // Order Status
  static const String orderPending = 'pending';
  static const String orderConfirmed = 'confirmed';
  static const String orderShipped = 'shipped';
  static const String orderDelivered = 'delivered';
  static const String orderCancelled = 'cancelled';

  // Product Status
  static const String productActive = 'active';
  static const String productInactive = 'inactive';
  static const String productDeleted = 'deleted';

  // Pagination
  static const int pageSize = 20;

  // App Strings
  static const String appName = 'E-Commerce Shop';
  static const String appVersion = '1.0.0';

  // Validation
  static const int minPasswordLength = 6;
  static const int maxNameLength = 255;
}
