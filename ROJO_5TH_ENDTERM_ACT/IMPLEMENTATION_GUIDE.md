# E-Commerce Application - Backend + Flutter

A production-ready E-Commerce application with PHP REST API backend and Flutter mobile frontend.

## 📋 Project Structure

```
ROJO_5TH_ENDTERM_ACT/
├── database_schema.sql          # MySQL database schema
├── php-backend/                 # PHP REST API
│   ├── config/                  # Configuration files
│   ├── middleware/              # Auth middleware
│   ├── controllers/             # API controllers
│   ├── models/                  # Database models
│   ├── utils/                   # Utilities (Response, Validator)
│   ├── api/
│   │   └── index.php            # API router entry point
│   ├── .env.example             # Environment variables template
│   └── .htaccess                # URL rewriting rules
└── fifth_activity/              # Flutter mobile app
    ├── lib/
    │   ├── config/              # Firebase & app configuration
    │   ├── screens/             # App screens
    │   ├── models/              # Data models
    │   ├── services/            # API, Firebase, storage services
    │   ├── providers/           # State management (Provider)
    │   ├── widgets/             # Reusable UI components
    │   ├── utils/               # Constants, validators, theme
    │   └── main.dart            # App entry point
    ├── pubspec.yaml             # Flutter dependencies
    └── README.md                # App-specific documentation
```

## 🗄️ Database Setup

### Requirements
- MySQL 5.7+
- PHP 7.4+
- Flutter 3.10+

### Creating the Database

1. Open MySQL client
2. Run the SQL schema:
```bash
mysql -u root -p < database_schema.sql
```

3. Verify tables:
```sql
USE ecommerce_db;
SHOW TABLES;
```

## 🔧 PHP Backend Setup

### Installation

1. Navigate to backend directory:
```bash
cd php-backend
```

2. Copy environment file:
```bash
cp .env.example .env
```

3. Update `.env` with your database credentials:
```env
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=ecommerce_db

FIREBASE_PROJECT_ID=your-firebase-project-id
FIREBASE_API_KEY=your-firebase-api-key
```

4. Generate Firebase credentials:
   - Go to Firebase Console
   - Create service account JSON file
   - Save as `firebase-credentials.json` in php-backend directory

### Running the API

Using PHP built-in server:
```bash
php -S localhost:8000 -t . api/index.php
```

Or use Apache/Nginx with the provided `.htaccess`.

### API Endpoints

#### Authentication
```
POST   /api/auth/register          # Register new user
POST   /api/auth/login             # Login with Firebase token
POST   /api/auth/refresh-token     # Refresh token
POST   /api/auth/forgot-password   # Password reset
GET    /api/auth/me                # Get current user
```

#### Products
```
GET    /api/products               # List products (paginated)
GET    /api/products/{id}          # Get product details
POST   /api/products               # Create product (seller)
PUT    /api/products/{id}          # Update product (seller)
DELETE /api/products/{id}          # Delete product (seller)
GET    /api/sellers/{id}/products  # Products by seller
```

#### Cart
```
GET    /api/cart                   # Get user's cart
POST   /api/cart/items             # Add item to cart
PUT    /api/cart/items/{id}        # Update item quantity
DELETE /api/cart/items/{id}        # Remove item
DELETE /api/cart                   # Clear cart
```

#### Orders
```
POST   /api/orders                 # Create order
GET    /api/orders                 # Get user's orders
GET    /api/orders/{id}            # Get order details
PUT    /api/orders/{id}/status     # Update order status
GET    /api/seller/orders          # Get seller's orders
```

#### Reviews
```
POST   /api/products/{id}/reviews  # Add review
GET    /api/products/{id}/reviews  # Get product reviews
DELETE /api/reviews/{id}           # Delete review
```

### Example API Request

```bash
curl -X POST http://localhost:8000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "firebase_token": "your_firebase_id_token"
  }'
```

## 📱 Flutter App Setup

### Requirements
- Flutter SDK 3.10+
- Android Studio / Xcode (for native development)
- Firebase project

### Installation

1. Navigate to Flutter project:
```bash
cd fifth_activity
```

2. Get dependencies:
```bash
flutter pub get
```

3. Configure Firebase:
```bash
flutterfire configure
```

   This will:
   - Create `firebase_options.dart` with your Firebase credentials
   - Update `google-services.json` (Android)
   - Update `GoogleService-Info.plist` (iOS)

4. Update API base URL in `lib/utils/constants.dart`:
```dart
static const String apiBaseUrl = 'http://your-api-url/api';
```

### Running the App

#### Android
```bash
flutter run
```

#### iOS
```bash
flutter run -d iPhone
```

#### Web (development only)
```bash
flutter run -d chrome
```

## 🔐 Authentication Flow

### Registration
1. User enters details (email, password, name, phone, role)
2. Firebase creates auth account
3. Backend stores user in MySQL with Firebase UID
4. User receives Firebase token
5. Token stored locally for subsequent requests

