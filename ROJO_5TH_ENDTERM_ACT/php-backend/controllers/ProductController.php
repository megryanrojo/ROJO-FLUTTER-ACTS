<?php

class ProductController {
    private $db;
    private $productModel;
    private $authMiddleware;
    private $userModel;

    public function __construct($db) {
        $this->db = $db;
        $this->productModel = new Product($db);
        $this->authMiddleware = new AuthMiddleware();
        $this->userModel = new User($db);
    }

    /**
     * Get all products with pagination
     * GET /api/products?page=1&category=electronics
     */
    public function getAll() {
        $page = $_GET['page'] ?? Constants::DEFAULT_PAGE;
        $category = $_GET['category'] ?? null;
        $limit = Constants::DEFAULT_PAGE_SIZE;
        $offset = ($page - 1) * $limit;

        $products = $this->productModel->getAll($limit, $offset, $category);

        Response::success([
            'products' => $products,
            'page' => $page,
            'limit' => $limit
        ], 'Products fetched successfully');
    }

    /**
     * Get product by ID
     * GET /api/products/{id}
     */
    public function getById($id) {
        $product = $this->productModel->getById($id);

        if (!$product) {
            Response::notFound('Product not found');
        }

        Response::success($product, 'Product fetched successfully');
    }

    /**
     * Create product (seller only)
     * POST /api/products
     */
    public function create() {
        try {
            $payload = $this->authMiddleware->verify();
            $firebaseUid = $payload['sub'] ?? $payload['uid'];

            // Get user by Firebase UID
            $user = $this->userModel->getByFirebaseUid($firebaseUid);

            if (!$user || $user['role'] !== Constants::ROLE_SELLER) {
                Response::forbidden('Only sellers can create products');
            }

            $input = json_decode(file_get_contents('php://input'), true);

            $rules = [
                'name' => 'required',
                'description' => 'required',
                'price' => 'required|numeric',
                'stock_quantity' => 'required|numeric',
                'image_url' => 'required',
                'category' => 'required'
            ];

            if (!Validator::validate($input, $rules)) {
                Response::validationError(Validator::errors());
            }

            if ($this->productModel->create(
                $user['id'],
                $input['name'],
                $input['description'],
                $input['price'],
                $input['stock_quantity'],
                $input['image_url'],
                $input['category']
            )) {
                Response::success(null, 'Product created successfully', 201);
            } else {
                Response::error('Failed to create product', 500);
            }
        } catch (Exception $e) {
            Response::unauthorized('Authentication failed');
        }
    }

    /**
     * Update product (seller only)
     * PUT /api/products/{id}
     */
    public function update($id) {
        try {
            $payload = $this->authMiddleware->verify();
            $firebaseUid = $payload['sub'] ?? $payload['uid'];
            $user = $this->userModel->getByFirebaseUid($firebaseUid);

            if (!$user) {
                Response::notFound('User not found');
            }

            $product = $this->productModel->getById($id);

            if (!$product) {
                Response::notFound('Product not found');
            }

            // Check if user is the seller
            if ($product['seller_id'] !== $user['id']) {
                Response::forbidden('You can only update your own products');
            }

            $input = json_decode(file_get_contents('php://input'), true);

            if ($this->productModel->update(
                $id,
                $input['name'] ?? $product['name'],
                $input['description'] ?? $product['description'],
                $input['price'] ?? $product['price'],
                $input['stock_quantity'] ?? $product['stock_quantity'],
                $input['image_url'] ?? null,
                $input['category'] ?? null
            )) {
                Response::success(null, 'Product updated successfully');
            } else {
                Response::error('Failed to update product', 500);
            }
        } catch (Exception $e) {
            Response::unauthorized('Authentication failed');
        }
    }

    /**
     * Delete product (seller only)
     * DELETE /api/products/{id}
     */
    public function delete($id) {
        try {
            $payload = $this->authMiddleware->verify();
            $firebaseUid = $payload['sub'] ?? $payload['uid'];
            $user = $this->userModel->getByFirebaseUid($firebaseUid);

            if (!$user) {
                Response::notFound('User not found');
            }

            $product = $this->productModel->getById($id);

            if (!$product) {
                Response::notFound('Product not found');
            }

            if ($product['seller_id'] !== $user['id']) {
                Response::forbidden('You can only delete your own products');
            }

            if ($this->productModel->delete($id)) {
                Response::success(null, 'Product deleted successfully');
            } else {
                Response::error('Failed to delete product', 500);
            }
        } catch (Exception $e) {
            Response::unauthorized('Authentication failed');
        }
    }

    /**
     * Get products by seller
     * GET /api/sellers/{id}/products
     */
    public function getBySellerI($sellerId) {
        $page = $_GET['page'] ?? Constants::DEFAULT_PAGE;
        $limit = Constants::DEFAULT_PAGE_SIZE;
        $offset = ($page - 1) * $limit;

        $products = $this->productModel->getBySellerId($sellerId, $limit, $offset);

        Response::success([
            'products' => $products,
            'page' => $page,
            'limit' => $limit
        ], 'Products fetched successfully');
    }
}
