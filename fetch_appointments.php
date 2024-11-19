<?php
// fetch_appointments.php
header('Content-Type: application/json');

// Include the database connection
include_once 'db_connection.php';

if (isset($_GET['date'])) {
    $selectedDate = $_GET['date'];

    // SQL query to fetch all appointments for the selected date, including appointment_date and appointment_time
    $sql = "SELECT id, full_name, email, phone, concern, appointment_date, appointment_time FROM appointments WHERE DATE(appointment_date) = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("s", $selectedDate);
    $stmt->execute();
    $result = $stmt->get_result();

    $appointments = [];
    while ($row = $result->fetch_assoc()) {
        $appointments[] = $row;
    }

    // Return the appointments as JSON
    echo json_encode($appointments);
} else {
    echo json_encode([]);
}
?>
