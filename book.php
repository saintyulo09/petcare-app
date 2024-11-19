<?php
// Connect to the database
$conn = new mysqli('localhost', 'root', '', 'petcare');

// Check for connection errors
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$success = false;  // Variable to track booking status

// Handle form submission
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $fullName = $_POST['full-name'];
    $email = $_POST['email'];
    $phone = $_POST['phone'];
    $appointmentDate = $_POST['date'];
    $appointmentTime = $_POST['time'];
    $concern = $_POST['concern'];
    $petId = $_POST['pet-id'];  // Get pet ID from form

    // Insert into database, including appointment_time
    $sql = "INSERT INTO appointments (pet_id, full_name, email, phone, appointment_date, appointment_time, concern) 
            VALUES ('$petId', '$fullName', '$email', '$phone', '$appointmentDate', '$appointmentTime', '$concern')";
    
    if ($conn->query($sql) === TRUE) {
        $success = true;  // Set success flag to true on successful booking
    } else {
        echo "Error: " . $sql . "<br>" . $conn->error;
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Appointment - PetCare</title>
    <link rel="stylesheet" href="../assets/styles.css">
    <script>
        // Show the success popup if the booking was successful
        document.addEventListener('DOMContentLoaded', function() {
            <?php if ($success) { ?>
                alert('Booked Successfully!');
            <?php } ?>
        });
    </script>
</head>
<body>
    <div class="sidebar">
        <ul>
            <li><a href="../index.php"><img src="../assets/icons/home.png" alt="Home"></a></li>
            <li><a href="calendar.php"><img src="../assets/icons/calendar.png" alt="Calendar"></a></li>
            <li><a href="book.php"><img src="../assets/icons/plus.png" alt="Book Appointment"></a></li>
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

        <div class="appointment-section">
            <h2>Book your appointment now</h2>
            <p>So our staff can reach out to you on time</p>

            <form class="appointment-form" method="POST" action="">
                <label for="pet-id">Pet ID</label>
                <input type="text" id="pet-id" name="pet-id" placeholder="Enter your pet's ID" required>

                <label for="full-name">Pet's Name</label>
                <input type="text" id="full-name" name="full-name" placeholder="Enter your pet's name" required>

                <label for="email">Email</label>
                <input type="email" id="email" name="email" placeholder="Enter your email" required>

                <label for="phone">Phone Number</label>
                <input type="text" id="phone" name="phone" placeholder="Enter your phone number" required>

                <label for="date">Available Date</label>
                <input type="date" id="date" name="date" required>

                <label for="time">Available Time</label>
                <select id="time" name="time" required>
                    <option value="">Select a time</option>
                    <option value="09:00">09:00 AM</option>
                    <option value="10:00">10:00 AM</option>
                    <option value="11:00">11:00 AM</option>
                    <option value="12:00">12:00 PM</option>
                    <option value="13:00">01:00 PM</option>
                    <option value="14:00">02:00 PM</option>
                    <option value="15:00">03:00 PM</option>
                    <option value="16:00">04:00 PM</option>
                    <option value="17:00">05:00 PM</option>
                </select>

                <label for="concern">What’s your concern for your Pet?</label>
                <textarea id="concern" name="concern" placeholder="Describe your concern" required></textarea>

                <button type="submit" class="book-btn">Book Now</button>
            </form>
        </div>
    </div>
</body>
</html>
