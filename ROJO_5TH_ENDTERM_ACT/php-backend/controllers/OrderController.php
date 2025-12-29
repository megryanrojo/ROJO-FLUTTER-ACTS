<?php

class OrderController {
    private $db;
    private $orderModel;
    private $cartModel;
    private $productModel;
    private $authMiddleware;
    private $userModel;

    public function __construct($db) {
        $this->db = $db;
        $this->orderModel = new Order($db);
        $this->cartModel = new Cart($db);
        $this->productModel = new Product($db);
        $this->authMiddleware = new AuthMiddleware();
        $this->userModel = new User($db);
    }

    /**
     * Create order from cart
     * POST /api/orders
     */
    public function create() {
        try {
            $payload = $this->authMiddleware->verify();
            $firebaseUid = $payload['sub'] ?? $payload['uid'];
            $user = $this->userModel->getByFirebaseUid($firebaseUid);

            if (!$user) {
                Response::notFound('User not found');
            }

            $input = json_decode(file_get_contents('php://input'), true);

            $rules = [
                'shipping_address' => 'required',
                'shipping_city' => 'required',
                'shipping_zip' => 'required'
            ];

            if (!Validator::validate($input, $rules)) {
                Response::validationError(Validator::errors());
            }

            // Get cart
            $cart = $this->cartModel->getByUserId($user['id']);

            if (!$cart) {
                Response::error('Cart not found', 404);
            }

            $items = $this->cartModel->getItems($cart['id']);

            if (empty($items)) {
                Response::error('Cart is empty', 400);
            }

            // Calculate total
            $totalAmount = 0;
            foreach ($items as $item) {
                $totalAmount += $item['price'] * $item['quantity'];
            }

            // Create order
            $orderId = $this->orderModel->create(
                $user['id'],
                $totalAmount,
                $input['shipping_address'],
                $input['shipping_city'],
                $input['shipping_zip'],
                $input['notes'] ?? null
            );

            if (!$orderId) {
                Response::error('Failed to create order', 500);
            }

            // Add items to order and decrease stock
            foreach ($items as $item) {
                $this->orderModel->addItem(
                    $orderId,
                    $item['product_id'],
                    $item['seller_id'],
                    $item['quantity'],
                    $item['price']
                );

                // Decrease product stock
                $this->productModel->decreaseStock($item['product_id'], $item['quantity']);
            }

            // Clear cart
            $this->cartModel->clear($cart['id']);

            Response::success(
                ['order_id' => $orderId, 'total_amount' => $totalAmount],
                'Order created successfully',
                201
            );
        } catch (Exception $e) {
            Response::unauthorized('Authentication failed');
        }
    }

    /**
     * Get user's orders
     * GET /api/orders
     */
    public function getOrders() {
        try {
            $payload = $this->authMiddleware->verify();
            $firebaseUid = $payload['sub'] ?? $payload['uid'];
            $user = $this->userModel->getByFirebaseUid($firebaseUid);

            if (!$user) {
                Response::notFound('User not found');
            }

            $page = $_GET['page'] ?? Constants::DEFAULT_PAGE;
            $limit = Constants::DEFAULT_PAGE_SIZE;
            $offset = ($page - 1) * $limit;

            $orders = $this->orderModel->getByBuyerId($user['id'], $limit, $offset);

            Response::success([
                'orders' => $orders,
                'page' => $page,
                'limit' => $limit
            ], 'Orders fetched successfully');
        } catch (Exception $e) {
            Response::unauthorized('Authentication failed');
        }
    }

    /**
     * Get order details
     * GET /api/orders/{id}
     */
    public function getOrderDetails($orderId) {
        try {
            $payload = $this->authMiddleware->verify();
            $firebaseUid = $payload['sub'] ?? $payload['uid'];
            $user = $this->userModel->getByFirebaseUid($firebaseUid);

            if (!$user) {
                Response::notFound('User not found');
            }

            $order = $this->orderModel->getById($orderId);

            if (!$order) {
                Response::notFound('Order not found');
            }

            // Check if user is buyer or a seller with items in this order
            if ($order['buyer_id'] !== $user['id'] && $user['role'] !== Constants::ROLE_ADMIN) {
                Response::forbidden('You cannot access this order');
            }

            $items = $this->orderModel->getItems($orderId);

            Response::success([
                'order' => $order,
                'items' => $items
            ], 'Order details fetched successfully');
        } catch (Exception $e) {
            Response::unauthorized('Authentication failed');
        }
    }

    /**
     * Update order status (seller/admin only)
     * PUT /api/orders/{id}/status
     */
    public function updateStatus($orderId) {
        try {
            $payload = $this->authMiddleware->verify();
            $firebaseUid = $payload['sub'] ?? $payload['uid'];
            $user = $this->userModel->getByFirebaseUid($firebaseUid);

            if (!$user) {
                Response::notFound('User not found');
            }

            $input = json_decode(file_get_contents('php://input'), true);

            if (!isset($input['status'])) {
                Response::error('Status is required', 400);
            }

            $order = $this->orderModel->getById($orderId);

            if (!$order) {
                Response::notFound('Order not found');
            }

            // Check if user is admin or seller with items in this order
            if ($user['role'] !== Constants::ROLE_ADMIN) {
                $sellerItems = $this->orderModel->getSellerOrderItems($orderId, $user['id']);
                if (empty($sellerItems)) {
                    Response::forbidden('You cannot update this order');
                }
            }

            if ($this->orderModel->updateStatus($orderId, $input['status'])) {
                Response::success(null, 'Order status updated successfully');
            } else {
                Response::error('Failed to update order status', 500);
            }
        } catch (Exception $e) {
            Response::unauthorized('Authentication failed');
        }
    }

    /**
     * Get seller's orders
     * GET /api/seller/orders
     */
    public function getSellerOrders() {
        try {
            $payload = $this->authMiddleware->verify();
            $firebaseUid = $payload['sub'] ?? $payload['uid'];
            $user = $this->userModel->getByFirebaseUid($firebaseUid);

            if (!$user || $user['role'] !== Constants::ROLE_SELLER) {
                Response::forbidden('Only sellers can access this');
            }

            $page = $_GET['page'] ?? Constants::DEFAULT_PAGE;
            $limit = Constants::DEFAULT_PAGE_SIZE;
            $offset = ($page - 1) * $limit;

            $orders = $this->orderModel->getSellerOrders($user['id'], $limit, $offset);

            Response::success([
                'orders' => $orders,
                'page' => $page,
                'limit' => $limit
            ], 'Orders fetched successfully');
        } catch (Exception $e) {
            Response::unauthorized('Authentication failed');
        }
    }
}
