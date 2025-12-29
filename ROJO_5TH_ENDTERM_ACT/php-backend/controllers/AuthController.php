<?php

class AuthController {
    private $db;
    private $userModel;
    private $firebaseConfig;
    private $authMiddleware;

    public function __construct($db) {
        $this->db = $db;
        $this->userModel = new User($db);
        $this->firebaseConfig = FirebaseConfig::getInstance();
        $this->authMiddleware = new AuthMiddleware();
    }

    /**
     * Register new user
     * POST /api/auth/register
     */
    public function register() {
        // Validate input
        $input = json_decode(file_get_contents('php://input'), true);
        
        $rules = [
            'email' => 'required|email',
            'full_name' => 'required|min:3',
            'phone' => 'required',
            'firebase_uid' => 'required',
            'role' => 'required'
        ];

        if (!Validator::validate($input, $rules)) {
            Response::validationError(Validator::errors(), 'Validation failed', 422);
        }

        // Check if user already exists
        if ($this->userModel->exists($input['firebase_uid'])) {
            Response::error('User already exists', 409);
        }

        // Create user
        $role = in_array($input['role'], [Constants::ROLE_ADMIN, Constants::ROLE_SELLER, Constants::ROLE_BUYER])
            ? $input['role']
            : Constants::ROLE_BUYER;

        if ($this->userModel->create(
            $input['firebase_uid'],
            $input['email'],
            $input['full_name'],
            $input['phone'],
            $role
        )) {
            $user = $this->userModel->getByFirebaseUid($input['firebase_uid']);
            Response::success($user, 'User registered successfully', 201);
        } else {
            Response::error('Failed to register user', 500);
        }
    }

    /**
     * Login user (verify Firebase token)
     * POST /api/auth/login
     */
    public function login() {
        $input = json_decode(file_get_contents('php://input'), true);

        if (!isset($input['firebase_token'])) {
            Response::error('Firebase token is required', 400);
        }

        // Verify Firebase token
        $payload = $this->firebaseConfig->verifyIdToken($input['firebase_token']);
        
        if (!$payload) {
            Response::unauthorized('Invalid or expired token');
        }

        $firebaseUid = $payload['sub'] ?? $payload['uid'];

        // Get user from database
        $user = $this->userModel->getByFirebaseUid($firebaseUid);

        if (!$user) {
            Response::notFound('User not found');
        }

        if ($user['status'] !== Constants::STATUS_ACTIVE) {
            Response::error('User account is not active', 403);
        }

        // Return user data with token
        Response::success([
            'user' => $user,
            'token' => $input['firebase_token']
        ], 'Login successful');
    }

    /**
     * Refresh Firebase token
     * POST /api/auth/refresh-token
     */
    public function refreshToken() {
        $headers = getallheaders();
        $authHeader = $headers['Authorization'] ?? null;

        if (!$authHeader) {
            Response::unauthorized('Missing Authorization header');
        }

        $token = str_replace('Bearer ', '', $authHeader);
        $payload = $this->firebaseConfig->verifyIdToken($token);

        if (!$payload) {
            Response::unauthorized('Invalid or expired token');
        }

        Response::success(['token' => $token], 'Token is valid');
    }

    /**
     * Forgot password (Firebase handles this)
     * POST /api/auth/forgot-password
     */
    public function forgotPassword() {
        $input = json_decode(file_get_contents('php://input'), true);

        if (!isset($input['email'])) {
            Response::error('Email is required', 400);
        }

        // Check if user exists
        $user = $this->userModel->getByEmail($input['email']);

        if (!$user) {
            // Return success to prevent user enumeration
            Response::success(['message' => 'Check your email for password reset link']);
        }

        // Firebase sends email directly in frontend
        Response::success(['message' => 'Check your email for password reset link']);
    }

    /**
     * Get current user
     * GET /api/auth/me
     */
    public function getCurrentUser() {
        try {
            $payload = $this->authMiddleware->verify();
            $firebaseUid = $payload['sub'] ?? $payload['uid'];

            $user = $this->userModel->getByFirebaseUid($firebaseUid);

            if (!$user) {
                Response::notFound('User not found');
            }

            Response::success($user, 'User fetched successfully');
        } catch (Exception $e) {
            Response::unauthorized($e->getMessage());
        }
    }
}
