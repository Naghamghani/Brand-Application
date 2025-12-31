<?php
$servername = "localhost";
$username   = "root";
$password   = "";
$dbname     = "brand-db";   // ✅ اسم الداتابيز الصح

$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$conn->set_charset("utf8mb4");
?>