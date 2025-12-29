<?php

class Constants {
    // User Roles
    const ROLE_ADMIN = 'admin';
    const ROLE_SELLER = 'seller';
    const ROLE_BUYER = 'buyer';

    // User Status
    const STATUS_ACTIVE = 'active';
    const STATUS_INACTIVE = 'inactive';
    const STATUS_SUSPENDED = 'suspended';

    // Product Status
    const PRODUCT_ACTIVE = 'active';
    const PRODUCT_INACTIVE = 'inactive';
    const PRODUCT_DELETED = 'deleted';

    // Order Status
    const ORDER_PENDING = 'pending';
    const ORDER_CONFIRMED = 'confirmed';
    const ORDER_SHIPPED = 'shipped';
    const ORDER_DELIVERED = 'delivered';
    const ORDER_CANCELLED = 'cancelled';

    // Pagination
    const DEFAULT_PAGE_SIZE = 20;
    const DEFAULT_PAGE = 1;

    // API Response Status
    const RESPONSE_SUCCESS = 'success';
    const RESPONSE_ERROR = 'error';
    const RESPONSE_VALIDATION_ERROR = 'validation_error';

    // HTTP Status Codes
    const HTTP_OK = 200;
    const HTTP_CREATED = 201;
    const HTTP_BAD_REQUEST = 400;
    const HTTP_UNAUTHORIZED = 401;
    const HTTP_FORBIDDEN = 403;
    const HTTP_NOT_FOUND = 404;
    const HTTP_CONFLICT = 409;
    const HTTP_SERVER_ERROR = 500;
}
