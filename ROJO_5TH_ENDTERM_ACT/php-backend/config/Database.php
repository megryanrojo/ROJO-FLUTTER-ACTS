<?php

class Database {
    private $host;
    private $db_user;
    private $db_password;
    private $db_name;
    private $db_port;
    private $connection;

    public function __construct() {
        $this->host = getenv('DB_HOST') ?: 'localhost';
        $this->db_user = getenv('DB_USER') ?: 'root';
        $this->db_password = getenv('DB_PASSWORD') ?: '';
        $this->db_name = getenv('DB_NAME') ?: 'ecommerce_db';
        $this->db_port = getenv('DB_PORT') ?: 3306;
    }

    public function connect() {
        $this->connection = new mysqli(
            $this->host,
            $this->db_user,
            $this->db_password,
            $this->db_name,
            $this->db_port
        );

        // Check connection
        if ($this->connection->connect_error) {
            die(json_encode([
                'status' => 'error',
                'message' => 'Database connection failed: ' . $this->connection->connect_error
            ]));
        }

        // Set charset to UTF-8
        $this->connection->set_charset("utf8mb4");

        return $this->connection;
    }

    public function getConnection() {
        return $this->connection;
    }

    public function closeConnection() {
        if ($this->connection) {
            $this->connection->close();
        }
    }

    public function escape($string) {
        return $this->connection->real_escape_string($string);
    }
}
