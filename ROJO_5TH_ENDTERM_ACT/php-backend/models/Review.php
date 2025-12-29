<?php

class Review {
    private $db;
    private $table = 'reviews';

    public function __construct($db) {
        $this->db = $db;
    }

    /**
     * Create new review
     */
    public function create($productId, $buyerId, $rating, $comment) {
        $query = "INSERT INTO {$this->table} (product_id, buyer_id, rating, comment) 
                  VALUES (?, ?, ?, ?)";

        $stmt = $this->db->prepare($query);
        $stmt->bind_param('iis', $productId, $buyerId, $comment);
        
        // Binding rating separately since it's an integer
        $stmt->bind_param('iiss', $productId, $buyerId, $rating, $comment);

        return $stmt->execute();
    }

    /**
     * Get reviews by product
     */
    public function getByProductId($productId, $limit = 20, $offset = 0) {
        $query = "SELECT r.*, u.full_name, u.profile_image_url
                  FROM {$this->table} r
                  JOIN users u ON r.buyer_id = u.id
                  WHERE r.product_id = ?
                  ORDER BY r.created_at DESC
                  LIMIT ? OFFSET ?";

        $stmt = $this->db->prepare($query);
        $stmt->bind_param('iii', $productId, $limit, $offset);
        $stmt->execute();
        return $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
    }

    /**
     * Get review by product and buyer
     */
    public function getByProductAndBuyer($productId, $buyerId) {
        $query = "SELECT * FROM {$this->table} WHERE product_id = ? AND buyer_id = ?";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param('ii', $productId, $buyerId);
        $stmt->execute();
        return $stmt->get_result()->fetch_assoc();
    }

    /**
     * Delete review
     */
    public function delete($id) {
        $query = "DELETE FROM {$this->table} WHERE id = ?";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param('i', $id);
        return $stmt->execute();
    }

    /**
     * Get average rating and count
     */
    public function getProductRating($productId) {
        $query = "SELECT AVG(rating) as average_rating, COUNT(*) as total_reviews
                  FROM {$this->table}
                  WHERE product_id = ?";

        $stmt = $this->db->prepare($query);
        $stmt->bind_param('i', $productId);
        $stmt->execute();
        return $stmt->get_result()->fetch_assoc();
    }
}
