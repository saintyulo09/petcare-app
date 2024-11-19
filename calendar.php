<?php
// calendar.php

// Database connection (Make sure to include your actual connection details)
include_once '../config/db_connection.php';
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Calendar - PetCare</title>
    <link rel="stylesheet" href="../assets/styles.css">
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
            let currentDate = new Date();
            let selectedCell = null;

            // Render the calendar with dots for booked dates
            function renderCalendar() {
                const calendarBody = document.querySelector('.calendar-body tbody');
                const calendarHeader = document.querySelector('.calendar-header h2');
                const firstDay = new Date(currentDate.getFullYear(), currentDate.getMonth(), 1);
                const lastDay = new Date(currentDate.getFullYear(), currentDate.getMonth() + 1, 0);

                calendarHeader.innerText = `${monthNames[currentDate.getMonth()]} ${currentDate.getFullYear()}`;

                // Clear existing calendar
                calendarBody.innerHTML = '';

                // Fetch booked dates
                fetchBookedDates(currentDate.getFullYear(), currentDate.getMonth() + 1)
                    .then(bookedDates => {
                        let date = 1;
                        const firstDayIndex = (firstDay.getDay() + 6) % 7;
                        const totalDays = lastDay.getDate();

                        for (let i = 0; i < 6; i++) {
                            let row = document.createElement('tr');

                            for (let j = 0; j < 7; j++) {
                                let cell = document.createElement('td');
                                cell.style.position = 'relative';

                                if (i === 0 && j < firstDayIndex) {
                                    cell.innerText = '';
                                } else if (date > totalDays) {
                                    cell.innerText = '';
                                } else {
                                    cell.innerText = date;

                                    // Format date to YYYY-MM-DD for matching
                                    const dateStr = `${currentDate.getFullYear()}-${String(currentDate.getMonth() + 1).padStart(2, '0')}-${String(date).padStart(2, '0')}`;
                                    if (bookedDates.includes(dateStr)) {
                                        cell.classList.add('booked-date');
                                        const dot = document.createElement('span');
                                        dot.classList.add('dot');
                                        cell.appendChild(dot);
                                    }

                                    // Highlight selected date and fetch appointments when clicked
                                    cell.addEventListener('click', function() {
                                        if (selectedCell) {
                                            selectedCell.classList.remove('highlight');
                                        }
                                        cell.classList.add('highlight');
                                        selectedCell = cell;

                                        // Fetch and display appointments for the selected date
                                        fetchAppointments(dateStr);
                                    });

                                    date++;
                                }
                                row.appendChild(cell);
                            }

                            calendarBody.appendChild(row);
                        }
                    })
                    .catch(error => console.error('Error fetching booked dates:', error));
            }

            // Fetch booked dates for the month
            function fetchBookedDates(year, month) {
                return fetch(`../config/fetch_booked_dates.php?year=${year}&month=${month}`)
                    .then(response => response.json());
            }

            // Fetch and display appointments for a specific day
            function fetchAppointments(date) {
                fetch(`../config/fetch_appointments.php?date=${date}`)
                    .then(response => response.json())
                    .then(data => {
                        const appointmentSection = document.querySelector('.appointments');
                        appointmentSection.innerHTML = '';

                        if (data.length === 0) {
                            appointmentSection.innerHTML = '<p>No appointments for this date.</p>';
                        } else {
                            data.forEach(appointment => {
                                const appointmentDiv = document.createElement('div');
                                appointmentDiv.classList.add('appointment-item');
                                appointmentDiv.innerHTML = `
                                    <div class="appointment-details">
                                        <h3>${appointment.full_name}</h3>
                                        <p><strong>Concern:</strong> ${appointment.concern}</p>
                                        <p><strong>Email:</strong> ${appointment.email}</p>
                                        <p><strong>Phone:</strong> ${appointment.phone}</p>
                                        <p><strong>Appointment Date:</strong> ${new Date(appointment.appointment_date).toLocaleDateString()}</p>
                                        <p><strong>Appointment Time:</strong> ${new Date('1970-01-01T' + appointment.appointment_time).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}</p>
                                    </div>
                                    <div class="appointment-actions">
                                        <form method="POST" action="../config/edit_delete_appointment.php" style="display:inline;">
                                            <input type="hidden" name="appointment_id" value="${appointment.id}" />
                                            <button type="submit" name="action" value="edit" class="btn btn-edit">Edit</button>
                                        </form>
                                        <form method="POST" action="../config/edit_delete_appointment.php" style="display:inline;">
                                            <input type="hidden" name="appointment_id" value="${appointment.id}" />
                                            <button type="submit" name="action" value="delete" class="btn btn-delete" onclick="return confirm('Are you sure you want to delete this appointment?');">Delete</button>
                                        </form>
                                    </div>
                                `;
                                appointmentSection.appendChild(appointmentDiv);
                            });
                        }
                    })
                    .catch(error => console.error('Error fetching appointments:', error));
            }

            // Next/Previous month buttons
            document.querySelector('#next').addEventListener('click', function() {
                currentDate.setMonth(currentDate.getMonth() + 1);
                renderCalendar();
            });

            document.querySelector('#prev').addEventListener('click', function() {
                currentDate.setMonth(currentDate.getMonth() - 1);
                renderCalendar();
            });

            renderCalendar();
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

        <div class="calendar">
            <div class="calendar-header">
                <button id="prev">&lt;</button>
                <h2>September 2024</h2>
                <button id="next">&gt;</button>
            </div>

            <div class="calendar-body">
                <table>
                    <thead>
                        <tr>
                            <th>Mon</th>
                            <th>Tue</th>
                            <th>Wed</th>
                            <th>Thu</th>
                            <th>Fri</th>
                            <th>Sat</th>
                            <th>Sun</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- Calendar will be dynamically generated here -->
                    </tbody>
                </table>
            </div>
        </div>

        <div class="appointments">
            <!-- Appointments for the selected date will appear here -->
        </div>
    </div>
</body>
</html>
