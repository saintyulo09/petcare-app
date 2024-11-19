import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'pet_records.dart';

class PetDetailsPage extends StatefulWidget {
  final int petId;

  PetDetailsPage({required this.petId});

  @override
  _PetDetailsPageState createState() => _PetDetailsPageState();
}

class _PetDetailsPageState extends State<PetDetailsPage> {
  Map<String, dynamic>? petDetails;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchPetDetails();
  }

  // Function to fetch pet details from the API
  Future<void> fetchPetDetails() async {
    final url = 'http://rjsaintyulo09.helioho.st/petcare/api/get_pet_details.php?id=${widget.petId}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      try {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse.containsKey('error')) {
          setState(() {
            petDetails = null;
            error = jsonResponse['error'];
          });
        } else {
          setState(() {
            petDetails = jsonResponse;
            error = null;
          });
        }
      } catch (e) {
        setState(() {
          error = "Failed to parse pet details";
          petDetails = null;
        });
      }
    } else {
      setState(() {
        error = "Failed to load pet details";
        petDetails = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF50604E),
        title: Text('Pet Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.book), // Booklet icon
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PetRecordsPage(petId: widget.petId),
                ),
              );
            },
          ),
        ],
      ),
      body: error != null
          ? Center(
              child: Text(
                error!,
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            )
          : petDetails == null
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDetailRow(Icons.pets, 'Pet Name', petDetails!['pet_name']),
                              _buildDetailRow(Icons.cake, 'Date of Birth', petDetails!['date_of_birth']),
                              _buildDetailRow(Icons.category, 'Breed', petDetails!['breed']),
                              _buildDetailRow(Icons.transgender, 'Sex', petDetails!['sex']),
                              _buildDetailRow(Icons.color_lens, 'Color', petDetails!['color']),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Owner Information',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Divider(thickness: 1),
                              _buildDetailRow(Icons.person, 'Owner\'s Name', petDetails!['owner_name']),
                              _buildDetailRow(Icons.location_on, 'Address', petDetails!['address']),
                              _buildDetailRow(Icons.phone, 'Contact Nos', petDetails!['contact_number']),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFF50604E)),
          SizedBox(width: 12),
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
