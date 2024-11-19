import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'vaccination_details.dart';

class PetRecordsPage extends StatefulWidget {
  final int petId;

  PetRecordsPage({required this.petId});

  @override
  _PetRecordsPageState createState() => _PetRecordsPageState();
}

class _PetRecordsPageState extends State<PetRecordsPage> {
  List<dynamic> appointments = [];
  String petName = 'Loading...'; // Placeholder until fetched
  String? error;

  @override
  void initState() {
    super.initState();
    fetchPetDetails();
    fetchAppointments();
  }

  // Function to fetch pet details (for pet name)
  Future<void> fetchPetDetails() async {
    final url = 'http://rjsaintyulo09.helioho.st/petcare/api/get_pet_details.php?id=${widget.petId}';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse is Map<String, dynamic> && jsonResponse['pet_name'] != null) {
          setState(() {
            petName = jsonResponse['pet_name'];
            error = null;
          });
        } else {
          setState(() {
            error = "Pet not found.";
          });
        }
      } else {
        setState(() {
          error = "Failed to load pet details.";
        });
      }
    } catch (e) {
      setState(() {
        error = "Error fetching data: $e";
      });
    }
  }

  // Function to fetch appointments from the API for the specific petId
  Future<void> fetchAppointments() async {
    final url = 'http://rjsaintyulo09.helioho.st/petcare/api/get_pet_appointments.php?pet_id=${widget.petId}';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse is List) {
          setState(() {
            appointments = jsonResponse;
            error = null;
          });
        } else {
          setState(() {
            error = jsonResponse['error'] ?? "Unexpected error occurred.";
            appointments = [];
          });
        }
      } else {
        setState(() {
          error = "Failed to load appointments.";
          appointments = [];
        });
      }
    } catch (e) {
      setState(() {
        error = "Error fetching data: $e";
        appointments = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pet Records"),
        backgroundColor: Color(0xFF50604E),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '$petName (ID: ${widget.petId})\'s Records',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Center(
            child: Column(
              children: [
                RecordButton(label: 'Primary Course of Vaccination', petId: widget.petId, type: 'primary'),
                RecordButton(label: 'Booster', petId: widget.petId, type: 'booster'),
                RecordButton(label: 'Deworming Record', petId: widget.petId, type: 'deworming'),
                RecordButton(label: 'Rabies Vaccination', petId: widget.petId, type: 'rabies'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Upcoming Appointments',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: error != null
                ? Center(child: Text(error!))
                : appointments.isEmpty
                    ? Center(child: Text("No upcoming appointments"))
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        itemCount: appointments.length,
                        itemBuilder: (context, index) {
                          var appointment = appointments[index];
                          return AppointmentCard(
                            petName: petName,
                            concern: appointment['concern'] ?? 'N/A',
                            email: appointment['email'] ?? 'N/A',
                            phone: appointment['phone'] ?? 'N/A',
                            appointmentDate: appointment['appointment_date'] ?? 'N/A',
                            appointmentTime: _formatTime(appointment['appointment_time']),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  String _formatTime(String time) {
    DateTime parsedTime = DateTime.parse('1970-01-01 $time');
    return "${parsedTime.hour % 12 == 0 ? 12 : parsedTime.hour % 12}:${parsedTime.minute.toString().padLeft(2, '0')} ${parsedTime.hour < 12 ? 'AM' : 'PM'}";
  }
}

class RecordButton extends StatelessWidget {
  final String label;
  final int petId;
  final String type;

  RecordButton({required this.label, required this.petId, required this.type});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VaccinationDetailsPage(petId: petId, type: type),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey.shade800,
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(label),
      ),
    );
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
            Text("Appointment Time: $appointmentTime"),
          ],
        ),
      ),
    );
  }
}
