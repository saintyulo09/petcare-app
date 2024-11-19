<?php
// Include database connection
include('config/db_connection.php');

// Fetch all upcoming appointments from the database
$current_date = date('Y-m-d'); // Current date to filter upcoming appointments
$sql = "SELECT id, full_name, appointment_date, appointment_time, concern, phone, email FROM appointments WHERE appointment_date >= '$current_date' ORDER BY appointment_date ASC, appointment_time ASC";
$result = mysqli_query($conn, $sql);

// Check if there are upcoming appointments
$appointments = [];
if (mysqli_num_rows($result) > 0) {
    while ($row = mysqli_fetch_assoc($result)) {
        $appointments[] = $row;
    }
} else {
    $appointments = null; // No upcoming appointments
}

// Close the database connection
mysqli_close($conn);
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PetCare</title>
    <link rel="stylesheet" href="../assets/styles.css"> <!-- External CSS file -->
</head>
<body>
    <div class="sidebar">
        <ul>
            <li><a href="index.php"><img src="../assets/icons/home.png" alt="Home"></a></li>
            <li><a href="pages/calendar.php"><img src="../assets/icons/calendar.png" alt="Calendar"></a></li>
            <li><a href="pages/book.php"><img src="../assets/icons/plus.png" alt="Add"></a></li>
            <li><a href="pages/pets.php"><img src="../assets/icons/paw.png" alt="Pets"></a></li>
            <li><a href="pages/profile.php"><img src="../assets/icons/user.png" alt="Profile"></a></li>
            <li><a href="#"><img src="../assets/icons/logout.png" alt="Logout"></a></li>
        </ul>
    </div>

    <div class="main-content">
        <div class="header">
            <div class="logo">
                <img src="../assets/images/logo.png" alt="PetCare Logo">
                <h1>PetCare</h1>
            </div>
            <div class="user-settings">
                <img src="../assets/icons/bell.png" alt="Notifications">
                <img src="../assets/icons/settings.png" alt="Settings">
            </div>
        </div>

        <div class="appointments">
            <h2>Upcoming Appointments</h2>

            <?php if ($appointments): ?>
                <?php foreach ($appointments as $appointment): ?>
                    <div class="appointment-item">
                        <!-- Left-aligned appointment details -->
                        <div class="appointment-details">
                            <h3><?php echo htmlspecialchars($appointment['full_name']); ?></h3>
                            <p>Concern: <?php echo htmlspecialchars($appointment['concern']); ?></p>
                            <p>Phone: <?php echo htmlspecialchars($appointment['phone']); ?></p>
                            <p>Email: <?php echo htmlspecialchars($appointment['email']); ?></p>
                            <p><small>Appointment Date: <?php echo date('F j, Y', strtotime($appointment['appointment_date'])); ?></small></p>
                            <p><small>Appointment Time: <?php echo date('h:i A', strtotime($appointment['appointment_time'])); ?></small></p>
                        </div>

                        <!-- Right-aligned edit and delete buttons -->
                        <div class="appointment-actions">
                            <form method="POST" action="config/edit_delete_appointment.php" style="display:inline;">
                                <input type="hidden" name="appointment_id" value="<?php echo $appointment['id']; ?>" />
                                <button type="submit" name="action" value="edit">Edit</button>
                            </form>
                            <form method="POST" action="config/edit_delete_appointment.php" style="display:inline;">
                                <input type="hidden" name="appointment_id" value="<?php echo $appointment['id']; ?>" />
                                <button type="submit" name="action" value="delete" onclick="return confirm('Are you sure you want to delete this appointment?');">Delete</button>
                            </form>
                        </div>
                    </div>
                <?php endforeach; ?>
            <?php else: ?>
                <p>No upcoming appointments found.</p>
            <?php endif; ?>
        </div>
    </div>
</body>
</html>
