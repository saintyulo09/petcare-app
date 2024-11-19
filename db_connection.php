<?php
// db_connection.php

$servername = "localhost"; // or your database server
$username = "root"; // your MySQL username
$password = ""; // your MySQL password (blank for XAMPP default)
$dbname = "petcare"; // your database name

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>
