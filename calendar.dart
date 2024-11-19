import 'package:flutter/material.dart';
import '../main.dart';
import 'book.dart';
import 'pets.dart';
import 'profile.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Add this for time formatting

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  int _selectedIndex = 1;
  Map<DateTime, List> _appointments = {};
  List _selectedDayAppointments = [];

  @override
  void initState() {
    super.initState();
    _fetchAppointmentsForMonth();
  }

  void _onItemTapped(int index) {
    if (index == 0) Navigator.push(context, MaterialPageRoute(builder: (context) => PetCareHome()));
    else if (index == 2) Navigator.push(context, MaterialPageRoute(builder: (context) => BookAppointmentPage()));
    else if (index == 3) Navigator.push(context, MaterialPageRoute(builder: (context) => PetsPage()));
    else if (index == 4) Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
  }

  Future<void> _fetchAppointmentsForMonth() async {
    final response = await http.get(Uri.parse('http://rjsaintyulo09.helioho.st/petcare/api/get_appointments.php'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _appointments = {};
        for (var appointment in data) {
          DateTime appointmentDate = DateTime.parse(appointment['appointment_date']);
          final dayKey = DateTime(appointmentDate.year, appointmentDate.month, appointmentDate.day);
          if (_appointments[dayKey] == null) {
            _appointments[dayKey] = [];
          }
          _appointments[dayKey]!.add(appointment);
        }
      });
    }
  }

  void _fetchAppointmentsForSelectedDay(DateTime selectedDay) {
    setState(() {
      _selectedDay = selectedDay;
      final dayKey = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
      _selectedDayAppointments = _appointments[dayKey] ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color(0xFF50604E), elevation: 0),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Appointments',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF50604E)),
              ),
            ),
          ),
          Center(
            child: Text(
              '${_focusedDay.day} ${_getMonthName(_focusedDay.month)} ${_focusedDay.year}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          TableCalendar(
            firstDay: DateTime.utc(2022, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
              _fetchAppointmentsForSelectedDay(selectedDay);
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, events) {
                final dayKey = DateTime(day.year, day.month, day.day);
                if (_appointments.containsKey(dayKey)) {
                  return Positioned(
                    right: 1,
                    bottom: 1,
                    child: Container(
                      width: 8.0,
                      height: 8.0,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                }
                return null;
              },
            ),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(color: Colors.green.shade200, shape: BoxShape.circle),
              selectedDecoration: BoxDecoration(color: Colors.green.shade400, shape: BoxShape.circle),
            ),
            headerStyle: HeaderStyle(formatButtonVisible: false, titleCentered: true),
            calendarFormat: CalendarFormat.month,
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: _selectedDayAppointments.length,
              itemBuilder: (context, index) {
                var appointment = _selectedDayAppointments[index];
                return AppointmentCard(
                  petName: appointment['full_name'],
                  concern: appointment['concern'],
                  email: appointment['email'],
                  phone: appointment['phone'],
                  appointmentDate: appointment['appointment_date'],
                  appointmentTime: appointment['appointment_time'],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFF50604E),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.6),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Appointments'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: 'Add'),
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Pets'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1: return 'Jan';
      case 2: return 'Feb';
      case 3: return 'Mar';
      case 4: return 'Apr';
      case 5: return 'May';
      case 6: return 'Jun';
      case 7: return 'Jul';
      case 8: return 'Aug';
      case 9: return 'Sept';
      case 10: return 'Oct';
      case 11: return 'Nov';
      case 12: return 'Dec';
      default: return '';
    }
  }
}

class AppointmentCard extends StatelessWidget {
  final String petName;
  final String concern;
  final String email;
  final String phone;
  final String appointmentDate;
  final String appointmentTime;

  AppointmentCard({
    required this.petName,
    required this.concern,
    required this.email,
    required this.phone,
    required this.appointmentDate,
    required this.appointmentTime,
  });

  String _formatTime(String time) {
    try {
      final dateTime = DateFormat("HH:mm:ss").parse(time);
      return DateFormat("h:mm a").format(dateTime); // Format as "10:00 AM" or "2:30 PM"
    } catch (e) {
      return time; // If parsing fails, return original time string
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              petName,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text("Concern: $concern"),
            Text("Email: $email"),
            Text("Phone: $phone"),
            Text("Appointment Date: $appointmentDate"),
            Text("Appointment Time: ${_formatTime(appointmentTime)}"),
          ],
        ),
      ),
    );
  }
}
