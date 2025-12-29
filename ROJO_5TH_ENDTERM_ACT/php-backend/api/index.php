<?php
// API Entry Point and Router
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');
header('Content-Type: application/json');

// Load environment variables (if using .env file)
if (file_exists(__DIR__ . '/.env')) {
    $env = parse_ini_file(__DIR__ . '/.env');
    foreach ($env as $key => $value) {
        putenv("$key=$value");
    }
}

// Autoload classes
require_once __DIR__ . '/../config/Constants.php';
require_once __DIR__ . '/../config/Database.php';
require_once __DIR__ . '/../config/Firebase.php';
require_once __DIR__ . '/../utils/Response.php';
require_once __DIR__ . '/../utils/Validator.php';
require_once __DIR__ . '/../middleware/AuthMiddleware.php';
require_once __DIR__ . '/../models/User.php';
require_once __DIR__ . '/../models/Product.php';
require_once __DIR__ . '/../models/Cart.php';
require_once __DIR__ . '/../models/Order.php';
require_once __DIR__ . '/../models/Review.php';
require_once __DIR__ . '/../controllers/AuthController.php';
require_once __DIR__ . '/../controllers/ProductController.php';
require_once __DIR__ . '/../controllers/CartController.php';
require_once __DIR__ . '/../controllers/OrderController.php';
require_once __DIR__ . '/../controllers/ReviewController.php';

// Initialize database
$database = new Database();
$db = $database->connect();

// Get request method and path
$method = $_SERVER['REQUEST_METHOD'];
$path = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);

// Remove the base path (e.g., /api/)
$basePath = '/api';
$path = str_replace($basePath, '', $path);
$path = trim($path, '/');

// Split path into segments
$segments = explode('/', $path);

// Route handling
try {
    if ($method === 'OPTIONS') {
        http_response_code(200);
        exit();
    }

    // Auth Routes
    if ($segments[0] === 'auth') {
        $authController = new AuthController($db);

        switch ($segments[1] ?? null) {
            case 'register':
                if ($method === 'POST') {
                    $authController->register();
                }
                break;

            case 'login':
                if ($method === 'POST') {
                    $authController->login();
                }
                break;

            case 'refresh-token':
                if ($method === 'POST') {
                    $authController->refreshToken();
                }
                break;

            case 'forgot-password':
                if ($method === 'POST') {
                    $authController->forgotPassword();
                }
                break;

            case 'me':
                if ($method === 'GET') {
                    $authController->getCurrentUser();
                }
                break;

            default:
                Response::notFound('Auth endpoint not found');
        }
    }
    // Product Routes
    elseif ($segments[0] === 'products') {
        $productController = new ProductController($db);

        if (isset($segments[1]) && is_numeric($segments[1])) {
            $productId = (int)$segments[1];

            if ($method === 'GET' && !isset($segments[2])) {
                $productController->getById($productId);
            } elseif ($method === 'PUT') {
                $productController->update($productId);
            } elseif ($method === 'DELETE') {
                $productController->delete($productId);
            } elseif ($segments[2] === 'reviews' && $method === 'GET') {
                $reviewController = new ReviewController($db);
                $reviewController->getProductReviews($productId);
            } elseif ($segments[2] === 'reviews' && $method === 'POST') {
                $reviewController = new ReviewController($db);
                $reviewController->addReview($productId);
            } else {
                Response::notFound('Product endpoint not found');
            }
        } elseif (empty($segments[1])) {
            if ($method === 'GET') {
                $productController->getAll();
            } elseif ($method === 'POST') {
                $productController->create();
            } else {
                Response::notFound('Method not allowed');
            }
        } else {
            Response::notFound('Product endpoint not found');
        }
    }
    // Cart Routes
    elseif ($segments[0] === 'cart') {
        $cartController = new CartController($db);

        if (empty($segments[1])) {
            if ($method === 'GET') {
                $cartController->getCart();
            } elseif ($method === 'DELETE') {
                $cartController->clearCart();
            }
        } elseif ($segments[1] === 'items') {
            if (isset($segments[2]) && is_numeric($segments[2])) {
                $itemId = (int)$segments[2];
                if ($method === 'PUT') {
                    $cartController->updateItem($itemId);
                } elseif ($method === 'DELETE') {
                    $cartController->removeItem($itemId);
                }
            } elseif ($method === 'POST') {
                $cartController->addItem();
            }
        }
    }
    // Order Routes
    elseif ($segments[0] === 'orders') {
        $orderController = new OrderController($db);

        if (isset($segments[1]) && is_numeric($segments[1])) {
            $orderId = (int)$segments[1];

            if ($method === 'GET' && !isset($segments[2])) {
                $orderController->getOrderDetails($orderId);
            } elseif ($segments[2] === 'status' && $method === 'PUT') {
                $orderController->updateStatus($orderId);
            } elseif ($segments[2] === 'items' && $method === 'GET') {
                $order = $orderController->getOrderDetails($orderId);
            }
        } elseif (empty($segments[1])) {
            if ($method === 'GET') {
                $orderController->getOrders();
            } elseif ($method === 'POST') {
                $orderController->create();
            }
        }
    }
    // Seller Routes
    elseif ($segments[0] === 'seller') {
        if ($segments[1] === 'orders' && isset($segments[1])) {
            $orderController = new OrderController($db);
            if ($method === 'GET') {
                $orderController->getSellerOrders();
            }
        }
    }
    // Sellers Routes
    elseif ($segments[0] === 'sellers' && isset($segments[1]) && is_numeric($segments[1])) {
        $sellerId = (int)$segments[1];

        if ($segments[2] === 'products' && $method === 'GET') {
            $productController = new ProductController($db);
            $productController->getBySellerI($sellerId);
        }
    }
    // Review Routes
    elseif ($segments[0] === 'reviews' && isset($segments[1]) && is_numeric($segments[1])) {
        $reviewId = (int)$segments[1];

        if ($method === 'DELETE') {
            $reviewController = new ReviewController($db);
            $reviewController->deleteReview($reviewId);
        }
    }
    // 404 Not Found
    else {
        Response::notFound('Endpoint not found');
    }
} catch (Exception $e) {
    Response::serverError('An unexpected error occurred: ' . $e->getMessage());
} finally {
    $database->closeConnection();
}
