<?php

class Cart {
    private $db;
    private $table = 'carts';
    private $itemsTable = 'cart_items';

    public function __construct($db) {
        $this->db = $db;
    }

    /**
     * Create cart for user
     */
    public function createForUser($userId) {
        $query = "INSERT INTO {$this->table} (user_id) VALUES (?)";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param('i', $userId);
        return $stmt->execute();
    }

    /**
     * Get user's cart
     */
    public function getByUserId($userId) {
        $query = "SELECT * FROM {$this->table} WHERE user_id = ?";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param('i', $userId);
        $stmt->execute();
        $result = $stmt->get_result();
        return $result->fetch_assoc();
    }

    /**
     * Get cart items with product details
     */
    public function getItems($cartId) {
        $query = "SELECT ci.id, ci.product_id, ci.quantity, 
                         p.id, p.name, p.price, p.image_url, p.seller_id, p.stock_quantity
                  FROM {$this->itemsTable} ci
                  JOIN products p ON ci.product_id = p.id
                  WHERE ci.cart_id = ?";

        $stmt = $this->db->prepare($query);
        $stmt->bind_param('i', $cartId);
        $stmt->execute();
        return $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
    }

    /**
     * Add item to cart
     */
    public function addItem($cartId, $productId, $quantity = 1) {
        // Check if item already exists
        $checkQuery = "SELECT id, quantity FROM {$this->itemsTable} WHERE cart_id = ? AND product_id = ?";
        $stmt = $this->db->prepare($checkQuery);
        $stmt->bind_param('ii', $cartId, $productId);
        $stmt->execute();
        $existing = $stmt->get_result()->fetch_assoc();

        if ($existing) {
            // Update quantity
            $newQuantity = $existing['quantity'] + $quantity;
            $updateQuery = "UPDATE {$this->itemsTable} SET quantity = ? WHERE id = ?";
            $updateStmt = $this->db->prepare($updateQuery);
            $updateStmt->bind_param('ii', $newQuantity, $existing['id']);
            return $updateStmt->execute();
        } else {
            // Insert new item
            $insertQuery = "INSERT INTO {$this->itemsTable} (cart_id, product_id, quantity) VALUES (?, ?, ?)";
            $insertStmt = $this->db->prepare($insertQuery);
            $insertStmt->bind_param('iii', $cartId, $productId, $quantity);
            return $insertStmt->execute();
        }
    }

    /**
     * Update item quantity
     */
    public function updateItemQuantity($itemId, $quantity) {
        $query = "UPDATE {$this->itemsTable} SET quantity = ? WHERE id = ?";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param('ii', $quantity, $itemId);
        return $stmt->execute();
    }

    /**
     * Remove item from cart
     */
    public function removeItem($itemId) {
        $query = "DELETE FROM {$this->itemsTable} WHERE id = ?";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param('i', $itemId);
        return $stmt->execute();
    }

    /**
     * Clear cart
     */
    public function clear($cartId) {
        $query = "DELETE FROM {$this->itemsTable} WHERE cart_id = ?";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param('i', $cartId);
        return $stmt->execute();
    }

    /**
     * Get cart total
     */
    public function getTotal($cartId) {
        $query = "SELECT SUM(p.price * ci.quantity) as total
                  FROM {$this->itemsTable} ci
                  JOIN products p ON ci.product_id = p.id
                  WHERE ci.cart_id = ?";

        $stmt = $this->db->prepare($query);
        $stmt->bind_param('i', $cartId);
        $stmt->execute();
        $result = $stmt->get_result()->fetch_assoc();
        return $result['total'] ?? 0;
    }
}
