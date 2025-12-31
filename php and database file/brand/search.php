<?php
include 'connection.php';

$query = isset($_POST['query']) ? $_POST['query'] : '';

$sql = "SELECT * FROM items WHERE name LIKE '%$query%'";
$result = $conn->query($sql);

$data = array();
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $data[] = $row;
    }
}

echo json_encode($data);

$conn->close();
?>
