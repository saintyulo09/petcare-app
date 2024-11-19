<?php
// Include database connection
include('../config/db_connection.php');

// Check if pet_id is set in the URL query
if (isset($_GET['pet_id'])) {
    $pet_id = $_GET['pet_id'];
} else {
    echo "Invalid request!";
    exit;
}

// Handle form submission
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $date_given = $_POST['date_given'];
    $date_due = $_POST['date_due'];
    $vaccine_name = $_POST['vaccine_name'];
    $administered_by = $_POST['administered_by'];

    // Insert new booster vaccination record into the database
    $sql = "INSERT INTO vaccination_records (pet_id, type, date_given, date_due, vaccine_name, administered_by) 
            VALUES ('$pet_id', 'booster', '$date_given', '$date_due', '$vaccine_name', '$administered_by')";
    
    if (mysqli_query($conn, $sql)) {
        // Redirect back to booster details page after successful addition
        header("Location: booster_details.php?pet_id=$pet_id");
        exit();
    } else {
        echo "Error: " . mysqli_error($conn);
    }
}

// Close the database connection
mysqli_close($conn);
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Booster Vaccination Record - PetCare</title>
    <link rel="stylesheet" href="../assets/styles.css">
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

        <div class="booster-form">
            <h2>Add Booster Vaccination Record</h2>
            <form method="POST" action="">
                <label for="date_given">Date Given:</label>
                <input type="date" id="date_given" name="date_given" required>

                <label for="date_due">Date Due:</label>
                <input type="date" id="date_due" name="date_due">

                <label for="vaccine_name">Vaccine Name:</label>
                <input type="text" id="vaccine_name" name="vaccine_name" required>

                <label for="administered_by">Administered By:</label>
                <input type="text" id="administered_by" name="administered_by" required>

                <button type="submit">Add Booster</button>
            </form>
        </div>
    </div>
</body>
</html>
