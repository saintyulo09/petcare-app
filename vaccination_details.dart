import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class VaccinationDetailsPage extends StatefulWidget {
  final int petId;
  final String type;

  VaccinationDetailsPage({required this.petId, required this.type});

  @override
  _VaccinationDetailsPageState createState() => _VaccinationDetailsPageState();
}

class _VaccinationDetailsPageState extends State<VaccinationDetailsPage> {
  List<dynamic> vaccinations = [];
  String? error;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    fetchVaccinations();
  }

  Future<void> fetchVaccinations() async {
    final url =
        'http://rjsaintyulo09.helioho.st/petcare/api/get_vaccinations.php?pet_id=${widget.petId}&type=${widget.type}&search=$searchQuery';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        setState(() {
          vaccinations = jsonResponse is List ? jsonResponse : [];
          error = null;
        });
      } else {
        setState(() {
          error = "Failed to load vaccination records.";
          vaccinations = [];
        });
      }
    } catch (e) {
      setState(() {
        error = "Error fetching data: $e";
        vaccinations = [];
      });
    }
  }

  void _onSearchChanged(String value) {
    setState(() {
      searchQuery = value;
    });
    fetchVaccinations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.type} - Vaccination Records"),
        backgroundColor: Color(0xFF50604E),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                labelText: "Search by vaccine or veterinarian",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: error != null
                ? Center(child: Text(error!))
                : vaccinations.isEmpty
                    ? Center(child: Text("No vaccination records available for ${widget.type}."))
                    : ListView.builder(
                        padding: EdgeInsets.all(16.0),
                        itemCount: vaccinations.length,
                        itemBuilder: (context, index) {
                          var vaccination = vaccinations[index];
                          return VaccinationCard(
                            dateGiven: vaccination['date_given'] ?? 'N/A',
                            dateDue: vaccination['date_due'] ?? 'N/A',
                            vaccineName: vaccination['vaccine_name'] ?? 'N/A',
                            administeredBy: vaccination['administered_by'] ?? 'N/A',
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class VaccinationCard extends StatelessWidget {
  final String dateGiven;
  final String dateDue;
  final String vaccineName;
  final String administeredBy;

  VaccinationCard({
    required this.dateGiven,
    required this.dateDue,
    required this.vaccineName,
    required this.administeredBy,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today, color: Color(0xFF50604E)),
                SizedBox(width: 8),
                Text(
                  "Date Given:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Text(
                  dateGiven,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.event, color: Color(0xFF50604E)),
                SizedBox(width: 8),
                Text(
                  "Date Due:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Text(
                  dateDue,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            Divider(color: Colors.grey.shade300, height: 20),
            Row(
              children: [
                Icon(Icons.local_hospital, color: Color(0xFF50604E)),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Vaccine Against:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        vaccineName,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.person, color: Color(0xFF50604E)),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Administered By:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        administeredBy,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
