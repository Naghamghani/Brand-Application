<?php
header('Content-Type: application/json; charset=utf-8');
include 'connection.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(["success" => false, "message" => "POST only"]);
    exit;
}

$name = isset($_POST['name']) ? trim($_POST['name']) : "";
$dropdown = isset($_POST['dropdown']) ? trim($_POST['dropdown']) : "";

if ($name === "" || $dropdown === "") {
    http_response_code(400);
    echo json_encode(["success" => false, "message" => "Missing data"]);
    exit;
}

$stmt = $conn->prepare("INSERT INTO items (name, dropdown) VALUES (?, ?)");
$stmt->bind_param("ss", $name, $dropdown);

if ($stmt->execute()) {
    echo json_encode([
        "success" => true,
        "id" => $conn->insert_id
    ]);
} else {
    http_response_code(500);
    echo json_encode([
        "success" => false,
        "message" => $conn->error
    ]);
}

$stmt->close();
$conn->close();
?>