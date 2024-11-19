import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../main.dart';
import 'calendar.dart';
import 'book.dart';
import 'profile.dart';
import 'pet_details.dart';

class PetsPage extends StatefulWidget {
  @override
  _PetsPageState createState() => _PetsPageState();
}

class _PetsPageState extends State<PetsPage> {
  int _selectedIndex = 3; 
  List<Map<String, dynamic>> pets = []; 
  bool isLoading = true; 
  bool hasError = false;
  String searchQuery = ""; // Initialize the search query as empty

  @override
  void initState() {
    super.initState();
    fetchPets(); 
  }

  // Function to fetch pet data from the API with optional search query
  Future<void> fetchPets({String query = ""}) async {
    final url = 'http://rjsaintyulo09.helioho.st/petcare/api/get_pets.php?search=$query';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> petsJson = json.decode(response.body);

        setState(() {
          pets = petsJson.map((json) => {
            'name': json['pet_name'] ?? 'No Name',
            'id': json['id'] != null ? int.tryParse(json['id'].toString()) ?? 0 : 0,
          }).toList();
          isLoading = false;
          hasError = false;
        });
      } else {
        setState(() {
          isLoading = false;
          hasError = true;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      searchQuery = query;
      isLoading = true;
    });
    fetchPets(query: searchQuery);
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PetCareHome()),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CalendarPage()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BookAppointmentPage()),
      );
    } else if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF50604E),
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'My Pets',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Text(
                  'Search:',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(width: 5),
                Container(
                  width: 120,
                  height: 35,
                  child: TextField(
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                      border: OutlineInputBorder(),
                      hintText: 'Enter pet name',
                      isDense: true,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : pets.isEmpty
              ? Center(
                  child: hasError
                      ? Text(
                          "Failed to load pets. Please try again.",
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        )
                      : Text(
                          "No pets found.",
                          style: TextStyle(fontSize: 16),
                        ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16.0),
                  itemCount: pets.length,
                  itemBuilder: (context, index) {
                    final pet = pets[index];
                    final petName = pet['name'] ?? 'Unknown'; 
                    final petId = pet['id'] ?? 0; 

                    if (petId == 0) {
                      return SizedBox.shrink();
                    }

                    return PetCard(
                      petName: petName,
                      petId: petId,
                    );
                  },
                ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFF50604E),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.6),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'Pets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class PetCard extends StatelessWidget {
  final String petName;
  final int petId;

  PetCard({required this.petName, required this.petId});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFF50604E),
      child: ListTile(
        leading: CircleAvatar(
          radius: 20,
          backgroundColor: Colors.white,
          child: Icon(
            Icons.pets,
            color: Color(0xFF50604E),
          ),
        ),
        title: Text(
          petName,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PetDetailsPage(petId: petId),
            ),
          );
        },
      ),
    );
  }
}
