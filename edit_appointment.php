<?php
include('../config/db_connection.php');

$appointment_id = $_GET['id'];

// Fetch the appointment details, including appointment time
$sql = "SELECT * FROM appointments WHERE id = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $appointment_id);
$stmt->execute();
$result = $stmt->get_result();
$appointment = $result->fetch_assoc();

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Update the appointment
    $pet_id = $_POST['pet_id'];
    $full_name = $_POST['full_name'];
    $appointment_date = $_POST['appointment_date'];
    $appointment_time = $_POST['appointment_time'];
    $concern = $_POST['concern'];
    $phone = $_POST['phone'];
    $email = $_POST['email'];

    $sql = "UPDATE appointments 
            SET pet_id = ?, full_name = ?, appointment_date = ?, appointment_time = ?, concern = ?, phone = ?, email = ? 
            WHERE id = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("issssssi", $pet_id, $full_name, $appointment_date, $appointment_time, $concern, $phone, $email, $appointment_id);

    if ($stmt->execute()) {
        header("Location: ../index.php?status=updated");
        exit;
    } else {
        echo "Error updating appointment: " . $conn->error;
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Appointment</title>
    <link rel="stylesheet" href="../assets/styles.css">
</head>
<body>

    <!-- Sidebar -->
    <div class="sidebar">
        <ul>
            <li><a href="../index.php"><img src="../assets/icons/home.png" alt="Home"></a></li>
            <li><a href="/pages/calendar.php"><img src="../assets/icons/calendar.png" alt="Calendar"></a></li>
            <li><a href="/pages/book.php"><img src="../assets/icons/plus.png" alt="Add Appointment"></a></li>
            <li><a href="/pages/pets.php"><img src="../assets/icons/paw.png" alt="Pets"></a></li>
            <li><a href="/pages/profile.php"><img src="../assets/icons/user.png" alt="Profile"></a></li>
            <li><a href="#"><img src="../assets/icons/logout.png" alt="Logout"></a></li>
        </ul>
    </div>

    <!-- Main content -->
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

        <div class="edit-form">
            <h2>Edit Appointment</h2>

            <form method="POST">
                <label for="pet_id">Pet ID:</label>
                <input type="text" id="pet_id" name="pet_id" 
                       value="<?php echo isset($appointment['pet_id']) ? htmlspecialchars($appointment['pet_id']) : ''; ?>" required>

                <label for="full_name">Pet's Name:</label>
                <input type="text" id="full_name" name="full_name" 
                       value="<?php echo htmlspecialchars($appointment['full_name']); ?>" required>

                <label for="appointment_date">Appointment Date:</label>
                <input type="date" id="appointment_date" name="appointment_date" 
                       value="<?php echo $appointment['appointment_date']; ?>" required>

                <label for="appointment_time">Appointment Time:</label>
                <input type="time" id="appointment_time" name="appointment_time" 
                       value="<?php echo $appointment['appointment_time']; ?>" required>

                <label for="concern">Concern:</label>
                <textarea id="concern" name="concern" required><?php echo htmlspecialchars($appointment['concern']); ?></textarea>

                <label for="phone">Phone Number:</label>
                <input type="text" id="phone" name="phone" 
                       value="<?php echo isset($appointment['phone']) ? htmlspecialchars($appointment['phone']) : ''; ?>" required>

                <label for="email">Email:</label>
                <input type="email" id="email" name="email" 
                       value="<?php echo isset($appointment['email']) ? htmlspecialchars($appointment['email']) : ''; ?>" required>

                <button type="submit">Update Appointment</button>
            </form>
        </div>
    </div>

</body>
</html>
