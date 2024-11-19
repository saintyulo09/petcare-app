<?php
// Include database connection
include('../config/db_connection.php');

// Initialize variables
$boosters = [];

// Check if both 'pet_id' is set in the query parameters
if (isset($_GET['pet_id'])) {
    $pet_id = $_GET['pet_id'];

    // Search functionality
    $search = "";
    if (isset($_POST['search'])) {
        $search = $_POST['search'];
    }

    // Fetch pet booster vaccination records
    $sql = "SELECT * FROM vaccination_records WHERE pet_id = $pet_id AND type = 'booster' AND (vaccine_name LIKE '%$search%' OR administered_by LIKE '%$search%')";
    $result = mysqli_query($conn, $sql);

    if (mysqli_num_rows($result) > 0) {
        $boosters = mysqli_fetch_all($result, MYSQLI_ASSOC);
    }
} else {
    echo "Invalid request!";
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
    <title>Booster Vaccination Details - PetCare</title>
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

        <div class="booster-details">
            <h2>Booster Vaccination Records</h2>

            <!-- Flex container for search bar and add button -->
            <div class="top-controls">
                <form method="POST" action="" class="search-form">
                    <label for="search">Search:</label>
                    <input type="text" id="search" name="search" value="<?php echo isset($search) ? $search : ''; ?>" placeholder="Search by vaccine or veterinarian">
                </form>

                <!-- Add Button -->
                <button class="add-btn" onclick="window.location.href='add_booster.php?type=booster&pet_id=<?php echo $pet_id; ?>'">+ ADD</button>
            </div>

            <!-- Booster Records Table -->
            <?php if (!empty($boosters)): ?>
                <table class="booster-table">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Date Given</th>
                            <th>Date Due</th>
                            <th>Vaccine Against</th>
                            <th>Veterinarian</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php $i = 1; foreach ($boosters as $booster): ?>
                            <tr>
                                <td><?php echo $i++; ?></td>
                                <td><?php echo $booster['date_given']; ?></td>
                                <td><?php echo $booster['date_due']; ?></td>
                                <td><?php echo $booster['vaccine_name']; ?></td>
                                <td><?php echo $booster['administered_by']; ?></td>
                                <td>
                                    <!-- Edit and Delete Icons -->
                                    <a href="edit_vaccination.php?id=<?php echo $booster['id']; ?>"><img src="../assets/icons/edit.png" alt="Edit"></a>
                                    <a href="delete_vaccination.php?id=<?php echo $booster['id']; ?>" onclick="return confirm('Are you sure you want to delete this record?');"><img src="../assets/icons/delete.png" alt="Delete"></a>
                                </td>
                            </tr>
                        <?php endforeach; ?>
                    </tbody>
                </table>
            <?php else: ?>
                <p>No booster vaccination records available for this pet.</p>
            <?php endif; ?>
        </div>
    </div>
</body>
</html>
