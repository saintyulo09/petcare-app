<?php
include('../config/db_connection.php');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $appointment_id = $_POST['appointment_id'];
    $action = $_POST['action'];

    if ($action === 'delete') {
        // Handle delete
        $sql = "DELETE FROM appointments WHERE id = ?";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("i", $appointment_id);
        if ($stmt->execute()) {
            header("Location: ../pages/calendar.php?status=deleted");
        } else {
            echo "Error deleting appointment: " . $conn->error;
        }
    } elseif ($action === 'edit') {
        // Redirect to the edit form
        header("Location: edit_appointment.php?id=$appointment_id");
    }
}
?>