### Login
1. User enters email & password
2. Firebase authenticates user
3. Firebase returns ID token
4. Backend verifies token and returns user data
5. Token stored locally

### Role-Based Access
- **Admin**: Full system access
- **Seller**: Can create/manage products, view orders
- **Buyer**: Can browse products, create orders, leave reviews

## 📦 State Management (Provider)

### Providers Available

1. **AuthProvider** - Authentication state
   ```dart
   Future<bool> register(...);
   Future<bool> login(email, password);
   Future<void> logout();
   ```

2. **ProductProvider** - Products management
   ```dart
   Future<void> getProducts({page, category});
   Future<bool> createProduct(...);
   Future<bool> updateProduct(...);
   Future<bool> deleteProduct(id);
   ```

3. **CartProvider** - Shopping cart
   ```dart
   Future<void> getCart();
   Future<bool> addItem(productId, quantity);
   Future<bool> updateItemQuantity(itemId, quantity);
   Future<bool> removeItem(itemId);
   ```

4. **OrderProvider** - Orders management
   ```dart
   Future<void> getOrders({page});
   Future<bool> createOrder(...);
   Future<bool> updateOrderStatus(orderId, status);
   ```

5. **UserProvider** - User profile
   ```dart
   Future<bool> updateProfile(...);
   ```

## 🔥 Firebase Integration

### Required Setup

1. **Authentication**
   - Enable Email/Password authentication
   - Set up password reset email template

2. **Storage**
   - Create storage bucket
   - Set up rules to allow authenticated users to upload

3. **Cloud Messaging (FCM)**
   - Enable Cloud Messaging service
   - Download service account key for push notifications

### Initialization

The app initializes Firebase in `lib/config/firebase_config.dart`:

```dart
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
await FCMService.initFCM();
```

## 🎨 Theming & UI

### Color Scheme
- **Primary**: Indigo (#6366F1)
- **Accent**: Emerald (#10B981)
- **Error**: Red (#EF4444)
- **Background**: Light Gray (#FAFAFA)

### Components
- Custom button with loading state
- Product card with image & rating
- Cart item widget with quantity controls
- Order status badge with color coding

## 📧 Push Notifications

Firebase Cloud Messaging (FCM) handles push notifications:

1. **Order Confirmation** - Sent to buyer after order creation
2. **Order Status Updates** - Sent when seller updates order status
3. **Product Alerts** - Sent for price drops, new products

## 🛡️ Security Features

### Backend
- Firebase token verification on every authenticated endpoint
- Role-based access control (RBAC)
- SQL prepared statements to prevent injection
- HTTP-only cookies for session management
- CORS headers configured
- Input validation on all endpoints

### Frontend
- Local storage with shared_preferences
- Firebase Auth handles password security
- Token expiration handling
- Network request timeout
- Input validation before submission

## 📊 Database Relationships

```
Users (1) ──→ (Many) Products
       ├──→ (1) Carts
       ├──→ (Many) Orders
       └──→ (Many) Reviews

Products (1) ──→ (Many) Cart Items
        ├──→ (Many) Order Items
        └──→ (Many) Reviews

Orders (1) ──→ (Many) Order Items
```

## 🚀 Deployment

### Backend (PHP)
1. Set up Linux server with Apache/Nginx
2. Install PHP 7.4+ and MySQL
3. Upload PHP files
4. Configure `.env` with production credentials
5. Set proper file permissions
6. Enable HTTPS (SSL/TLS)

### Flutter App
1. Build production APK:
   ```bash
   flutter build apk --release
   ```

2. Build production IPA:
   ```bash
   flutter build ios --release
   ```

3. Upload to Google Play Store / Apple App Store

## 📝 Notes

- The backend is designed for easy local development with PHP built-in server
- For production, use Apache/Nginx with proper SSL configuration
- The Flutter app uses Provider for state management (beginner-friendly)
- All API responses follow a consistent JSON format
- The database uses InnoDB with proper indexing for performance

## 📚 Additional Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Firebase Documentation](https://firebase.google.com/docs)
- [PHP MySQL Documentation](https://www.php.net/manual/en/book.mysqli.php)
- [REST API Best Practices](https://restfulapi.net/)

## ✅ Checklist Before Going Live

- [ ] Configure Firebase with production credentials
- [ ] Update API base URL for production
- [ ] Enable HTTPS for API
- [ ] Set up database backups
- [ ] Configure FCM server key
- [ ] Test authentication flow completely
- [ ] Verify all API endpoints
- [ ] Test payment gateway integration (if added)
- [ ] Set up error logging
- [ ] Performance optimization
- [ ] Security audit
- [ ] Load testing

## 🤝 Contributing

Follow these guidelines:
1. Create feature branches
2. Write clean, documented code
3. Test thoroughly before pushing
4. Follow the existing code style
5. Update documentation as needed

## 📄 License

This project is provided as-is for educational purposes.
