<?php

class User {
    private $db;
    private $table = 'users';

    public function __construct($db) {
        $this->db = $db;
    }

    /**
     * Create new user
     */
    public function create($firebaseUid, $email, $fullName, $phone, $role = 'buyer') {
        $query = "INSERT INTO {$this->table} 
                  (firebase_uid, email, full_name, phone, role, status) 
                  VALUES (?, ?, ?, ?, ?, ?)";

        $stmt = $this->db->prepare($query);
        $status = Constants::STATUS_ACTIVE;

        $stmt->bind_param(
            'ssssss',
            $firebaseUid,
            $email,
            $fullName,
            $phone,
            $role,
            $status
        );

        return $stmt->execute();
    }

    /**
     * Get user by Firebase UID
     */
    public function getByFirebaseUid($firebaseUid) {
        $query = "SELECT * FROM {$this->table} WHERE firebase_uid = ?";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param('s', $firebaseUid);
        $stmt->execute();
        $result = $stmt->get_result();
        return $result->fetch_assoc();
    }

    /**
     * Get user by ID
     */
    public function getById($id) {
        $query = "SELECT * FROM {$this->table} WHERE id = ?";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param('i', $id);
        $stmt->execute();
        $result = $stmt->get_result();
        return $result->fetch_assoc();
    }

    /**
     * Get user by email
     */
    public function getByEmail($email) {
        $query = "SELECT * FROM {$this->table} WHERE email = ?";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param('s', $email);
        $stmt->execute();
        $result = $stmt->get_result();
        return $result->fetch_assoc();
    }

    /**
     * Update user profile
     */
    public function updateProfile($id, $fullName, $phone, $profileImageUrl = null) {
        if ($profileImageUrl) {
            $query = "UPDATE {$this->table} 
                      SET full_name = ?, phone = ?, profile_image_url = ? 
                      WHERE id = ?";
            $stmt = $this->db->prepare($query);
            $stmt->bind_param('sssi', $fullName, $phone, $profileImageUrl, $id);
        } else {
            $query = "UPDATE {$this->table} 
                      SET full_name = ?, phone = ? 
                      WHERE id = ?";
            $stmt = $this->db->prepare($query);
            $stmt->bind_param('ssi', $fullName, $phone, $id);
        }

        return $stmt->execute();
    }

    /**
     * Get sellers list
     */
    public function getSellers($limit = 20, $offset = 0) {
        $query = "SELECT id, full_name, profile_image_url, created_at 
                  FROM {$this->table} 
                  WHERE role = ? AND status = ? 
                  LIMIT ? OFFSET ?";

        $stmt = $this->db->prepare($query);
        $role = Constants::ROLE_SELLER;
        $status = Constants::STATUS_ACTIVE;
        $stmt->bind_param('ssii', $role, $status, $limit, $offset);
        $stmt->execute();
        return $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
    }

    /**
     * Check if user exists
     */
    public function exists($firebaseUid) {
        return $this->getByFirebaseUid($firebaseUid) !== null;
    }
}
