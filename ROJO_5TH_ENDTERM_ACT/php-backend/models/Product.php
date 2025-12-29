<?php

class Product {
    private $db;
    private $table = 'products';

    public function __construct($db) {
        $this->db = $db;
    }

    /**
     * Create new product
     */
    public function create($sellerId, $name, $description, $price, $stockQuantity, $imageUrl, $category) {
        $query = "INSERT INTO {$this->table} 
                  (seller_id, name, description, price, stock_quantity, image_url, category, status) 
                  VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        $stmt = $this->db->prepare($query);
        $status = Constants::PRODUCT_ACTIVE;

        $stmt->bind_param(
            'issdisss',
            $sellerId,
            $name,
            $description,
            $price,
            $stockQuantity,
            $imageUrl,
            $category,
            $status
        );

        return $stmt->execute();
    }

    /**
     * Get product by ID
     */
    public function getById($id) {
        $query = "SELECT * FROM {$this->table} WHERE id = ? AND status != ?";
        $stmt = $this->db->prepare($query);
        $status = Constants::PRODUCT_DELETED;
        $stmt->bind_param('is', $id, $status);
        $stmt->execute();
        $result = $stmt->get_result();
        return $result->fetch_assoc();
    }

    /**
     * Get all active products with pagination
     */
    public function getAll($limit = 20, $offset = 0, $category = null) {
        $query = "SELECT * FROM {$this->table} WHERE status = ?";
        
        if ($category) {
            $query .= " AND category = ?";
        }
        
        $query .= " ORDER BY created_at DESC LIMIT ? OFFSET ?";

        $stmt = $this->db->prepare($query);
        $status = Constants::PRODUCT_ACTIVE;

        if ($category) {
            $stmt->bind_param('ssii', $status, $category, $limit, $offset);
        } else {
            $stmt->bind_param('sii', $status, $limit, $offset);
        }

        $stmt->execute();
        return $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
    }

    /**
     * Get products by seller
     */
    public function getBySellerId($sellerId, $limit = 20, $offset = 0) {
        $query = "SELECT * FROM {$this->table} 
                  WHERE seller_id = ? AND status != ? 
                  ORDER BY created_at DESC 
                  LIMIT ? OFFSET ?";

        $stmt = $this->db->prepare($query);
        $status = Constants::PRODUCT_DELETED;
        $stmt->bind_param('isii', $sellerId, $status, $limit, $offset);
        $stmt->execute();
        return $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
    }

    /**
     * Update product
     */
    public function update($id, $name, $description, $price, $stockQuantity, $imageUrl = null, $category = null) {
        if ($imageUrl && $category) {
            $query = "UPDATE {$this->table} 
                      SET name = ?, description = ?, price = ?, stock_quantity = ?, image_url = ?, category = ? 
                      WHERE id = ?";
            $stmt = $this->db->prepare($query);
            $stmt->bind_param('ssdissi', $name, $description, $price, $stockQuantity, $imageUrl, $category, $id);
        } else {
            $query = "UPDATE {$this->table} 
                      SET name = ?, description = ?, price = ?, stock_quantity = ? 
                      WHERE id = ?";
            $stmt = $this->db->prepare($query);
            $stmt->bind_param('ssdii', $name, $description, $price, $stockQuantity, $id);
        }

        return $stmt->execute();
    }

    /**
     * Soft delete product
     */
    public function delete($id) {
        $query = "UPDATE {$this->table} SET status = ? WHERE id = ?";
        $stmt = $this->db->prepare($query);
        $status = Constants::PRODUCT_DELETED;
        $stmt->bind_param('si', $status, $id);
        return $stmt->execute();
    }

    /**
     * Decrease stock quantity
     */
    public function decreaseStock($id, $quantity) {
        $query = "UPDATE {$this->table} SET stock_quantity = stock_quantity - ? WHERE id = ? AND stock_quantity >= ?";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param('iii', $quantity, $id, $quantity);
        return $stmt->execute();
    }

    /**
     * Update rating
     */
    public function updateRating($id, $newRating, $totalReviews) {
        $query = "UPDATE {$this->table} SET rating = ?, total_reviews = ? WHERE id = ?";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param('dii', $newRating, $totalReviews, $id);
        return $stmt->execute();
    }
}
