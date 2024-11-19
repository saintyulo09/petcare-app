<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Profile - PetCare</title>
    <link rel="stylesheet" href="../assets/styles.css">
</head>
<body>
    <div class="sidebar">
        <ul>
            <li><a href="../index.php"><img src="../assets/icons/home.png" alt="Home"></a></li>
            <li><a href="calendar.php"><img src="../assets/icons/calendar.png" alt="Calendar"></a></li>
            <li><a href="book.php"><img src="../assets/icons/plus.png" alt="Add"></a></li>
            <li><a href="pets.php"><img src="../assets/icons/paw.png" alt="Pets"></a></li>
            <li><a href="profile.php"><img src="../assets/icons/user.png" alt="Profile"></a></li> <!-- Active page -->
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

        <div class="profile-section">
            <h2>Edit Profile</h2>

            <div class="profile-image">
                <img src="../assets/images/user-profile.png" alt="Profile Picture">
                <label for="upload-photo">
                    <img src="../assets/icons/camera.png" alt="Upload Photo Icon">
                </label>
                <input type="file" id="upload-photo" name="photo" accept="image/*" style="display:none">
            </div>

            <form class="profile-form">
                <label for="name">Name</label>
                <input type="text" id="name" name="name" placeholder="Enter your name">

                <label for="email">Email</label>
                <input type="email" id="email" name="email" placeholder="Enter your email">

                <label for="password">Password</label>
                <input type="password" id="password" name="password" placeholder="Enter new password">

                <label for="confirm-password">Re-type Password</label>
                <input type="password" id="confirm-password" name="confirm-password" placeholder="Re-type new password">

                <button type="submit" class="save-btn">Save changes</button>
            </form>
        </div>
    </div>
</body>
</html>
