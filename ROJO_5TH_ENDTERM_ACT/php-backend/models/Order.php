<?php

class Order {
    private $db;
    private $table = 'orders';
    private $itemsTable = 'order_items';

    public function __construct($db) {
        $this->db = $db;
    }

    /**
     * Create new order
     */
    public function create($buyerId, $totalAmount, $shippingAddress, $shippingCity, $shippingZip, $notes = null) {
        $orderNumber = 'ORD-' . time() . '-' . mt_rand(1000, 9999);
        $status = Constants::ORDER_PENDING;

        $query = "INSERT INTO {$this->table} 
                  (buyer_id, order_number, total_amount, status, shipping_address, shipping_city, shipping_zip, notes) 
                  VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        $stmt = $this->db->prepare($query);
        $stmt->bind_param(
            'isdsssss',
            $buyerId,
            $orderNumber,
            $totalAmount,
            $status,
            $shippingAddress,
            $shippingCity,
            $shippingZip,
            $notes
        );

        if ($stmt->execute()) {
            return $this->db->insert_id;
        }
        return null;
    }

    /**
     * Get order by ID
     */
    public function getById($id) {
        $query = "SELECT * FROM {$this->table} WHERE id = ?";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param('i', $id);
        $stmt->execute();
        return $stmt->get_result()->fetch_assoc();
    }

    /**
     * Get orders by buyer
     */
    public function getByBuyerId($buyerId, $limit = 20, $offset = 0) {
        $query = "SELECT * FROM {$this->table} 
                  WHERE buyer_id = ? 
                  ORDER BY created_at DESC 
                  LIMIT ? OFFSET ?";

        $stmt = $this->db->prepare($query);
        $stmt->bind_param('iii', $buyerId, $limit, $offset);
        $stmt->execute();
        return $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
    }

    /**
     * Get order items
     */
    public function getItems($orderId) {
        $query = "SELECT oi.*, p.name as product_name, p.image_url 
                  FROM {$this->itemsTable} oi
                  JOIN products p ON oi.product_id = p.id
                  WHERE oi.order_id = ?";

        $stmt = $this->db->prepare($query);
        $stmt->bind_param('i', $orderId);
        $stmt->execute();
        return $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
    }

    /**
     * Add item to order
     */
    public function addItem($orderId, $productId, $sellerId, $quantity, $unitPrice) {
        $subtotal = $quantity * $unitPrice;

        $query = "INSERT INTO {$this->itemsTable} 
                  (order_id, product_id, seller_id, quantity, unit_price, subtotal) 
                  VALUES (?, ?, ?, ?, ?, ?)";

        $stmt = $this->db->prepare($query);
        $stmt->bind_param(
            'iiiidd',
            $orderId,
            $productId,
            $sellerId,
            $quantity,
            $unitPrice,
            $subtotal
        );

        return $stmt->execute();
    }

    /**
     * Update order status
     */
    public function updateStatus($id, $status) {
        $query = "UPDATE {$this->table} SET status = ? WHERE id = ?";
        $stmt = $this->db->prepare($query);
        $stmt->bind_param('si', $status, $id);
        return $stmt->execute();
    }

    /**
     * Get orders for seller (orders containing seller's products)
     */
    public function getSellerOrders($sellerId, $limit = 20, $offset = 0) {
        $query = "SELECT DISTINCT o.* FROM {$this->table} o
                  JOIN {$this->itemsTable} oi ON o.id = oi.order_id
                  WHERE oi.seller_id = ?
                  ORDER BY o.created_at DESC
                  LIMIT ? OFFSET ?";

        $stmt = $this->db->prepare($query);
        $stmt->bind_param('iii', $sellerId, $limit, $offset);
        $stmt->execute();
        return $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
    }

    /**
     * Get seller's items in an order
     */
    public function getSellerOrderItems($orderId, $sellerId) {
        $query = "SELECT oi.*, p.name as product_name, p.image_url
                  FROM {$this->itemsTable} oi
                  JOIN products p ON oi.product_id = p.id
                  WHERE oi.order_id = ? AND oi.seller_id = ?";

        $stmt = $this->db->prepare($query);
        $stmt->bind_param('ii', $orderId, $sellerId);
        $stmt->execute();
        return $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
    }
}
