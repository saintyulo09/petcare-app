<?php
// Include database connection
include('../config/db_connection.php');

// Initialize a message variable to store success or error messages
$message = '';

// Check if 'id' is set in the URL query (this is the vaccination record ID)
if (isset($_GET['id'])) {
    $vaccination_id = $_GET['id'];

    // Fetch the vaccination record based on the ID
    $sql = "SELECT * FROM vaccination_records WHERE id = $vaccination_id";
    $result = mysqli_query($conn, $sql);

    if (mysqli_num_rows($result) == 1) {
        $vaccination = mysqli_fetch_assoc($result);
    } else {
        echo "Vaccination record not found!";
        exit;
    }
} else {
    echo "Invalid request!";
    exit;
}

// Handle form submission for updating the vaccination record
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $date_given = $_POST['date_given'];
    $date_due = $_POST['date_due'];
    $vaccine_name = $_POST['vaccine_name'];
    $administered_by = $_POST['administered_by'];

    // Update the vaccination record
    $update_sql = "UPDATE vaccination_records SET date_given = '$date_given', date_due = '$date_due', vaccine_name = '$vaccine_name', administered_by = '$administered_by' WHERE id = $vaccination_id";

    if (mysqli_query($conn, $update_sql)) {
        // Set success message if the update is successful
        $message = "Updated successfully!";
    } else {
        // Set error message if there's an issue
        $message = "Error updating record: " . mysqli_error($conn);
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
    <title>Edit Vaccination Record - PetCare</title>
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

        <div class="edit-vaccination-form">
            <h2>Edit Vaccination Record</h2>

            <!-- Display success or error message -->
            <?php if (!empty($message)): ?>
                <p style="color: green;"><?php echo $message; ?></p>
            <?php endif; ?>

            <form method="POST" action="">
                <label for="date_given">Date Given:</label>
                <input type="date" id="date_given" name="date_given" value="<?php echo $vaccination['date_given']; ?>" required>

                <label for="date_due">Date Due:</label>
                <input type="date" id="date_due" name="date_due" value="<?php echo $vaccination['date_due']; ?>">

                <label for="vaccine_name">Vaccine Name:</label>
                <input type="text" id="vaccine_name" name="vaccine_name" value="<?php echo $vaccination['vaccine_name']; ?>" required>

                <label for="administered_by">Administered By:</label>
                <input type="text" id="administered_by" name="administered_by" value="<?php echo $vaccination['administered_by']; ?>" required>

                <button type="submit">Update Vaccination</button>
            </form>
        </div>
    </div>
</body>
</html>
