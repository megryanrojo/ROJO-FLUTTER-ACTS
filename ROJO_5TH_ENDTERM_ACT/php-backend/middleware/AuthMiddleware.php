<?php

class AuthMiddleware {
    private $firebaseConfig;

    public function __construct() {
        $this->firebaseConfig = FirebaseConfig::getInstance();
    }

    /**
     * Verify Firebase ID Token from Authorization header
     */
    public function verify() {
        $headers = getallheaders();
        $authHeader = $headers['Authorization'] ?? null;

        if (!$authHeader) {
            Response::unauthorized('Missing Authorization header');
        }

        // Extract token from "Bearer {token}" format
        $token = str_replace('Bearer ', '', $authHeader);

        // Verify token
        $payload = $this->firebaseConfig->verifyIdToken($token);

        if (!$payload) {
            Response::unauthorized('Invalid or expired token');
        }

        return $payload;
    }

    /**
     * Get authenticated user's Firebase UID
     */
    public function getUid() {
        $payload = $this->verify();
        return $payload['sub'] ?? $payload['uid'] ?? null;
    }

    /**
     * Check if user has required role
     */
    public function requireRole($userId, $requiredRole, $db) {
        $query = "SELECT role FROM users WHERE id = ? AND status = ?";
        $stmt = $db->prepare($query);
        $stmt->bind_param('is', $userId, Constants::STATUS_ACTIVE);
        $stmt->execute();
        $result = $stmt->get_result();
        $user = $result->fetch_assoc();

        if (!$user || $user['role'] !== $requiredRole) {
            Response::forbidden('You do not have permission to access this resource');
        }

        return true;
    }
}
