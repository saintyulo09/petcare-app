<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Pet Profile - PetCare</title>
    <link rel="stylesheet" href="../assets/styles.css"> <!-- Assuming the CSS path -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script> <!-- Include jQuery -->
    <script>
        $(document).ready(function() {
            // Attach an event listener to the form submission
            $('.pet-profile-form').on('submit', function(event) {
                event.preventDefault(); // Prevent the form from submitting the traditional way

                // Serialize form data
                var formData = $(this).serialize();

                // Send form data via AJAX to process_add_pet.php
                $.ajax({
                    url: '../process/process_add_pet.php',  // The PHP script
                    type: 'POST',
                    data: formData,
                    success: function(response) {
                        // Show a success message in a popup
                        alert(response);
                    },
                    error: function(xhr, status, error) {
                        // Handle errors
                        alert('An error occurred: ' + error);
                    }
                });
            });
        });
    </script>
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

        <div class="pet-profile-section">
            <h2>Pet Profile</h2>

            <!-- The form will now use AJAX for submission -->
            <form class="pet-profile-form" method="POST">
                <label for="pet_name">Pet Name:</label>
                <input type="text" id="pet_name" name="pet_name" required>

                <label for="dob">Date of Birth:</label>
                <input type="date" id="dob" name="dob" required>

                <label for="breed">Breed:</label>
                <input type="text" id="breed" name="breed" required>

                <label for="sex">Sex:</label>
                <select id="sex" name="sex" required>
                    <option value="male">Male</option>
                    <option value="female">Female</option>
                </select>

                <label for="color">Color:</label>
                <input type="text" id="color" name="color" required>

                <label for="owner_name">Owner's Name:</label>
                <input type="text" id="owner_name" name="owner_name" required>

                <label for="address">Address:</label>
                <input type="text" id="address" name="address" required>

                <label for="contact_nos">Contact Nos:</label>
                <input type="text" id="contact_nos" name="contact_nos" required>

                <button type="submit" class="save-btn">ADD</button>
            </form>
        </div>
    </div>
</body>
</html>
