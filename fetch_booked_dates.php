<?php
// fetch_booked_dates.php
header('Content-Type: application/json');

// Include the database connection
include_once 'db_connection.php';

// Define the getBookedDates function if it doesn't exist
function getBookedDates($conn, $year, $month) {
    $bookedDates = [];
    $start_date = "$year-$month-01";
    $end_date = date("Y-m-t", strtotime($start_date)); // Get the last day of the month

    $sql = "SELECT DISTINCT DATE(appointment_date) AS appointment_date FROM appointments WHERE appointment_date BETWEEN '$start_date' AND '$end_date'";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            $bookedDates[] = $row['appointment_date'];
        }
    }

    return $bookedDates;
}

if (isset($_GET['year']) && isset($_GET['month'])) {
    $year = intval($_GET['year']);
    $month = intval($_GET['month']);

    // Fetch the booked dates from the database
    $bookedDates = getBookedDates($conn, $year, $month);

    // Return the booked dates in JSON format
    echo json_encode($bookedDates);
} else {
    echo json_encode([]);
}
?>
