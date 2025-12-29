<?php

class Response {
    public static function success($data = null, $message = 'Success', $statusCode = 200) {
        http_response_code($statusCode);
        return self::json([
            'status' => Constants::RESPONSE_SUCCESS,
            'message' => $message,
            'data' => $data,
            'timestamp' => time()
        ]);
    }

    public static function error($message = 'An error occurred', $statusCode = 400, $data = null) {
        http_response_code($statusCode);
        return self::json([
            'status' => Constants::RESPONSE_ERROR,
            'message' => $message,
            'data' => $data,
            'timestamp' => time()
        ]);
    }

    public static function validationError($errors, $message = 'Validation failed', $statusCode = 422) {
        http_response_code($statusCode);
        return self::json([
            'status' => Constants::RESPONSE_VALIDATION_ERROR,
            'message' => $message,
            'errors' => $errors,
            'timestamp' => time()
        ]);
    }

    public static function notFound($message = 'Resource not found') {
        return self::error($message, Constants::HTTP_NOT_FOUND);
    }

    public static function unauthorized($message = 'Unauthorized') {
        return self::error($message, Constants::HTTP_UNAUTHORIZED);
    }

    public static function forbidden($message = 'Forbidden') {
        return self::error($message, Constants::HTTP_FORBIDDEN);
    }

    public static function serverError($message = 'Internal server error') {
        return self::error($message, Constants::HTTP_SERVER_ERROR);
    }

    private static function json($data) {
        header('Content-Type: application/json');
        echo json_encode($data, JSON_UNESCAPED_SLASHES | JSON_PRETTY_PRINT);
        exit();
    }
}
