<?php
// Include database connection
include('../config/db_connection.php');

if (isset($_GET['id'])) {
    $pet_id = $_GET['id'];

    // Fetch pet details from the database
    $sql = "SELECT * FROM pets WHERE id = $pet_id";
    $result = mysqli_query($conn, $sql);

    if (mysqli_num_rows($result) == 1) {
        $pet = mysqli_fetch_assoc($result);
    } else {
        echo "Pet not found!";
        exit;
    }

    // Fetch pet vaccination and deworming records
    $records_sql = "SELECT * FROM vaccination_records WHERE pet_id = $pet_id";
    $records_result = mysqli_query($conn, $records_sql);

    // Fetch pet appointments
    $appointments_sql = "SELECT * FROM appointments WHERE pet_id = $pet_id ORDER BY appointment_date ASC, appointment_time ASC";
    $appointments_result = mysqli_query($conn, $appointments_sql);
} else {
    echo "Invalid pet ID!";
    exit;
}

// Close the database connection
mysqli_close($conn);
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pet Records - PetCare</title>
    <link rel="stylesheet" href="../assets/styles.css"> <!-- Assuming the CSS path -->
</head>
<body>
    <div class="sidebar">
        <ul>
            <li><a href="../index.php"><img src="../assets/icons/home.png" alt="Home"></a></li>
            <li><a href="calendar.php"><img src="../assets/icons/calendar.png" alt="Calendar"></a></li>
            <li><a href="book.php"><img src="../assets/icons/plus.png" alt="Add"></a></li>
            <li><a href="pets.php"><img src="../assets/icons/paw.png" alt="Pets"></a></li>
            <li><a href="profile.php"><img src="../assets/icons/user.png" alt="Profile"></a></li>
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

        <div class="records-section">
        <h2>
        <?php 
        $petName = isset($pet['pet_name']) ? $pet['pet_name'] : 'Unknown Pet';
        $petId = isset($pet['id']) ? $pet['id'] : 'N/A';
        echo $petName . ' (ID: ' . $petId . ')'; 
        ?>'s Records
    </h2>

    <div class="records-buttons">
    <button class="record-btn" onclick="window.location.href='vaccination_details.php?type=primary&pet_id=<?php echo $pet_id; ?>'">
        Primary Course of Vaccination
    </button>
    <button class="record-btn" onclick="window.location.href='booster_details.php?type=booster&pet_id=<?php echo $pet_id; ?>'">
        Booster
    </button>
    <button class="record-btn" onclick="window.location.href='deworming_details.php?type=deworming&pet_id=<?php echo $pet_id; ?>'">
        Deworming Record
    </button>
    <button class="record-btn" onclick="window.location.href='rabies_details.php?type=rabies&pet_id=<?php echo $pet_id; ?>'">
        Rabies Vaccination
    </button>
</div>

            <!-- Appointments Section -->
<div class="appointments">
    <h2>Upcoming Appointments</h2>

 <!-- Add Appointment Button -->
 <a href="book.php?pet_id=<?php echo $pet_id; ?>" class="add-btn">Add Appointment</a>

    <?php if (mysqli_num_rows($appointments_result) > 0): ?>
        <?php while ($appointment = mysqli_fetch_assoc($appointments_result)): ?>
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
                    <form method="POST" action="/config/edit_delete_appointment.php">
                        <input type="hidden" name="appointment_id" value="<?php echo $appointment['id']; ?>" />
                        <button type="submit" name="action" value="edit">Edit</button>
                    </form>
                    <form method="POST" action="/config/edit_delete_appointment.php">
                        <input type="hidden" name="appointment_id" value="<?php echo $appointment['id']; ?>" />
                        <button type="submit" name="action" value="delete" onclick="return confirm('Are you sure you want to delete this appointment?');">Delete</button>
                    </form>
                </div>
            </div>
        <?php endwhile; ?>
    <?php else: ?>
        <p>No upcoming appointments found.</p>
    <?php endif; ?>
</div>
        </div>
    </div>
</body>
</html>
