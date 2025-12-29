<?php

// Optional: Composer autoload for Firebase Admin SDK
if (file_exists(__DIR__ . '/../vendor/autoload.php')) {
    require_once __DIR__ . '/../vendor/autoload.php';
}

class FirebaseConfig {
    private static $instance = null;
    private $auth;
    private $projectId;

    private function __construct() {
        $this->projectId = getenv('FIREBASE_PROJECT_ID');
        
        // Load Firebase credentials
        $credentialsPath = getenv('FIREBASE_CREDENTIALS_PATH');
        if ($credentialsPath && file_exists($credentialsPath)) {
            $credentials = json_decode(file_get_contents($credentialsPath), true);
            // Initialize Firebase Auth here if using Firebase Admin SDK
        }
    }

    public static function getInstance() {
        if (self::$instance === null) {
            self::$instance = new self();
        }
        return self::$instance;
    }

    public function getProjectId() {
        return $this->projectId;
    }

    /**
     * Verify Firebase ID Token
     * Note: This requires Firebase Admin SDK or a verification service
     * For a basic implementation, you would verify the token's signature
     */
    public function verifyIdToken($token) {
        try {
            // Remove "Bearer " prefix if present
            if (strpos($token, 'Bearer ') === 0) {
                $token = substr($token, 7);
            }

            // Decode JWT token without verification (for development)
            // In production, use Firebase Admin SDK to verify the signature
            $parts = explode('.', $token);
            
            if (count($parts) !== 3) {
                throw new Exception('Invalid token format');
            }

            $payload = json_decode(base64_decode($parts[1]), true);
            
            if (!$payload) {
                throw new Exception('Invalid token payload');
            }

            return $payload;
        } catch (Exception $e) {
            return null;
        }
    }

    /**
     * Extract Firebase UID from token
     */
    public function getUidFromToken($token) {
        $payload = $this->verifyIdToken($token);
        return $payload['sub'] ?? $payload['uid'] ?? null;
    }
}
