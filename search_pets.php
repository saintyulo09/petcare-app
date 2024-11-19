<?php
include('../config/db_connection.php');

$searchTerm = isset($_GET['search']) ? $_GET['search'] : '';

// Prepare and execute SQL query to search for pets by name
$sql = "SELECT id, pet_name FROM pets WHERE pet_name LIKE ?";
$stmt = $conn->prepare($sql);
$searchTerm = "%$searchTerm%";
$stmt->bind_param("s", $searchTerm);
$stmt->execute();
$result = $stmt->get_result();

$pets = [];
while ($row = $result->fetch_assoc()) {
    $pets[] = $row;
}

echo json_encode($pets);

// Close the database connection
$stmt->close();
$conn->close();
?>
