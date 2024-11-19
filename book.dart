import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../main.dart';
import '/pages/calendar.dart';
import '/pages/pets.dart';
import '/pages/profile.dart';

class BookAppointmentPage extends StatefulWidget {
  @override
  _BookAppointmentPageState createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  DateTime? _selectedDate;
  String? _selectedTime;
  int _selectedIndex = 2;

  final List<String> _timeOptions = [
    '8:00 AM', '9:00 AM', '10:00 AM', '11:00 AM', '12:00 PM',
    '1:00 PM', '2:00 PM', '3:00 PM', '4:00 PM', '5:00 PM'
  ];

  final TextEditingController _petIdController = TextEditingController();
  final TextEditingController _petNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _concernController = TextEditingController();

  void _onItemTapped(int index) {
    if (index == 0) Navigator.push(context, MaterialPageRoute(builder: (context) => PetCareHome()));
    else if (index == 1) Navigator.push(context, MaterialPageRoute(builder: (context) => CalendarPage()));
    else if (index == 3) Navigator.push(context, MaterialPageRoute(builder: (context) => PetsPage()));
    else if (index == 4) Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
  }

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submitAppointment() async {
    final response = await http.post(
      Uri.parse('http://rjsaintyulo09.helioho.st/petcare/api/create_appointment.php'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "pet_id": _petIdController.text,
        "full_name": _petNameController.text,
        "email": _emailController.text,
        "phone": _phoneController.text,
        "appointment_date": _selectedDate?.toIso8601String().split('T').first,
        "appointment_time": _selectedTime,
        "concern": _concernController.text,
      }),
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result["success"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Appointment booked successfully!")));
        Navigator.push(context, MaterialPageRoute(builder: (context) => CalendarPage()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result["error"] ?? "Failed to book appointment")));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to connect to the server")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color(0xFF50604E), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Book your appointment now', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
            SizedBox(height: 8),
            AppointmentTextField(label: 'Pet ID', controller: _petIdController),
            AppointmentTextField(label: 'Pet Name', controller: _petNameController),
            AppointmentTextField(label: 'Email', controller: _emailController),
            AppointmentTextField(label: 'Phone Number', controller: _phoneController, prefixText: '+63'),
            GestureDetector(
              onTap: _pickDate,
              child: AbsorbPointer(
                child: AppointmentTextField(
                  label: 'Available Date',
                  hintText: _selectedDate == null
                      ? 'Select Date'
                      : '${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year}',
                ),
              ),
            ),
            DropdownField(
              label: 'Time for Appointment',
              items: _timeOptions,
              selectedItem: _selectedTime,
              onChanged: (value) => setState(() => _selectedTime = value),
            ),
            AppointmentTextField(label: 'What’s your concern for your Pet’s', controller: _concernController, maxLines: 4),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _submitAppointment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF50604E),
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [Text('Book Now', style: TextStyle(fontSize: 16, color: Colors.white)), SizedBox(width: 8), Icon(Icons.arrow_forward, color: Colors.white)],
                ),
              ),
            ),
          ],
        ),
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
}

class AppointmentTextField extends StatelessWidget {
  final String label;
  final bool obscureText;
  final int maxLines;
  final String? prefixText;
  final String? hintText;
  final TextEditingController? controller;

  AppointmentTextField({
    required this.label,
    this.obscureText = false,
    this.maxLines = 1,
    this.prefixText,
    this.hintText,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          TextField(
            controller: controller,
            obscureText: obscureText,
            maxLines: maxLines,
            decoration: InputDecoration(
              prefixText: prefixText,
              hintText: hintText,
              border: OutlineInputBorder(),
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              filled: true,
              fillColor: Colors.grey.shade100,
            ),
          ),
        ],
      ),
    );
  }
}

class DropdownField extends StatelessWidget {
  final String label;
  final List<String> items;
  final String? selectedItem;
  final ValueChanged<String?> onChanged;

  DropdownField({
    required this.label,
    required this.items,
    this.selectedItem,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          DropdownButtonFormField<String>(
            value: selectedItem,
            onChanged: onChanged,
            items: items
                .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                .toList(),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              filled: true,
              fillColor: Colors.grey.shade100,
            ),
          ),
        ],
      ),
    );
  }
}
