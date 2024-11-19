<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pets - PetCare</title>
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

        <div class="pets-section">
            <div class="search-add">
                <label for="search">Search:</label>
                <input type="text" id="search" name="search" placeholder="Enter pet's name" oninput="searchPets()">
                <button id="add-pet" class="add-pet-btn">+ ADD PET</button>
            </div>

            <div id="pet-list" class="pet-list">
                <?php
                // Fetch all pets initially
                include('../config/db_connection.php');

                $sql = "SELECT id, pet_name FROM pets";
                $result = mysqli_query($conn, $sql);

                if (mysqli_num_rows($result) > 0) {
                    while ($row = mysqli_fetch_assoc($result)) {
                        echo '<div class="pet-item">';
                        echo '<a href="edit_pet.php?id=' . $row['id'] . '">' . $row['pet_name'] . '</a>';
                        echo '</div>';
                    }
                } else {
                    echo "No pets found.";
                }

                // Close the database connection
                mysqli_close($conn);
                ?>
            </div>
        </div>
    </div>

    <script>
        // JavaScript to handle the redirection when "ADD PET" is clicked
        document.getElementById('add-pet').addEventListener('click', function() {
            window.location.href = 'add_pet.php';
        });

        // JavaScript to handle the search functionality
        function searchPets() {
            const searchInput = document.getElementById('search').value;

            // AJAX request to search_pets.php
            fetch(`/config/search_pets.php?search=${searchInput}`)
                .then(response => response.json())
                .then(data => {
                    const petList = document.getElementById('pet-list');
                    petList.innerHTML = ''; // Clear existing pets

                    if (data.length > 0) {
                        // Display each pet in the result
                        data.forEach(pet => {
                            const petItem = document.createElement('div');
                            petItem.classList.add('pet-item');
                            petItem.innerHTML = `<a href="edit_pet.php?id=${pet.id}">${pet.pet_name}</a>`;
                            petList.appendChild(petItem);
                        });
                    } else {
                        // If no pets found, display a message
                        petList.innerHTML = '<p>No pets found.</p>';
                    }
                })
                .catch(error => console.error('Error:', error));
        }
    </script>
</body>
</html>
