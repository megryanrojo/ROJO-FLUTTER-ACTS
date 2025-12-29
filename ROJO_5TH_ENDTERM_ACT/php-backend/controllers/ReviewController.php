<?php

class ReviewController {
    private $db;
    private $reviewModel;
    private $productModel;
    private $authMiddleware;
    private $userModel;

    public function __construct($db) {
        $this->db = $db;
        $this->reviewModel = new Review($db);
        $this->productModel = new Product($db);
        $this->authMiddleware = new AuthMiddleware();
        $this->userModel = new User($db);
    }

    /**
     * Add review to product
     * POST /api/products/{id}/reviews
     */
    public function addReview($productId) {
        try {
            $payload = $this->authMiddleware->verify();
            $firebaseUid = $payload['sub'] ?? $payload['uid'];
            $user = $this->userModel->getByFirebaseUid($firebaseUid);

            if (!$user) {
                Response::notFound('User not found');
            }

            $product = $this->productModel->getById($productId);

            if (!$product) {
                Response::notFound('Product not found');
            }

            $input = json_decode(file_get_contents('php://input'), true);

            $rules = [
                'rating' => 'required|numeric',
                'comment' => 'required'
            ];

            if (!Validator::validate($input, $rules)) {
                Response::validationError(Validator::errors());
            }

            // Check if review already exists
            $existingReview = $this->reviewModel->getByProductAndBuyer($productId, $user['id']);

            if ($existingReview) {
                Response::error('You have already reviewed this product', 409);
            }

            if ($this->reviewModel->create(
                $productId,
                $user['id'],
                $input['rating'],
                $input['comment']
            )) {
                // Update product rating
                $rating = $this->reviewModel->getProductRating($productId);
                $this->productModel->updateRating(
                    $productId,
                    round($rating['average_rating'], 2),
                    $rating['total_reviews']
                );

                Response::success(null, 'Review added successfully', 201);
            } else {
                Response::error('Failed to add review', 500);
            }
        } catch (Exception $e) {
            Response::unauthorized('Authentication failed');
        }
    }

    /**
     * Get product reviews
     * GET /api/products/{id}/reviews
     */
    public function getProductReviews($productId) {
        $page = $_GET['page'] ?? Constants::DEFAULT_PAGE;
        $limit = Constants::DEFAULT_PAGE_SIZE;
        $offset = ($page - 1) * $limit;

        $product = $this->productModel->getById($productId);

        if (!$product) {
            Response::notFound('Product not found');
        }

        $reviews = $this->reviewModel->getByProductId($productId, $limit, $offset);

        Response::success([
            'reviews' => $reviews,
            'page' => $page,
            'limit' => $limit
        ], 'Reviews fetched successfully');
    }

    /**
     * Delete review
     * DELETE /api/reviews/{id}
     */
    public function deleteReview($reviewId) {
        try {
            $payload = $this->authMiddleware->verify();
            $firebaseUid = $payload['sub'] ?? $payload['uid'];
            $user = $this->userModel->getByFirebaseUid($firebaseUid);

            if (!$user) {
                Response::notFound('User not found');
            }

            // Fetch review from database to verify ownership
            $review = $this->db->query("SELECT * FROM reviews WHERE id = $reviewId")->fetch_assoc();

            if (!$review) {
                Response::notFound('Review not found');
            }

            if ($review['buyer_id'] !== $user['id'] && $user['role'] !== Constants::ROLE_ADMIN) {
                Response::forbidden('You cannot delete this review');
            }

            if ($this->reviewModel->delete($reviewId)) {
                // Update product rating
                $rating = $this->reviewModel->getProductRating($review['product_id']);
                $this->productModel->updateRating(
                    $review['product_id'],
                    round($rating['average_rating'], 2),
                    $rating['total_reviews']
                );

                Response::success(null, 'Review deleted successfully');
            } else {
                Response::error('Failed to delete review', 500);
            }
        } catch (Exception $e) {
            Response::unauthorized('Authentication failed');
        }
    }
}
