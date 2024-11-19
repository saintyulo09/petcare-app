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
} else {
    echo "Invalid pet ID!";
    exit;
}

// Update pet details if form is submitted
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['update_pet'])) {
    $pet_name = $_POST['pet_name'];
    $dob = $_POST['dob'];
    $breed = $_POST['breed'];
    $sex = $_POST['sex'];
    $color = $_POST['color'];
    $owner_name = $_POST['owner_name'];
    $address = $_POST['address'];
    $contact_nos = $_POST['contact_nos'];

    $update_sql = "UPDATE pets SET pet_name = '$pet_name', dob = '$dob', breed = '$breed', sex = '$sex', color = '$color', owner_name = '$owner_name', address = '$address', contact_nos = '$contact_nos' WHERE id = $pet_id";

    if (mysqli_query($conn, $update_sql)) {
        echo "Pet details updated successfully!";
    } else {
        echo "Error updating record: " . mysqli_error($conn);
    }

    // Refresh the page to show updated data
    header("Location: edit_pet.php?id=$pet_id");
    exit();
}

// Handle pet deletion
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['delete_pet'])) {
    $delete_sql = "DELETE FROM pets WHERE id = $pet_id";
    
    if (mysqli_query($conn, $delete_sql)) {
        // Redirect to the pets list after deletion
        header("Location: pets.php");
        exit();
    } else {
        echo "Error deleting pet: " . mysqli_error($conn);
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
    <title>Edit Pet Profile - PetCare</title>
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

    <div class="main-content">
        <h2>Edit Pet Details</h2>
        <button class="bookmark-btn" title="Booklet" onclick="window.location.href='pet_records.php?id=<?php echo $pet_id; ?>'">
    <img src="../assets/icons/bookmark-icon.png" alt="Bookmark"> <!-- Add your icon file here -->
        </button>

        <form method="POST">
            <label for="pet_name">Pet Name:</label>
            <input type="text" id="pet_name" name="pet_name" value="<?php echo $pet['pet_name']; ?>" required>

            <label for="dob">Date of Birth:</label>
            <input type="date" id="dob" name="dob" value="<?php echo $pet['dob']; ?>" required>

            <label for="breed">Breed:</label>
            <input type="text" id="breed" name="breed" value="<?php echo $pet['breed']; ?>" required>

            <label for="sex">Sex:</label>
            <select id="sex" name="sex" required>
                <option value="male" <?php if ($pet['sex'] == 'male') echo 'selected'; ?>>Male</option>
                <option value="female" <?php if ($pet['sex'] == 'female') echo 'selected'; ?>>Female</option>
            </select>

            <label for="color">Color:</label>
            <input type="text" id="color" name="color" value="<?php echo $pet['color']; ?>" required>

            <label for="owner_name">Owner's Name:</label>
            <input type="text" id="owner_name" name="owner_name" value="<?php echo $pet['owner_name']; ?>" required>

            <label for="address">Address:</label>
            <input type="text" id="address" name="address" value="<?php echo $pet['address']; ?>" required>

            <label for="contact_nos">Contact Nos:</label>
            <input type="text" id="contact_nos" name="contact_nos" value="<?php echo $pet['contact_nos']; ?>" required>

            <!-- Button Group for Save and Delete -->
            <div class="button-group">
                    <button type="submit" name="update_pet" class="save-btn">Save</button>
                    <button type="submit" name="action" value="delete" class="btn btn-delete" onclick="return confirm('Are you sure you want to delete this Pet Details?');">Delete</button>

                </div>
            </form>
        </div>
    </div>


</body>
</html>

