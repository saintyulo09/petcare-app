<?php
// Assuming you have a connection to a database
include('../config/db_connection.php');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Collect form data
    $pet_name = $_POST['pet_name'];
    $dob = $_POST['dob'];
    $breed = $_POST['breed'];
    $sex = $_POST['sex'];
    $color = $_POST['color'];
    $owner_name = $_POST['owner_name'];
    $address = $_POST['address'];
    $contact_nos = $_POST['contact_nos'];

    // Insert data into the database (example query)
    $sql = "INSERT INTO pets (pet_name, dob, breed, sex, color, owner_name, address, contact_nos)
            VALUES ('$pet_name', '$dob', '$breed', '$sex', '$color', '$owner_name', '$address', '$contact_nos')";

    if (mysqli_query($conn, $sql)) {
        echo "Pet profile added successfully!";
    } else {
        echo "Error: " . mysqli_error($conn);
    }

    // Close the database connection
    mysqli_close($conn);
}
?>
