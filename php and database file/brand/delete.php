<?php
header('Content-Type: application/json; charset=utf-8');
include 'connection.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(["success" => false, "message" => "POST only"]);
    exit;
}

$ids = json_decode($_POST['ids'] ?? '[]', true);

if (!is_array($ids) || count($ids) === 0) {
    http_response_code(400);
    echo json_encode(["success" => false, "message" => "No IDs"]);
    exit;
}

$cleanIds = array_map('intval', $ids);
$placeholders = implode(',', array_fill(0, count($cleanIds), '?'));
$types = str_repeat('i', count($cleanIds));

$sql = "DELETE FROM items WHERE id IN ($placeholders)";
$stmt = $conn->prepare($sql);
$stmt->bind_param($types, ...$cleanIds);

if ($stmt->execute()) {
    echo json_encode([
        "success" => true,
        "deleted" => $stmt->affected_rows
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