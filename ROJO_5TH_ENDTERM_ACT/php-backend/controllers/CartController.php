<?php

class CartController {
    private $db;
    private $cartModel;
    private $productModel;
    private $authMiddleware;
    private $userModel;

    public function __construct($db) {
        $this->db = $db;
        $this->cartModel = new Cart($db);
        $this->productModel = new Product($db);
        $this->authMiddleware = new AuthMiddleware();
        $this->userModel = new User($db);
    }

    /**
     * Get user's cart
     * GET /api/cart
     */
    public function getCart() {
        try {
            $payload = $this->authMiddleware->verify();
            $firebaseUid = $payload['sub'] ?? $payload['uid'];
            $user = $this->userModel->getByFirebaseUid($firebaseUid);

            if (!$user) {
                Response::notFound('User not found');
            }

            $cart = $this->cartModel->getByUserId($user['id']);

            if (!$cart) {
                // Create cart if doesn't exist
                $this->cartModel->createForUser($user['id']);
                $cart = $this->cartModel->getByUserId($user['id']);
            }

            $items = $this->cartModel->getItems($cart['id']);
            $total = $this->cartModel->getTotal($cart['id']);

            Response::success([
                'cart_id' => $cart['id'],
                'items' => $items,
                'total' => $total
            ], 'Cart fetched successfully');
        } catch (Exception $e) {
            Response::unauthorized('Authentication failed');
        }
    }

    /**
     * Add item to cart
     * POST /api/cart/items
     */
    public function addItem() {
        try {
            $payload = $this->authMiddleware->verify();
            $firebaseUid = $payload['sub'] ?? $payload['uid'];
            $user = $this->userModel->getByFirebaseUid($firebaseUid);

            if (!$user) {
                Response::notFound('User not found');
            }

            $input = json_decode(file_get_contents('php://input'), true);

            if (!isset($input['product_id']) || !isset($input['quantity'])) {
                Response::error('Product ID and quantity are required', 400);
            }

            // Check if product exists and has stock
            $product = $this->productModel->getById($input['product_id']);

            if (!$product) {
                Response::notFound('Product not found');
            }

            if ($product['stock_quantity'] < $input['quantity']) {
                Response::error('Insufficient stock', 409);
            }

            $cart = $this->cartModel->getByUserId($user['id']);

            if (!$cart) {
                $this->cartModel->createForUser($user['id']);
                $cart = $this->cartModel->getByUserId($user['id']);
            }

            if ($this->cartModel->addItem($cart['id'], $input['product_id'], $input['quantity'])) {
                Response::success(null, 'Item added to cart', 201);
            } else {
                Response::error('Failed to add item to cart', 500);
            }
        } catch (Exception $e) {
            Response::unauthorized('Authentication failed');
        }
    }

    /**
     * Update cart item quantity
     * PUT /api/cart/items/{id}
     */
    public function updateItem($itemId) {
        try {
            $payload = $this->authMiddleware->verify();
            $this->authMiddleware->getUid();

            $input = json_decode(file_get_contents('php://input'), true);

            if (!isset($input['quantity'])) {
                Response::error('Quantity is required', 400);
            }

            if ($this->cartModel->updateItemQuantity($itemId, $input['quantity'])) {
                Response::success(null, 'Item updated successfully');
            } else {
                Response::error('Failed to update item', 500);
            }
        } catch (Exception $e) {
            Response::unauthorized('Authentication failed');
        }
    }

    /**
     * Remove item from cart
     * DELETE /api/cart/items/{id}
     */
    public function removeItem($itemId) {
        try {
            $payload = $this->authMiddleware->verify();
            $this->authMiddleware->getUid();

            if ($this->cartModel->removeItem($itemId)) {
                Response::success(null, 'Item removed from cart');
            } else {
                Response::error('Failed to remove item', 500);
            }
        } catch (Exception $e) {
            Response::unauthorized('Authentication failed');
        }
    }

    /**
     * Clear cart
     * DELETE /api/cart
     */
    public function clearCart() {
        try {
            $payload = $this->authMiddleware->verify();
            $firebaseUid = $payload['sub'] ?? $payload['uid'];
            $user = $this->userModel->getByFirebaseUid($firebaseUid);

            if (!$user) {
                Response::notFound('User not found');
            }

            $cart = $this->cartModel->getByUserId($user['id']);

            if ($cart && $this->cartModel->clear($cart['id'])) {
                Response::success(null, 'Cart cleared successfully');
            } else {
                Response::error('Failed to clear cart', 500);
            }
        } catch (Exception $e) {
            Response::unauthorized('Authentication failed');
        }
    }
}
